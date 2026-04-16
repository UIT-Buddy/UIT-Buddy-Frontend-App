import 'package:fpdart/fpdart.dart' show Either;
import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/shared_student_entity.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/storage_cursor_params.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/storage_friend_entity.dart';
import 'package:uit_buddy_mobile/features/storage/domain/usecases/get_shared_users_usecase.dart';
import 'package:uit_buddy_mobile/features/storage/domain/usecases/share_resource_usecase.dart';
import 'package:uit_buddy_mobile/features/storage/domain/usecases/storage_get_friends_usecase.dart';
import 'package:uit_buddy_mobile/features/storage/domain/usecases/unshare_usecase.dart';

enum StorageShareResourceType { document, folder }

enum StorageShareActionMode { share, manageSharedUsers }

extension _StorageShareResourceTypeX on StorageShareResourceType {
  String get displayName {
    switch (this) {
      case StorageShareResourceType.document:
        return 'document';
      case StorageShareResourceType.folder:
        return 'folder';
    }
  }

  String get apiPrimary {
    switch (this) {
      case StorageShareResourceType.document:
        return 'FILE';
      case StorageShareResourceType.folder:
        return 'FOLDER';
    }
  }

  String get apiFallback {
    switch (this) {
      case StorageShareResourceType.document:
        return 'FILE';
      case StorageShareResourceType.folder:
        return 'FOLDER';
    }
  }
}

class StorageAccessManagementScreen extends StatefulWidget {
  const StorageAccessManagementScreen({
    super.key,
    required this.resourceId,
    required this.resourceName,
    required this.resourceType,
    required this.mode,
  });

  final String resourceId;
  final String resourceName;
  final StorageShareResourceType resourceType;
  final StorageShareActionMode mode;

  @override
  State<StorageAccessManagementScreen> createState() =>
      _StorageAccessManagementScreenState();
}

