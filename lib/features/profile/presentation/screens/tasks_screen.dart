import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/task_entity.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/tasks_screen/tasks_bloc.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/tasks_screen/tasks_event.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/tasks_screen/tasks_state.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/widgets/task_card_widget.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<TasksBloc>()..add(const TasksLoaded()),
      child: const _TasksBody(),
    );
  }
}

class _TasksBody extends StatelessWidget {
  const _TasksBody();

  Future<void> _handleAddTask(BuildContext context) async {
    final newTask = await context.push<TaskEntity>(
      RouteName.addEditTask,
      extra: {'task': null, 'direction': 'forward'},
    );
    if (newTask != null && context.mounted) {
      context.read<TasksBloc>().add(TaskCreated(task: newTask));
    }
  }

  Future<void> _handleEditTask(BuildContext context, TaskEntity task) async {
    final updated = await context.push<TaskEntity>(
      RouteName.addEditTask,
      extra: {'task': task, 'direction': 'forward'},
    );
    if (updated != null && context.mounted) {
      context.read<TasksBloc>().add(TaskUpdated(task: updated));
    }
  }

  void _handleViewTask(BuildContext context, TaskEntity task) {
    context
        .push(
          RouteName.taskDetail,
          extra: {'task': task, 'direction': 'forward'},
        )
        .then((result) {
          if (result == null || !context.mounted) return;
          final map = result as Map<String, dynamic>;
          final action = map['action'] as _TaskDetailAction?;
          final taskId = map['taskId'] as String?;
          if (action == null || taskId == null) return;
          if (action == _TaskDetailAction.completed) {
            context.read<TasksBloc>().add(TaskCompleted(taskId: taskId));
          } else if (action == _TaskDetailAction.deleted) {
            context.read<TasksBloc>().add(TaskDeleted(taskId: taskId));
          } else if (action == _TaskDetailAction.edited) {
            final updated = map['task'] as TaskEntity?;
            if (updated != null) {
              context.read<TasksBloc>().add(TaskUpdated(task: updated));
            }
          }
        });
  }

  void _handleMenuAction(
    BuildContext context,
    TaskCardMenuAction action,
    TaskEntity task,
  ) {
    switch (action) {
      case TaskCardMenuAction.view:
        _handleViewTask(context, task);
      case TaskCardMenuAction.edit:
        _handleEditTask(context, task);
      case TaskCardMenuAction.delete:
        _confirmDelete(context, task.id);
      case TaskCardMenuAction.markCompleted:
        context.read<TasksBloc>().add(TaskCompleted(taskId: task.id));
    }
  }

  void _confirmDelete(BuildContext context, String taskId) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              context.read<TasksBloc>().add(TaskDeleted(taskId: taskId));
            },
            child: Text('Delete', style: TextStyle(color: AppColor.alertRed)),
          ),
        ],
      ),
    );
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
                      'Tasks',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.h3.copyWith(
                        fontWeight: AppTextStyle.bold,
                      ),
                    ),
                  ),
                  // Add button
                  BlocBuilder<TasksBloc, TasksState>(
                    builder: (context, state) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => _handleAddTask(context),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColor.primaryBlue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: AppColor.pureWhite,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: AppColor.dividerGrey),

            Expanded(
              child: BlocBuilder<TasksBloc, TasksState>(
                builder: (context, state) {
                  if (state.status == TasksStatus.initial ||
                      state.status == TasksStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.status == TasksStatus.error) {
                    return Center(
                      child: Text(
                        state.errorMessage ?? 'Something went wrong.',
                        style: AppTextStyle.bodyMedium,
                      ),
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _TaskSection(
                        title: 'Upcoming',
                        tasks: state.upcomingTasks,
                        onMenuSelected: (action, task) =>
                            _handleMenuAction(context, action, task),
                        onCardTap: (task) => _handleViewTask(context, task),
                      ),
                      const SizedBox(height: 20),
                      _TaskSection(
                        title: 'Finished',
                        tasks: state.finishedTasks,
                        onMenuSelected: (action, task) =>
                            _handleMenuAction(context, action, task),
                        onCardTap: (task) => _handleViewTask(context, task),
                      ),
                      const SizedBox(height: 20),
                      _TaskSection(
                        title: 'Late',
                        tasks: state.lateTasks,
                        onMenuSelected: (action, task) =>
                            _handleMenuAction(context, action, task),
                        onCardTap: (task) => _handleViewTask(context, task),
                      ),
                      const SizedBox(height: 16),
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
}

class _TaskSection extends StatelessWidget {
  const _TaskSection({
    required this.title,
    required this.tasks,
    required this.onMenuSelected,
    required this.onCardTap,
  });

  final String title;
  final List<TaskEntity> tasks;
  final void Function(TaskCardMenuAction action, TaskEntity task)
  onMenuSelected;
  final void Function(TaskEntity task) onCardTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title (${tasks.length})',
          style: AppTextStyle.h4.copyWith(fontWeight: AppTextStyle.bold),
        ),
        const SizedBox(height: 12),
        if (tasks.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No tasks here.',
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColor.secondaryText,
                ),
              ),
            ),
          )
        else
          ...tasks.map(
            (task) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TaskCardWidget(
                task: task,
                onTap: () => onCardTap(task),
                onMenuSelected: (action) => onMenuSelected(action, task),
              ),
            ),
          ),
      ],
    );
  }
}

// Internal enum used to communicate results back from TaskDetailScreen
enum _TaskDetailAction { completed, deleted, edited }
