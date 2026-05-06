import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:uit_buddy_mobile/features/home/presentation/bloc/home/home_state.dart';
import 'package:uit_buddy_mobile/features/home/presentation/constants/home_text.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        // if (state.status == HomeStatus.loading ||
        //     state.status == HomeStatus.initial) {
        //   return const Center(child: CircularProgressIndicator());
        // }

        final userName = state.homepageData?.studentName ?? 'User';
        final todayClass = state.homepageData?.todayClass ?? 0;
        final unreadNotificationCount =
            state.homepageData?.unreadNotificationCount ?? 0;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(HomeText.welcomeBack, style: AppTextStyle.h1),
                  Text(
                    userName,
                    style: AppTextStyle.h1.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${HomeText.classToday}$todayClass${todayClass == 1 ? ' class' : ' classes'}${HomeText.classToday2}',
                    style: AppTextStyle.bodySmall.copyWith(
                      color: AppColor.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => context.push(RouteName.notification),
              icon: Stack(
                children: [
                  const Icon(
                    Icons.notifications_outlined,
                    color: AppColor.primaryText,
                    size: 32,
                  ),
                  if (unreadNotificationCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColor.alertRed,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Center(
                          child: Text(
                            (unreadNotificationCount > 99)
                                ? '99+'
                                : unreadNotificationCount.toString(),
                            style: AppTextStyle.captionSmall.copyWith(
                              color: AppColor.pureWhite,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              style: IconButton.styleFrom(
                backgroundColor: AppColor.veryLightGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
