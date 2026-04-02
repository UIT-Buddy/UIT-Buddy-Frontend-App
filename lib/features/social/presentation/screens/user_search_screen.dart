import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/comet_user_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/conversation_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/user_search/user_search_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/user_search/user_search_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/user_search/user_search_state.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/conversation_list_item_skeleton.dart';

class UserSearchScreen extends StatelessWidget {
  const UserSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<UserSearchBloc>(),
      child: const _UserSearchView(),
    );
  }
}

class _UserSearchView extends StatefulWidget {
  const _UserSearchView();

  @override
  State<_UserSearchView> createState() => _UserSearchViewState();
}

class _UserSearchViewState extends State<_UserSearchView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pureWhite,
      appBar: _buildAppBar(context),
      body: BlocBuilder<UserSearchBloc, UserSearchState>(
        builder: (context, state) {
          if (state.status == UserSearchStatus.loading) {
            return _buildLoading();
          }
          if (state.status == UserSearchStatus.error) {
            return _buildError(state.errorMessage);
          }
          if (state.status == UserSearchStatus.initial) {
            return _buildHint();
          }
          if (state.users.isEmpty) {
            return _buildEmpty(state.query);
          }
          return _buildList(state.users);
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.pureWhite,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      leadingWidth: 44,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: AppColor.primaryText,
        ),
        onPressed: () => Navigator.of(context).pop(),
        padding: const EdgeInsets.only(left: 12),
      ),
      title: TextField(
        controller: _searchController,
        autofocus: true,
        style: AppTextStyle.bodySmall,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm người dùng...',
          hintStyle: AppTextStyle.bodySmall.copyWith(
            color: AppColor.secondaryText,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) {
          context.read<UserSearchBloc>().add(
            UserSearchQueryChanged(query: value),
          );
        },
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColor.dividerGrey),
      ),
    );
  }

  Widget _buildLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8,
      itemBuilder: (_, _) => const ConversationListItemSkeleton(),
    );
  }

  Widget _buildHint() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.person_search_outlined,
            size: 52,
            color: AppColor.tertiaryText,
          ),
          const SizedBox(height: 12),
          Text(
            'Nhập tên hoặc MSSV để tìm kiếm bạn bè',
            style: AppTextStyle.bodyMedium.copyWith(
              color: AppColor.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 52, color: AppColor.tertiaryText),
          const SizedBox(height: 12),
          Text(
            'Không tìm thấy người dùng\n"$query"',
            style: AppTextStyle.bodyMedium.copyWith(
              color: AppColor.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildError(String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColor.alertRed),
          const SizedBox(height: 12),
          Text(
            message ?? 'Đã xảy ra lỗi',
            style: AppTextStyle.bodyMedium.copyWith(
              color: AppColor.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<CometUserEntity> users) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return _UserListItem(user: user, onTap: () => _openChat(user));
      },
    );
  }

  void _openChat(CometUserEntity user) {
    final conversation = ConversationEntity(
      id: user.uid,
      name: user.name,
      avatarUrl: user.avatar ?? '',
      lastMessage: '',
      time: '',
      isOnline: user.status == 'online',
      conversationType: 'user',
      conversationWith: user.uid,
    );
  }
}

class _UserListItem extends StatelessWidget {
  final CometUserEntity user;
  final VoidCallback onTap;

  const _UserListItem({required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColor.veryLightGrey,
                  backgroundImage: user.avatar?.isNotEmpty ?? false
                      ? CachedNetworkImageProvider(user.avatar!)
                      : null,
                  child: user.avatar?.isEmpty ?? false
                      ? Text(
                          user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : '?',
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColor.secondaryText,
                          ),
                        )
                      : null,
                ),
                if (user.status == 'online')
                  Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: AppColor.successGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColor.pureWhite, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: AppTextStyle.bodySmall.copyWith(
                      fontWeight: AppTextStyle.medium,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    user.status == 'online' ? 'Online' : 'Offline',
                    style: AppTextStyle.captionSmall.copyWith(
                      color: user.status == 'online'
                          ? AppColor.successGreen
                          : AppColor.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColor.tertiaryText,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
