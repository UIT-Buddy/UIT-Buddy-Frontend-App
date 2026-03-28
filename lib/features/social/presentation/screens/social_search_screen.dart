import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/session/presentation/bloc/session_bloc.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/search_user_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/social_search/social_search_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/social_search/social_search_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/social_search/social_search_state.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/social_text.dart';
import 'package:uit_buddy_mobile/features/social/presentation/screens/post_detail_screen.dart';
import 'package:uit_buddy_mobile/features/social/presentation/screens/user_profile_screen.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/post_card.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/post_card_skeleton.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/social_search_user_card.dart';

class SocialSearchScreen extends StatelessWidget {
  const SocialSearchScreen({super.key, required this.initialQuery});

  final String initialQuery;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<SocialSearchBloc>()
            ..add(SocialSearchStarted(query: initialQuery)),
      child: _SocialSearchView(initialQuery: initialQuery),
    );
  }
}

class _SocialSearchView extends StatefulWidget {
  const _SocialSearchView({required this.initialQuery});

  final String initialQuery;

  @override
  State<_SocialSearchView> createState() => _SocialSearchViewState();
}

class _SocialSearchViewState extends State<_SocialSearchView>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _searchController;
  late final TabController _tabController;
  late final ScrollController _usersScrollController;
  late final ScrollController _postsScrollController;
  late final FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _searchFocusNode = FocusNode();
    _tabController = TabController(length: 3, vsync: this);
    _usersScrollController = ScrollController()..addListener(_onUsersScroll);
    _postsScrollController = ScrollController()..addListener(_onPostsScroll);

    if (widget.initialQuery.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _searchFocusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _tabController.dispose();
    _usersScrollController
      ..removeListener(_onUsersScroll)
      ..dispose();
    _postsScrollController
      ..removeListener(_onPostsScroll)
      ..dispose();
    super.dispose();
  }

  void _onUsersScroll() {
    if (!_usersScrollController.hasClients) return;
    final position = _usersScrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<SocialSearchBloc>().add(const SocialSearchUsersLoadMore());
    }
  }

  void _onPostsScroll() {
    if (!_postsScrollController.hasClients) return;
    final position = _postsScrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<SocialSearchBloc>().add(const SocialSearchPostsLoadMore());
    }
  }

  void _submitSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    FocusScope.of(context).unfocus();
    context.read<SocialSearchBloc>().add(SocialSearchSubmitted(query: query));
  }

  void _openPostDetail(PostEntity post) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PostDetailScreen(postId: post.id, initialPost: post),
      ),
    );
  }

  void _openUserProfile(String mssv) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => UserProfileScreen(mssv: mssv)));
  }

  @override
  Widget build(BuildContext context) {
    final currentUserMssv = context.select(
      (SessionBloc bloc) => bloc.state.user?.mssv.trim(),
    );

    return Scaffold(
      backgroundColor: AppColor.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColor.pureWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 44,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: AppColor.primaryText,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: _buildSearchField(inAppBar: true),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColor.dividerGrey),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: _buildTabBar(),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<SocialSearchBloc, SocialSearchState>(
                builder: (context, state) {
                  final visibleUsers = _filterOutCurrentUser(
                    state.users,
                    currentUserMssv,
                  );
                  final hasAnyVisibleResults =
                      visibleUsers.isNotEmpty || state.posts.isNotEmpty;

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAllTab(state, visibleUsers, hasAnyVisibleResults),
                      _buildUsersTab(state, visibleUsers),
                      _buildPostsTab(state),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField({bool inAppBar = false}) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: AppColor.veryLightGrey,
        borderRadius: BorderRadius.circular(18),
        boxShadow: inAppBar
            ? null
            : const [
                BoxShadow(
                  color: AppColor.shadowColor,
                  blurRadius: 14,
                  offset: Offset(0, 6),
                ),
              ],
      ),
      child: TextField(
        focusNode: _searchFocusNode,
        controller: _searchController,
        textInputAction: TextInputAction.search,
        style: AppTextStyle.bodySmall,
        onSubmitted: (_) => _submitSearch(),
        decoration: InputDecoration(
          hintText: SocialText.searchHint,
          hintStyle: AppTextStyle.bodySmall.copyWith(
            color: AppColor.secondaryText,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColor.secondaryText,
          ),
          suffixIcon: IconButton(
            onPressed: _submitSearch,
            icon: const Icon(
              Icons.arrow_upward_rounded,
              color: AppColor.primaryBlue,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColor.veryLightGrey,
        borderRadius: BorderRadius.circular(18),
      ),
      child: TabBar(
        controller: _tabController,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: AppColor.primaryBlue,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColor.primaryBlue.withValues(alpha: 0.28),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColor.pureWhite,
        unselectedLabelColor: AppColor.secondaryText,
        labelStyle: AppTextStyle.bodySmall.copyWith(
          fontWeight: AppTextStyle.medium,
        ),
        unselectedLabelStyle: AppTextStyle.bodySmall,
        tabs: const [
          Tab(text: SocialText.searchTabAll),
          Tab(text: SocialText.searchTabUsers),
          Tab(text: SocialText.searchTabPosts),
        ],
      ),
    );
  }

  Widget _buildAllTab(
    SocialSearchState state,
    List<SearchUserEntity> visibleUsers,
    bool hasAnyVisibleResults,
  ) {
    if (!state.isLoading && state.query.isEmpty) {
      return const _InitialSearchPrompt();
    }

    if (state.isLoading && !state.hasAnyResults) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: const [
          _SearchSectionHeader(title: SocialText.searchTabUsers, count: null),
          _UserCardSkeleton(),
          SizedBox(height: 12),
          _UserCardSkeleton(),
          SizedBox(height: 20),
          _SearchSectionHeader(title: SocialText.searchTabPosts, count: null),
          PostCardSkeleton(),
          PostCardSkeleton(showImage: true),
        ],
      );
    }

    if (!state.isLoading &&
        !hasAnyVisibleResults &&
        state.usersError != null &&
        state.postsError != null) {
      return _ErrorState(
        message:
            state.usersError ?? state.postsError ?? SocialText.genericError,
        onRetry: () =>
            context.read<SocialSearchBloc>().add(const SocialSearchRetried()),
      );
    }

    if (!state.isLoading && !hasAnyVisibleResults) {
      return _EmptyState(query: state.query);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        if (visibleUsers.isNotEmpty) ...[
          _SearchSectionHeader(
            title: SocialText.searchTabUsers,
            count: visibleUsers.length,
          ),
          ...visibleUsers.map(
            (user) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SocialSearchUserCard(
                user: user,
                onTap: () => _openUserProfile(user.mssv),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ] else if (state.usersError != null) ...[
          const _SearchSectionHeader(
            title: SocialText.searchTabUsers,
            count: null,
          ),
          _InlineStateCard(
            icon: Icons.person_search_rounded,
            message: state.usersError!,
          ),
          const SizedBox(height: 8),
        ],
        if (state.posts.isNotEmpty) ...[
          _SearchSectionHeader(
            title: SocialText.searchTabPosts,
            count: state.posts.length,
          ),
          ...state.posts.map(_buildSearchPostCard),
        ] else if (state.postsError != null) ...[
          const _SearchSectionHeader(
            title: SocialText.searchTabPosts,
            count: null,
          ),
          _InlineStateCard(
            icon: Icons.article_outlined,
            message: state.postsError!,
          ),
        ],
      ],
    );
  }

  Widget _buildUsersTab(
    SocialSearchState state,
    List<SearchUserEntity> visibleUsers,
  ) {
    if (!state.isLoading && state.query.isEmpty) {
      return const _InitialSearchPrompt();
    }

    if (state.isLoading && visibleUsers.isEmpty && state.usersError == null) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: const [
          _UserCardSkeleton(),
          SizedBox(height: 12),
          _UserCardSkeleton(),
          SizedBox(height: 12),
          _UserCardSkeleton(),
        ],
      );
    }

    if (!state.isLoading && visibleUsers.isEmpty && state.usersError != null) {
      return _ErrorState(
        message: state.usersError!,
        onRetry: () =>
            context.read<SocialSearchBloc>().add(const SocialSearchRetried()),
      );
    }

    if (!state.isLoading && visibleUsers.isEmpty) {
      return _EmptyState(query: state.query, label: SocialText.searchNoUsers);
    }

    return ListView.separated(
      controller: _usersScrollController,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: visibleUsers.length + (state.isLoadingMoreUsers ? 1 : 0),
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == visibleUsers.length) return const _BottomLoader();
        return SocialSearchUserCard(
          user: visibleUsers[index],
          onTap: () => _openUserProfile(visibleUsers[index].mssv),
        );
      },
    );
  }

  List<SearchUserEntity> _filterOutCurrentUser(
    List<SearchUserEntity> users,
    String? currentUserMssv,
  ) {
    final normalizedCurrentUserMssv = currentUserMssv?.trim();
    if (normalizedCurrentUserMssv == null ||
        normalizedCurrentUserMssv.isEmpty) {
      return users;
    }

    return users
        .where((user) => user.mssv.trim() != normalizedCurrentUserMssv)
        .toList(growable: false);
  }

  Widget _buildPostsTab(SocialSearchState state) {
    if (!state.isLoading && state.query.isEmpty) {
      return const _InitialSearchPrompt();
    }

    if (state.isLoading && state.posts.isEmpty && state.postsError == null) {
      return ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: const [
          PostCardSkeleton(),
          PostCardSkeleton(showImage: true),
          PostCardSkeleton(),
        ],
      );
    }

    if (!state.isLoading && state.posts.isEmpty && state.postsError != null) {
      return _ErrorState(
        message: state.postsError!,
        onRetry: () =>
            context.read<SocialSearchBloc>().add(const SocialSearchRetried()),
      );
    }

    if (!state.isLoading && state.posts.isEmpty) {
      return _EmptyState(query: state.query, label: SocialText.searchNoPosts);
    }

    return ListView.builder(
      controller: _postsScrollController,
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: state.posts.length + (state.isLoadingMorePosts ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.posts.length) return const _BottomLoader();
        return _buildSearchPostCard(state.posts[index]);
      },
    );
  }

  Widget _buildSearchPostCard(PostEntity post) {
    final currentUserMssv = context.read<SessionBloc>().state.user?.mssv;

    return PostCard(
      key: ValueKey('search-${post.id}'),
      post: post,
      currentUserMssv: currentUserMssv,
      onLikeTap: () => _openPostDetail(post),
      onCommentTap: () => _openPostDetail(post),
      onTap: () => _openPostDetail(post),
      onDeleteTap: null,
      onEditTap: null,
    );
  }
}

