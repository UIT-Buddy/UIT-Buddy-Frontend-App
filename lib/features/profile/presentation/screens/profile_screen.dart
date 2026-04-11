import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/profile_entity.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/profile_screen/profile_bloc.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/profile_screen/profile_event.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/profile_screen/profile_state.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/widgets/profile_action_tabs_widget.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/widgets/profile_academic_summary_widget.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/widgets/profile_cover_header_widget.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/widgets/profile_social_media_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const ProfileEntity _placeholder = ProfileEntity(
    mssv: '—',
    fullName: 'Full Name',
    email: '—',
    avatarUrl: 'assets/images/placeholder/user-icon.png',
    bio: '-',
    coverUrl: 'assets/images/placeholder/bg-placeholder-transparent.png',
    stats: ProfileStatsEntity(
      currentGpa: 0.0,
      gpaOn4Scale: 0.0,
      accumulatedCredits: 0,
      totalCredits: 0,
      posts: 0,
      comments: 0,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<ProfileBloc>()..add(const ProfileStarted()),
      child: BlocListener<ProfileBloc, ProfileState>(
        listenWhen: (previous, current) =>
            current.status == ProfileStatus.signedOut ||
            current.status == ProfileStatus.error,
        listener: (context, state) {
          if (state.status == ProfileStatus.signedOut) {
            context.go(RouteName.signIn);
          } else if (state.status == ProfileStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Something went wrong.'),
                backgroundColor: AppColor.alertRed,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColor.veryLightGrey,
          body: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              final isLoading =
                  state.status == ProfileStatus.initial ||
                  state.status == ProfileStatus.loading;
              final isSigningOut = state.status == ProfileStatus.signingOut;
              final profile = state.profileInfo ?? _placeholder;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Cover + Avatar + Name
                    ProfileCoverHeaderWidget(
                      profileInfo: profile,
                      onNotificationTap: () =>
                          context.push(RouteName.notification),
                      onSettingsTap: () {
                        context.push(RouteName.settings);
                      },
                    ),

                    // Inline loading indicator
                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: CircularProgressIndicator(),
                      )
                    else
                      const SizedBox(height: 8),

                    // Quick action tabs
                    ProfileActionTabsWidget(
                      onTasksTap: () => context.push(
                        RouteName.tasks,
                        extra: {'direction': 'forward'},
                      ),
                      onYourInfoTap: () => context.push(RouteName.yourInfo),
                      onYourFriendsTap: () =>
                          context.push(RouteName.yourFriends),
                      onGroupsTap: () => context.push(RouteName.groupsJoined),
                    ),

                    const SizedBox(height: 12),

                    // Academic summary
                    ProfileAcademicSummaryWidget(
                      profileInfo: profile,
                      onSeeDetailsTap: () =>
                          context.push(RouteName.academicDetail),
                    ),

                    const SizedBox(height: 12),

                    // Social media
                    ProfileSocialMediaWidget(
                      profileInfo: profile,
                      onViewPostsTap: () => context.push(RouteName.yourPosts),
                    ),

                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () => context.push(RouteName.chat),
                      child: Text("Chat"),
                    ),
                    // Log out
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: isSigningOut
                              ? null
                              : () => context.read<ProfileBloc>().add(
                                  const SignOutRequested(),
                                ),
                          icon: isSigningOut
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColor.alertRed,
                                  ),
                                )
                              : const Icon(
                                  Icons.logout,
                                  color: AppColor.alertRed,
                                  size: 20,
                                ),
                          label: Text(
                            isSigningOut ? 'Signing out...' : 'Log out',
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColor.alertRed,
                            side: const BorderSide(color: AppColor.alertRed),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle: AppTextStyle.bodyLarge.copyWith(
                              fontWeight: AppTextStyle.medium,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
