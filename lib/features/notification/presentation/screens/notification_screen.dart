import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/notification/presentation/bloc/notification_screen/notification_bloc.dart';
import 'package:uit_buddy_mobile/features/notification/presentation/bloc/notification_screen/notification_event.dart';
import 'package:uit_buddy_mobile/features/notification/presentation/bloc/notification_screen/notification_state.dart';
import 'package:uit_buddy_mobile/features/notification/presentation/widgets/notification_item_widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<NotificationBloc>()
            ..add(const NotificationsLoaded()),
      child: Scaffold(
        backgroundColor: AppColor.pureWhite,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
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
                        'Notifications',
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

              const Divider(height: 1, color: AppColor.dividerGrey),

              // Body
              Expanded(
                child: BlocBuilder<NotificationBloc, NotificationState>(
                  builder: (context, state) {
                    if (state.status == NotificationStatus.initial ||
                        state.status == NotificationStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.status == NotificationStatus.error) {
                      return Center(
                        child: Text(
                          state.errorMessage ?? 'Something went wrong.',
                          style: AppTextStyle.bodyMedium,
                        ),
                      );
                    }

                    final items = state.notifs;

                    if (items.isEmpty) {
                      return Center(
                        child: Text(
                          'No notifications yet.',
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColor.secondaryText,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const Divider(
                        height: 1,
                        indent: 68,
                        color: AppColor.dividerGrey,
                      ),
                      itemBuilder: (context, index) {
                        final notification = items[index];
                        return NotificationItemWidget(
                          item: notification,
                          onMarkAsRead: () {
                            context.read<NotificationBloc>().add(
                              NotificationMarkAsRead(
                                notificationId: notification.id,
                              ),
                            );
                          },
                          onDelete: () {
                            context.read<NotificationBloc>().add(
                              NotificationDeleted(
                                notificationId: notification.id,
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