class _SearchSectionHeader extends StatelessWidget {
  const _SearchSectionHeader({required this.title, required this.count});

  final String title;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            title,
            style: AppTextStyle.h4.copyWith(fontWeight: AppTextStyle.bold),
          ),
          if (count != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColor.primaryBlue10,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$count',
                style: AppTextStyle.captionLarge.copyWith(
                  color: AppColor.primaryBlue,
                  fontWeight: AppTextStyle.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _UserCardSkeleton extends StatelessWidget {
  const _UserCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.dividerGrey,
      highlightColor: AppColor.veryLightGrey,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColor.pureWhite,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: AppColor.pureWhite,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: 150,
                    decoration: BoxDecoration(
                      color: AppColor.pureWhite,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 11,
                    width: 90,
                    decoration: BoxDecoration(
                      color: AppColor.pureWhite,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 54,
              height: 28,
              decoration: BoxDecoration(
                color: AppColor.pureWhite,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InlineStateCard extends StatelessWidget {
  const _InlineStateCard({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.veryLightGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColor.secondaryText),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTextStyle.bodySmall.copyWith(
                color: AppColor.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              color: AppColor.alertRed,
              size: 46,
            ),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyle.bodyMedium,
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColor.primaryBlue,
                foregroundColor: AppColor.pureWhite,
              ),
              child: const Text(SocialText.retry),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query, this.label});

  final String query;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.travel_explore_rounded,
              size: 48,
              color: AppColor.tertiaryText,
            ),
            const SizedBox(height: 14),
            Text(
              label ?? SocialText.searchEmptyTitle(query),
              textAlign: TextAlign.center,
              style: AppTextStyle.bodyMedium.copyWith(
                fontWeight: AppTextStyle.medium,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              SocialText.searchEmptySubtitle,
              textAlign: TextAlign.center,
              style: AppTextStyle.captionLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomLoader extends StatelessWidget {
  const _BottomLoader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.4,
          color: AppColor.primaryBlue,
        ),
      ),
    );
  }
}

class _InitialSearchPrompt extends StatelessWidget {
  const _InitialSearchPrompt();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.manage_search_rounded,
              size: 48,
              color: AppColor.tertiaryText,
            ),
            const SizedBox(height: 14),
            Text(
              SocialText.searchStartPrompt,
              textAlign: TextAlign.center,
              style: AppTextStyle.bodyMedium.copyWith(
                fontWeight: AppTextStyle.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
