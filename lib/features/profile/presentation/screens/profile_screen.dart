import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();

  static const ProfileEntity _placeholder = ProfileEntity(
    mssv: '—',
    fullName: 'Full Name',
    email: '—',
    avatarUrl: 'assets/images/placeholder/user-icon.png',
    bio: '-',
    coverUrl: 'assets/images/placeholder/bg-placeholder-transparent.png',
    homeClassCode: '-',
    friendStatus: 'NONE',
    stats: ProfileStatsEntity(
      currentGpa: 0.0,
      gpaOn4Scale: 0.0,
      accumulatedCredits: 0,
      totalCredits: 0,
      posts: 0,
      comments: 0,
    ),
  );
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  Future<ImageSource?> _pickCoverSource(BuildContext scopedContext) {
    return showModalBottomSheet<ImageSource>(
      context: scopedContext,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Take photo'),
                onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from library'),
                onTap: () =>
                    Navigator.of(sheetContext).pop(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onCoverEditTap({
    required BuildContext scopedContext,
    required bool disabled,
  }) async {
    if (disabled) return;

    final profileBloc = scopedContext.read<ProfileBloc>();

    final source = await _pickCoverSource(scopedContext);
    if (source == null || !mounted) return;

    final picked = await _imagePicker.pickImage(
      source: source,
      imageQuality: 90,
      maxWidth: 1920,
    );

    if (picked == null || !mounted) return;

    final bytes = await picked.readAsBytes();
    if (!mounted) return;

    profileBloc.add(
      ProfileCoverUploadRequested(
        fileBytes: bytes,
        fileName: picked.name.isEmpty ? 'cover.jpg' : picked.name,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<ProfileBloc>()..add(const ProfileStarted()),
      child: Scaffold(
        backgroundColor: AppColor.veryLightGrey,
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listenWhen: (previous, current) =>
              previous.status != current.status ||
              previous.actionErrorMessage != current.actionErrorMessage ||
              previous.actionSuccessMessage != current.actionSuccessMessage,
          listener: (context, state) {
            if (state.status == ProfileStatus.signedOut) {
              context.go(RouteName.signIn);
              return;
            }

            if (state.status == ProfileStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Something went wrong.'),
                  backgroundColor: AppColor.alertRed,
                ),
              );
            }

            final message =
                state.actionErrorMessage ?? state.actionSuccessMessage;
            if (message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: state.actionErrorMessage != null
                      ? AppColor.alertRed
                      : AppColor.successGreen,
                ),
              );

              context.read<ProfileBloc>().add(const ProfileFeedbackCleared());
            }
          },
          builder: (context, state) {
            final isLoading =
                state.status == ProfileStatus.initial ||
                state.status == ProfileStatus.loading;
            final isSigningOut = state.status == ProfileStatus.signingOut;
            final profile = state.profileInfo ?? ProfileScreen._placeholder;

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
                    onCoverEditTap: () => _onCoverEditTap(
                      scopedContext: context,
                      disabled: isSigningOut || state.isUploadingCover,
                    ),
                    isCoverUploading: state.isUploadingCover,
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
                    onYourFriendsTap: () => context.push(RouteName.yourFriends),
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
                    child: const Text('Chat'),
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
    );
  }
}
