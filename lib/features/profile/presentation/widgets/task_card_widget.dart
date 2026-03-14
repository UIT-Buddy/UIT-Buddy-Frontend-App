import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/task_detail_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/task_entity.dart';

enum TaskCardMenuAction { view, edit, delete, markCompleted }

class TaskCardWidget extends StatelessWidget {
  const TaskCardWidget({
    super.key,
    required this.task,
    required this.onMenuSelected,
    this.onTap,
  });

  final TaskEntity task;
  final void Function(TaskCardMenuAction action) onMenuSelected;
  final VoidCallback? onTap;

  Color get _accentColor {
    switch (task.taskDetail.status) {
      case TaskStatus.pending:
        return AppColor.primaryBlue;
      case TaskStatus.completed:
        return AppColor.successGreen;
      case TaskStatus.overdue:
        return AppColor.alertRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dueFormatted =
        DateFormat('EEE HH:mm').format(task.taskDetail.dueDate);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.pureWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: AppColor.shadowColor,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Coloured left accent bar
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: _accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.taskDetail.name,
                            style: AppTextStyle.bodySmall.copyWith(
                              fontWeight: AppTextStyle.medium,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$dueFormatted  •  ${task.classCode}',
                            style: AppTextStyle.captionMedium,
                          ),
                        ],
                      ),
                    ),
                    // Three-dot menu
                    _TaskMenu(
                      showMarkCompleted:
                          task.taskDetail.status == TaskStatus.pending,
                      onSelected: onMenuSelected,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }
}

class _TaskMenu extends StatelessWidget {
  const _TaskMenu({
    required this.showMarkCompleted,
    required this.onSelected,
  });

  final bool showMarkCompleted;
  final void Function(TaskCardMenuAction action) onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TaskCardMenuAction>(
      icon: const Icon(
        Icons.more_horiz,
        color: AppColor.secondaryText,
        size: 20,
      ),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: onSelected,
      itemBuilder: (_) => [
        if (showMarkCompleted)
          _menuItem(
            value: TaskCardMenuAction.markCompleted,
            icon: Icons.check_circle_outline,
            label: 'Mark as Completed',
            color: AppColor.successGreen,
          ),
        _menuItem(
          value: TaskCardMenuAction.view,
          icon: Icons.visibility_outlined,
          label: 'View',
          color: AppColor.primaryText,
        ),
        _menuItem(
          value: TaskCardMenuAction.edit,
          icon: Icons.edit_outlined,
          label: 'Edit',
          color: AppColor.primaryText,
        ),
        _menuItem(
          value: TaskCardMenuAction.delete,
          icon: Icons.delete_outline,
          label: 'Delete',
          color: AppColor.alertRed,
        ),
      ],
    );
  }

  PopupMenuItem<TaskCardMenuAction> _menuItem({
    required TaskCardMenuAction value,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return PopupMenuItem<TaskCardMenuAction>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Text(
            label,
            style: AppTextStyle.bodySmall.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