class _StorageAccessManagementScreenState
    extends State<StorageAccessManagementScreen> {
  static const int _pageSize = 20;

  late final TextEditingController _searchController;
  late final ScrollController _scrollController;

  late final ShareResourceUsecase _shareResourceUsecase;
  late final GetSharedUsersUsecase _getSharedUsersUsecase;
  late final UnshareUsecase _unshareUsecase;
  late final StorageGetFriendsUsecase _storageGetFriendsUsecase;

  String _searchQuery = '';
  bool _isInitialLoading = false;
  bool _isLoadingMore = false;
  bool _isPerformingAction = false;
  String? _activeActionMssv;
  String? _errorMessage;

  List<SharedStudentEntity> _sharedUsers = const [];
  int _sharedUsersPage = 1;
  bool _sharedUsersHasMore = true;

  List<StorageFriendEntity> _friends = const [];
  String? _friendsNextCursor;
  bool _friendsHasMore = true;

  final Set<String> _newlySharedMssvs = <String>{};

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()..addListener(_onSearchChanged);
    _scrollController = ScrollController()..addListener(_onScroll);

    _shareResourceUsecase = serviceLocator<ShareResourceUsecase>();
    _getSharedUsersUsecase = serviceLocator<GetSharedUsersUsecase>();
    _unshareUsecase = serviceLocator<UnshareUsecase>();
    _storageGetFriendsUsecase = serviceLocator<StorageGetFriendsUsecase>();

    _loadInitial();
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  List<String> get _resourceTypeCandidates {
    final primary = widget.resourceType.apiPrimary;
    final fallback = widget.resourceType.apiFallback;
    return primary == fallback ? [primary] : [primary, fallback];
  }

  List<SharedStudentEntity> get _filteredSharedUsers {
    if (_searchQuery.isEmpty) {
      return _sharedUsers;
    }

    return _sharedUsers.where((entry) {
      final name = entry.student.fullName.toLowerCase();
      final mssv = entry.student.mssv.toLowerCase();
      return name.contains(_searchQuery) || mssv.contains(_searchQuery);
    }).toList();
  }

  List<StorageFriendEntity> get _filteredFriends {
    if (_searchQuery.isEmpty) {
      return _friends;
    }

    return _friends.where((friend) {
      final name = friend.name.toLowerCase();
      final mssv = friend.mssv.toLowerCase();
      return name.contains(_searchQuery) || mssv.contains(_searchQuery);
    }).toList();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.trim().toLowerCase();
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - 140) {
      return;
    }

    if (widget.mode == StorageShareActionMode.manageSharedUsers) {
      _loadSharedUsers(loadMore: true);
      return;
    }

    _loadFriends(loadMore: true);
  }

  Future<Either<Failure, T>> _callWithResourceTypeFallback<T>(
    Future<Either<Failure, T>> Function(String resourceType) operation,
  ) async {
    Either<Failure, T>? lastResult;

    for (final resourceType in _resourceTypeCandidates) {
      final result = await operation(resourceType);
      if (result.isRight()) {
        return result;
      }
      lastResult = result;
    }

    return lastResult!;
  }

  Future<void> _loadInitial() async {
    if (widget.mode == StorageShareActionMode.manageSharedUsers) {
      await _loadSharedUsers(reset: true);
      return;
    }

    await _loadFriends(reset: true);
  }

  Future<void> _loadSharedUsers({
    bool reset = false,
    bool loadMore = false,
  }) async {
    if (loadMore) {
      if (_isInitialLoading || _isLoadingMore || !_sharedUsersHasMore) return;
    }

    final pageToLoad = reset ? 1 : _sharedUsersPage;

    setState(() {
      if (loadMore) {
        _isLoadingMore = true;
      } else {
        _isInitialLoading = true;
        _errorMessage = null;
      }
    });

    final result = await _callWithResourceTypeFallback(
      (resourceType) => _getSharedUsersUsecase(
        GetSharedUsersParams(
          resourceType: resourceType,
          resourceId: widget.resourceId,
          page: pageToLoad,
          limit: _pageSize,
        ),
      ),
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        if (loadMore && _sharedUsers.isNotEmpty) {
          _showSnackBar(failure.message, isError: true);
        }

        setState(() {
          _isInitialLoading = false;
          _isLoadingMore = false;
          _errorMessage = _sharedUsers.isEmpty ? failure.message : null;
        });
      },
      (paged) {
        final merged = loadMore
            ? [..._sharedUsers, ...paged.items]
            : paged.items;

        setState(() {
          _sharedUsers = merged;
          _sharedUsersPage = pageToLoad + 1;
          _sharedUsersHasMore = paged.hasMore;
          _isInitialLoading = false;
          _isLoadingMore = false;
          _errorMessage = null;
        });
      },
    );
  }

  Future<void> _loadFriends({bool reset = false, bool loadMore = false}) async {
    if (loadMore) {
      if (_isInitialLoading || _isLoadingMore || !_friendsHasMore) return;
      if (_friendsNextCursor == null || _friendsNextCursor!.isEmpty) return;
    }

    final cursorToLoad = reset ? null : _friendsNextCursor;

    setState(() {
      if (loadMore) {
        _isLoadingMore = true;
      } else {
        _isInitialLoading = true;
        _errorMessage = null;
      }
    });

    final result = await _storageGetFriendsUsecase(
      StorageCursorParams(cursor: cursorToLoad, limit: _pageSize),
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        if (loadMore && _friends.isNotEmpty) {
          _showSnackBar(failure.message, isError: true);
        }

        setState(() {
          _isInitialLoading = false;
          _isLoadingMore = false;
          _errorMessage = _friends.isEmpty ? failure.message : null;
        });
      },
      (paged) {
        final merged = loadMore ? [..._friends, ...paged.items] : paged.items;

        setState(() {
          _friends = merged;
          _friendsNextCursor = paged.nextCursor;
          _friendsHasMore = paged.hasMore;
          _isInitialLoading = false;
          _isLoadingMore = false;
          _errorMessage = null;
        });
      },
    );
  }

  Future<void> _onUnshare(SharedStudentEntity entry) async {
    if (_isPerformingAction) return;

    setState(() {
      _isPerformingAction = true;
      _activeActionMssv = entry.student.mssv;
    });

    final result = await _callWithResourceTypeFallback(
      (resourceType) => _unshareUsecase(
        UnshareParams(
          resourceId: widget.resourceId,
          resourceType: resourceType,
          targetMssv: entry.student.mssv,
        ),
      ),
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _isPerformingAction = false;
          _activeActionMssv = null;
        });
        _showSnackBar(failure.message, isError: true);
      },
      (_) {
        setState(() {
          _sharedUsers = _sharedUsers
              .where((e) => e.student.mssv != entry.student.mssv)
              .toList();
          _newlySharedMssvs.remove(entry.student.mssv);
          _isPerformingAction = false;
          _activeActionMssv = null;
        });
        _showSnackBar('Unshared successfully.', isError: false);
      },
    );
  }

  Future<void> _onShare(StorageFriendEntity friend) async {
    if (_isPerformingAction || _newlySharedMssvs.contains(friend.mssv)) return;

    setState(() {
      _isPerformingAction = true;
      _activeActionMssv = friend.mssv;
    });

    final result = await _callWithResourceTypeFallback(
      (resourceType) => _shareResourceUsecase(
        ShareResourceParams(
          resourceType: resourceType,
          resourceId: widget.resourceId,
          targetMssv: friend.mssv,
        ),
      ),
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _isPerformingAction = false;
          _activeActionMssv = null;
        });
        _showSnackBar(failure.message, isError: true);
      },
      (_) {
        setState(() {
          _newlySharedMssvs.add(friend.mssv);
          _isPerformingAction = false;
          _activeActionMssv = null;
        });
        _showSnackBar('Shared successfully.', isError: false);
      },
    );
  }

  Future<void> _onRefresh() async {
    if (widget.mode == StorageShareActionMode.manageSharedUsers) {
      await _loadSharedUsers(reset: true);
      return;
    }

    await _loadFriends(reset: true);
  }

  String get _title {
    if (widget.mode == StorageShareActionMode.manageSharedUsers) {
      return 'List of users with access';
    }

    return 'Share ${widget.resourceType.displayName}';
  }

  int get _visibleCount {
    if (widget.mode == StorageShareActionMode.manageSharedUsers) {
      return _filteredSharedUsers.length;
    }

    return _filteredFriends.length;
  }

  bool get _showInitialLoader {
    if (widget.mode == StorageShareActionMode.manageSharedUsers) {
      return _isInitialLoading && _sharedUsers.isEmpty;
    }

    return _isInitialLoading && _friends.isEmpty;
  }

  bool get _showError {
    if (widget.mode == StorageShareActionMode.manageSharedUsers) {
      return _errorMessage != null && _sharedUsers.isEmpty;
    }

    return _errorMessage != null && _friends.isEmpty;
  }

  bool get _showEmpty {
    if (widget.mode == StorageShareActionMode.manageSharedUsers) {
      return _filteredSharedUsers.isEmpty;
    }

    return _filteredFriends.isEmpty;
  }

  void _showSnackBar(String message, {required bool isError}) {
    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: isError ? AppColor.alertRed : AppColor.successGreen,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.veryLightGrey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AccessHeader(
              title: _title,
              onBack: () => Navigator.of(context).pop(),
            ),
            _AccessSearchBar(controller: _searchController),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '$_visibleCount ${_visibleCount == 1 ? 'user' : 'users'}',
                style: AppTextStyle.bodySmall.copyWith(
                  fontWeight: AppTextStyle.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_showInitialLoader) {
      return const Center(
        child: CircularProgressIndicator(color: AppColor.primaryBlue),
      );
    }

    if (_showError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 44, color: AppColor.alertRed),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _errorMessage ?? 'Something went wrong.',
                style: AppTextStyle.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: _loadInitial, child: const Text('Try again')),
          ],
        ),
      );
    }

    if (_showEmpty) {
      final emptyText = _searchQuery.isNotEmpty
          ? 'No users found.'
          : widget.mode == StorageShareActionMode.manageSharedUsers
          ? 'No users have access yet.'
          : 'You have no friends to share with.';

      return Center(
        child: Text(
          emptyText,
          style: AppTextStyle.bodySmall.copyWith(color: AppColor.secondaryText),
        ),
      );
    }

    final itemCount = widget.mode == StorageShareActionMode.manageSharedUsers
        ? _filteredSharedUsers.length + (_isLoadingMore ? 1 : 0)
        : _filteredFriends.length + (_isLoadingMore ? 1 : 0);

    return RefreshIndicator(
      color: AppColor.primaryBlue,
      onRefresh: _onRefresh,
      child: ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          if (widget.mode == StorageShareActionMode.manageSharedUsers) {
            if (index == _filteredSharedUsers.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: AppColor.primaryBlue,
                  ),
                ),
              );
            }

            final entry = _filteredSharedUsers[index];
            final isActionLoading =
                _isPerformingAction && _activeActionMssv == entry.student.mssv;

            return _AccessUserTile(
              name: entry.student.fullName,
              mssv: entry.student.mssv,
              avatarUrl: entry.student.avatarUrl,
              buttonLabel: 'Unshare',
              buttonColor: AppColor.alertRed,
              isActionLoading: isActionLoading,
              onPressed: _isPerformingAction && !isActionLoading
                  ? null
                  : () => _onUnshare(entry),
            );
          }

          if (index == _filteredFriends.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: AppColor.primaryBlue,
                ),
              ),
            );
          }

          final friend = _filteredFriends[index];
          final isActionLoading =
              _isPerformingAction && _activeActionMssv == friend.mssv;
          final alreadyShared = _newlySharedMssvs.contains(friend.mssv);

          return _AccessUserTile(
            name: friend.name,
            mssv: friend.mssv,
            avatarUrl: friend.avatarUrl,
            buttonLabel: alreadyShared ? 'Shared' : 'Share',
            buttonColor: alreadyShared
                ? AppColor.secondaryText
                : AppColor.primaryBlue,
            isActionLoading: isActionLoading,
            onPressed:
                (_isPerformingAction && !isActionLoading) || alreadyShared
                ? null
                : () => _onShare(friend),
          );
        },
      ),
    );
  }
}

