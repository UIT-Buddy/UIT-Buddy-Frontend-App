import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/calendar_deadline_entity.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/deadline_mode/deadline_detail_item.dart';
import 'package:uit_buddy_mobile/features/deadline/domain/entities/deadline_entity.dart';
import 'package:uit_buddy_mobile/features/deadline/presentation/bloc/deadline_bloc.dart';
import 'package:uit_buddy_mobile/features/deadline/presentation/bloc/deadline_event.dart';
import 'package:uit_buddy_mobile/features/deadline/presentation/bloc/deadline_state.dart';

class DeadlinesScreen extends StatelessWidget {
  const DeadlinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<DeadlineBloc>()..add(const FetchDeadlinesRequested()),
      child: const _DeadlinesBody(),
    );
  }
}

class _DeadlinesBody extends StatelessWidget {
  const _DeadlinesBody();

  CalendarDeadlineItemEntityStatus _mapStatus(DeadlineStatus ds) {
    switch (ds) {
      case DeadlineStatus.done:
        return CalendarDeadlineItemEntityStatus.done;
      case DeadlineStatus.upcoming:
        return CalendarDeadlineItemEntityStatus.upcoming;
      case DeadlineStatus.nearDeadline:
        return CalendarDeadlineItemEntityStatus.nearDeadline;
      case DeadlineStatus.overdue:
        return CalendarDeadlineItemEntityStatus.overdue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.veryLightGrey,
      body: SafeArea(
        child: Column(
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
                      'Deadlines',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.h3.copyWith(
                        fontWeight: AppTextStyle.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // To balance the back button
                ],
              ),
            ),

            const Divider(height: 1, color: AppColor.dividerGrey),

            Expanded(
              child: BlocBuilder<DeadlineBloc, DeadlineState>(
                builder: (context, state) {
                  if (state.status == DeadlineStateStatus.initial ||
                      state.status == DeadlineStateStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.status == DeadlineStateStatus.error) {
                    return Center(
                      child: Text(
                        state.errorMessage ?? 'Something went wrong.',
                        style: AppTextStyle.bodyMedium,
                      ),
                    );
                  }

                  final data = state.deadlineData;
                  if (data == null || data.courseContents.isEmpty) {
                    return Center(
                      child: Text(
                        'No deadlines here.',
                        style: AppTextStyle.bodySmall.copyWith(
                          color: AppColor.secondaryText,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: data.courseContents.length,
                    itemBuilder: (context, index) {
                      final courseContent = data.courseContents[index];
                      return _DeadlineSection(
                        courseContent: courseContent,
                        mapStatus: _mapStatus,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeadlineSection extends StatelessWidget {
  const _DeadlineSection({
    required this.courseContent,
    required this.mapStatus,
  });

  final CourseContentEntity courseContent;
  final CalendarDeadlineItemEntityStatus Function(DeadlineStatus) mapStatus;

  @override
  Widget build(BuildContext context) {
    if (courseContent.exercises.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            courseContent.courseName,
            style: AppTextStyle.h4.copyWith(fontWeight: AppTextStyle.bold),
          ),
        ),
        ...courseContent.exercises.map((deadline) {
          final detailEntity = DeadlineDetailEntity(
            id: deadline.id,
            title: deadline.exerciseName,
            status: mapStatus(deadline.status),
            courseId: deadline.classCode ?? courseContent.courseName,
            deadline: deadline.dueDate,
          );

          return GestureDetector(
            onTap: () {
              context.push(
                RouteName.deadlineDetail,
                extra: {'id': deadline.id},
              );
            },
            child: DeadlineDetailItem(deadlineDetailEntity: detailEntity),
          );
        }),
        const SizedBox(height: 10),
      ],
    );
  }
}
