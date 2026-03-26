import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/other_people_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/search_user_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/user_profile/user_profile_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/user_profile/user_profile_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/user_profile/user_profile_state.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key, required this.mssv});

  final String mssv;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<UserProfileBloc>()
            ..add(UserProfileStarted(mssv: mssv)),
      child: const _UserProfileView(),
    );
  }
}

class _UserProfileView extends StatelessWidget {
  const _UserProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColor.pureWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: AppColor.primaryText,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColor.dividerGrey),
        ),
      ),
      body: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, state) {
          switch (state.status) {
            case UserProfileStatus.initial:
            case UserProfileStatus.loading:
              return const Center(
                child: CircularProgressIndicator(color: AppColor.primaryBlue),
              );
            case UserProfileStatus.error:
              return _ErrorState(message: state.errorMessage);
            case UserProfileStatus.loaded:
              final user = state.user;
              if (user == null) {
                return const _ErrorState(message: 'User not found.');
              }
              return _ProfileContent(user: user);
          }
        },
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.user});

  final OtherPeopleEntity user;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.primaryBlue.withValues(alpha: 0.18),
                  AppColor.primaryBlueDark.withValues(alpha: 0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -42),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildAvatar(),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName,
                          style: AppTextStyle.h3.copyWith(
                            fontWeight: AppTextStyle.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.mssv,
                          style: AppTextStyle.bodySmall.copyWith(
                            color: AppColor.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((user.homeClassCode ?? '').isNotEmpty) ...[
                  _InfoChip(label: user.homeClassCode!),
                  const SizedBox(height: 16),
                ],
                Row(
                  children: [
                    Expanded(
                      child: _FriendStatusButton(
                        status: user.friendStatus,
                        onPressed: () => _showSoon(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showSoon(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColor.primaryBlue,
                          side: const BorderSide(color: AppColor.primaryBlue),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          textStyle: AppTextStyle.bodySmall.copyWith(
                            fontWeight: AppTextStyle.medium,
                          ),
                        ),
                        child: const Text('Message'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _InfoSection(
                  title: 'Bio',
                  value: (user.bio ?? '').trim().isEmpty
                      ? 'No bio yet.'
                      : user.bio!,
                ),
                const SizedBox(height: 14),
                _InfoSection(title: 'Email', value: user.email),
                if ((user.cometUid ?? '').isNotEmpty) ...[
                  const SizedBox(height: 14),
                  _InfoSection(title: 'Comet UID', value: user.cometUid!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final avatarUrl = user.avatarUrl;
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColor.pureWhite, width: 4),
          boxShadow: const [
            BoxShadow(
              color: AppColor.shadowColor,
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: avatarUrl,
            width: 92,
            height: 92,
            fit: BoxFit.cover,
            errorWidget: (_, _, _) => _fallbackAvatar(),
          ),
        ),
      );
    }
    return _fallbackAvatar();
  }

  Widget _fallbackAvatar() {
    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        gradient: AppColor.blueAvatarGradient,
        shape: BoxShape.circle,
        border: Border.all(color: AppColor.pureWhite, width: 4),
        boxShadow: const [
          BoxShadow(
            color: AppColor.shadowColor,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        user.userLetterAvatar,
        style: AppTextStyle.h2White.copyWith(fontWeight: AppTextStyle.bold),
      ),
    );
  }

  void _showSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This action is coming soon.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _FriendStatusButton extends StatelessWidget {
  const _FriendStatusButton({required this.status, required this.onPressed});

  final FriendStatus status;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final style = _FriendStatusButtonStyle.fromStatus(status);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: style.backgroundColor,
        foregroundColor: style.foregroundColor,
        elevation: 0,
        side: BorderSide(color: style.borderColor),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: AppTextStyle.bodySmall.copyWith(
          fontWeight: AppTextStyle.medium,
        ),
      ),
      child: Text(status.label),
    );
  }
}

class _FriendStatusButtonStyle {
  const _FriendStatusButtonStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;

  factory _FriendStatusButtonStyle.fromStatus(FriendStatus status) {
    return switch (status) {
      FriendStatus.none => _FriendStatusButtonStyle(
        backgroundColor: AppColor.primaryBlue,
        foregroundColor: AppColor.pureWhite,
        borderColor: AppColor.primaryBlue,
      ),
      FriendStatus.pending => _FriendStatusButtonStyle(
        backgroundColor: AppColor.veryLightGrey,
        foregroundColor: AppColor.secondaryText,
        borderColor: AppColor.dividerGrey,
      ),
      FriendStatus.friends => _FriendStatusButtonStyle(
        backgroundColor: AppColor.primaryBlue10,
        foregroundColor: AppColor.primaryBlue,
        borderColor: AppColor.primaryBlue10,
      ),
    };
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.veryLightGrey,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.captionLarge.copyWith(
              color: AppColor.secondaryText,
            ),
          ),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyle.bodyMedium),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.primaryBlue10,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyle.captionLarge.copyWith(
          color: AppColor.primaryBlue,
          fontWeight: AppTextStyle.medium,
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.person_off_outlined,
              color: AppColor.alertRed,
              size: 46,
            ),
            const SizedBox(height: 14),
            Text(
              message ?? 'Failed to load user profile.',
              textAlign: TextAlign.center,
              style: AppTextStyle.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
