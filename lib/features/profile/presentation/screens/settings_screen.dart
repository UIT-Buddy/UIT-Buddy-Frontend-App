import 'package:bot_toast/bot_toast.dart';
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
import 'package:uit_buddy_mobile/features/profile/presentation/widgets/segment_tab.dart';

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

  Future<void> _showUpdateTokenDialog(
    BuildContext context, {
    required bool isUpdating,
  }) async {
    String newToken = '';
    String? tokenError;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            return AlertDialog(
              title: Text(
                'Update WebSocket Token?',
                style: AppTextStyle.h4.copyWith(fontWeight: AppTextStyle.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Provide a valid WebSocket token.',
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: AppColor.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (value) {
                      newToken = value;
                      if (tokenError == null) return;
                      setState(() {
                        tokenError = value.trim().isEmpty
                            ? 'WebSocket token cannot be empty.'
                            : null;
                      });
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'New WebSocket Token',
                      errorText: tokenError,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isUpdating
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
                  onPressed: isUpdating
                      ? null
                      : () {
                          final trimmedToken = newToken.trim();
                          if (trimmedToken.isEmpty) {
                            setState(() {
                              tokenError = 'WebSocket token cannot be empty.';
                            });
                            return;
                          }

                          context.read<SettingsBloc>().add(
                            ChangeWsTokenRequested(newToken: trimmedToken),
                          );
                          Navigator.of(dialogContext).pop();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryBlue,
                    foregroundColor: AppColor.pureWhite,
                  ),
                  child: Text(
                    isUpdating ? 'Updating...' : 'Confirm',
                    style: AppTextStyle.buttonPrimary,
                  ),
                ),
              ],
            );
          },
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
          } else if (state.status == SettingsStatus.wsTokenChanged) {
            BotToast.showText(
              text: 'WebSocket token updated successfully.',
              duration: const Duration(seconds: 2),
            );
          } else if (state.status == SettingsStatus.error) {
            BotToast.showText(
              text: state.errorMessage ?? 'Something went wrong.',
              duration: const Duration(seconds: 2),
            );
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
                final isChangingWsToken =
                    state.status == SettingsStatus.changingWsToken;

                return Stack(
                  children: [
                    Column(
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
                              SegmentTab(
                                label: 'Change Password',
                                description:
                                    'Update your account password regularly to keep your account secure',
                                onTap: () {
                                  // Handle change password
                                },
                                labelColor: AppColor.primaryText,
                              ),
                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: AppColor.dividerGrey,
                              ),
                              SegmentTab(
                                label: 'Change WsToken',
                                description:
                                    'Update your WsToken regularly to keep your account secure',
                                onTap: () {
                                  _showUpdateTokenDialog(
                                    context,
                                    isUpdating:
                                        state.status ==
                                        SettingsStatus.changingWsToken,
                                  );
                                },
                                labelColor: AppColor.primaryText,
                              ),
                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: AppColor.dividerGrey,
                              ),
                              SegmentTab(
                                label: 'Delete Account',
                                description:
                                    'Permanently delete your account and all associated data. This action cannot be undone.',
                                onTap: () => _showDeleteConfirmationDialog(
                                  context,
                                  isDeleting: isDeleting,
                                ),
                                labelColor: AppColor.alertRed,
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
                    ),
                    if (isChangingWsToken)
                      Positioned.fill(
                        child: ColoredBox(
                          color: AppColor.pureWhite.withValues(alpha: 0.65),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColor.primaryBlue,
                            ),
                          ),
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
