import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/settings_screen/settings_bloc.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/settings_screen/settings_event.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/settings_screen/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _showDeleteConfirmationDialog(
    BuildContext context, {
    required bool isDeleting,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'Delete account?',
            style: AppTextStyle.h4.copyWith(fontWeight: AppTextStyle.bold),
          ),
          content: Text(
            'This action is permanent. Your account and associated data cannot be restored after deletion.',
            style: AppTextStyle.bodyMedium.copyWith(
              color: AppColor.secondaryText,
            ),
          ),
          actions: [
            TextButton(
              onPressed: isDeleting
                  ? null
                  : () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColor.secondaryText,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: isDeleting
                  ? null
                  : () {
                      context.read<SettingsBloc>().add(
                        const DeleteAccountRequested(),
                      );
                      Navigator.of(dialogContext).pop();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.alertRed,
                foregroundColor: AppColor.pureWhite,
              ),
              child: Text(
                isDeleting ? 'Deleting...' : 'Confirm',
                style: AppTextStyle.buttonPrimary,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<SettingsBloc>()..add(const SettingsStarted()),
      child: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state.status == SettingsStatus.deleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account deleted successfully.'),
                backgroundColor: AppColor.successGreen,
              ),
            );
            context.go(RouteName.signIn);
          } else if (state.status == SettingsStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Something went wrong.'),
                backgroundColor: AppColor.alertRed,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColor.pureWhite,
          body: SafeArea(
            child: BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                // final isLoading =
                //     state.status == SettingsStatus.loading ||
                //     state.status == SettingsStatus.initial;
                final isDeleting = state.status == SettingsStatus.deleting;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColor.primaryText,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          Expanded(
                            child: Text(
                              'Settings',
                              textAlign: TextAlign.center,
                              style: AppTextStyle.h3.copyWith(
                                fontWeight: AppTextStyle.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColor.dividerGrey,
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          InkWell(
                            onTap: () {
                              // Handle change password
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Change Password',
                                    style: AppTextStyle.bodyLarge.copyWith(
                                      fontWeight: AppTextStyle.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Update your account password regularly to keep your account secure',
                                    style: AppTextStyle.bodyMedium.copyWith(
                                      color: AppColor.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: AppColor.dividerGrey,
                          ),
                          InkWell(
                            onTap: isDeleting
                                ? null
                                : () {
                                    _showDeleteConfirmationDialog(
                                      context,
                                      isDeleting: isDeleting,
                                    );
                                  },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Delete Account',
                                    style: AppTextStyle.bodyLarge.copyWith(
                                      fontWeight: AppTextStyle.bold,
                                      color: AppColor.alertRed,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Permanently remove your account and all associated data',
                                    style: AppTextStyle.bodyMedium.copyWith(
                                      color: AppColor.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: AppColor.dividerGrey,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