class _AccessHeader extends StatelessWidget {
  const _AccessHeader({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            height: 40,

            child: IconButton(
              onPressed: onBack,
              icon: const Icon(
                Icons.arrow_back,
                color: AppColor.primaryText,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyle.h3.copyWith(fontWeight: AppTextStyle.bold),
            ),
          ),
          const SizedBox(width: 50),
        ],
      ),
    );
  }
}

class _AccessSearchBar extends StatelessWidget {
  const _AccessSearchBar({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final hasText = controller.text.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: AppColor.dividerGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            const Icon(Icons.search, color: AppColor.secondaryText, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                style: AppTextStyle.bodySmall,
                decoration: InputDecoration(
                  fillColor: AppColor.dividerGrey,
                  border: InputBorder.none,
                  isDense: true,
                  hintText: 'Search by name...',
                  hintStyle: AppTextStyle.bodySmall.copyWith(
                    color: AppColor.secondaryText,
                  ),
                ),
              ),
            ),
            if (hasText)
              IconButton(
                onPressed: controller.clear,
                icon: const Icon(Icons.close, size: 18),
                color: AppColor.secondaryText,
              )
            else
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.tune, color: AppColor.secondaryText),
              ),
          ],
        ),
      ),
    );
  }
}

class _AccessUserTile extends StatelessWidget {
  const _AccessUserTile({
    required this.name,
    required this.mssv,
    required this.avatarUrl,
    required this.buttonLabel,
    required this.buttonColor,
    required this.onPressed,
    this.isActionLoading = false,
  });

  final String name;
  final String mssv;
  final String avatarUrl;
  final String buttonLabel;
  final Color buttonColor;
  final VoidCallback? onPressed;
  final bool isActionLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Avatar(avatarUrl: avatarUrl),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTextStyle.bodyMedium.copyWith(
                  fontWeight: AppTextStyle.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                'MSSV $mssv',
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColor.secondaryText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 32,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: buttonColor,
              foregroundColor: AppColor.pureWhite,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              shape: const StadiumBorder(),
              textStyle: AppTextStyle.bodySmall.copyWith(
                fontWeight: AppTextStyle.bold,
              ),
            ),
            child: isActionLoading
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColor.pureWhite,
                    ),
                  )
                : Text(buttonLabel),
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.avatarUrl});

  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    final shouldLoadImage = avatarUrl.trim().isNotEmpty;

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        shape: BoxShape.circle,
        border: Border.all(color: AppColor.primaryText, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: shouldLoadImage
          ? Image.network(
              avatarUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Icon(
                Icons.person_outline,
                color: AppColor.primaryText,
                size: 30,
              ),
            )
          : const Icon(
              Icons.person_outline,
              color: AppColor.primaryText,
              size: 30,
            ),
    );
  }
}
