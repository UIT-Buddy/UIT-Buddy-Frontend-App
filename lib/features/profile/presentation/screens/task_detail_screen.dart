import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/task_detail_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/task_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.task});

  final TaskEntity task;

  Future<void> _launchUrl(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      _showSnackBar(context, 'Invalid URL');
      return;
    }
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) _showSnackBar(context, 'Could not open URL');
    }
  }

  void _copyUrl(BuildContext context, String url) {
    Clipboard.setData(ClipboardData(text: url));
    _showSnackBar(context, 'URL copied to clipboard');
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleMarkCompleted(BuildContext context) {
    context.pop({'action': _TaskDetailAction.completed, 'taskId': task.id});
  }

  void _handleDelete(BuildContext context) {
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
              context.pop({'action': _TaskDetailAction.deleted, 'taskId': task.id});
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppColor.alertRed),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleEdit(BuildContext context) async {
    final updated = await context.push<TaskEntity>(
      RouteName.addEditTask,
      extra: {'task': task, 'direction': 'forward'},
    );
    if (updated != null && context.mounted) {
      context.pop({
        'action': _TaskDetailAction.edited,
        'taskId': updated.id,
        'task': updated,
      });
    }
  }

  String _formatDate(DateTime dt) =>
      DateFormat('H:mm EEEE d, yyyy').format(dt);

  String _formatReminderTime(DateTime dt) =>
      '${DateFormat('HH:mm').format(dt)} every day';

  @override
  Widget build(BuildContext context) {
    final detail = task.taskDetail;
    final isPending = detail.status == TaskStatus.pending;

    return Scaffold(
      backgroundColor: AppColor.pureWhite,
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
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Task Details',
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

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // URL row
                    _DetailField(
                      label: 'URL',
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _launchUrl(context, detail.url),
                              child: Text(
                                detail.url
                                    .replaceFirst('https://', '')
                                    .replaceFirst('http://', ''),
                                style: AppTextStyle.bodySmall.copyWith(
                                  color: AppColor.primaryBlue,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColor.primaryBlue,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _copyUrl(context, detail.url),
                            child: const Icon(
                              Icons.copy_outlined,
                              size: 18,
                              color: AppColor.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),

                    _DetailField(
                      label: 'NAME',
                      child: Text(detail.name, style: AppTextStyle.bodySmall),
                    ),
                    _DetailField(
                      label: 'TITLE',
                      child: Text(detail.title, style: AppTextStyle.bodySmall),
                    ),
                    _DetailField(
                      label: 'DESCRIPTION',
                      child: Text(
                        detail.description,
                        style: AppTextStyle.bodySmall,
                      ),
                    ),
                    _DetailField(
                      label: 'PRIORITY',
                      child: Text(
                        _priorityLabel(detail.priority),
                        style: AppTextStyle.bodySmall,
                      ),
                    ),
                    _DetailField(
                      label: 'OPEN DATE',
                      child: Text(
                        _formatDate(detail.openDate),
                        style: AppTextStyle.bodySmall,
                      ),
                    ),
                    _DetailField(
                      label: 'DUE DATE',
                      child: Text(
                        _formatDate(detail.dueDate),
                        style: AppTextStyle.bodySmall,
                      ),
                    ),
                    _DetailField(
                      label: 'REMINDER AT',
                      child: Text(
                        _formatReminderTime(detail.reminderTime),
                        style: AppTextStyle.bodySmall,
                      ),
                    ),
                    _DetailField(
                      label: 'STATUS',
                      child: _StatusBadge(status: detail.status),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom action buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                children: [
                  if (isPending) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _handleMarkCompleted(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryBlue,
                          foregroundColor: AppColor.pureWhite,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Mark as Completed',
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColor.pureWhite,
                            fontWeight: AppTextStyle.medium,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _handleEdit(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColor.primaryText,
                            side: BorderSide(color: AppColor.dividerGrey),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Edit',
                            style: AppTextStyle.bodyMedium.copyWith(
                              fontWeight: AppTextStyle.medium,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _handleDelete(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.alertRed,
                            foregroundColor: AppColor.pureWhite,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Delete',
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: AppColor.pureWhite,
                              fontWeight: AppTextStyle.medium,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _priorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
    }
  }
}

class _DetailField extends StatelessWidget {
  const _DetailField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyle.captionMedium.copyWith(
              fontWeight: AppTextStyle.medium,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;
    switch (status) {
      case TaskStatus.pending:
        color = AppColor.primaryBlue;
        label = 'PENDING';
      case TaskStatus.completed:
        color = AppColor.successGreen;
        label = 'COMPLETED';
      case TaskStatus.overdue:
        color = AppColor.alertRed;
        label = 'OVERDUE';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyle.captionMedium.copyWith(
          color: color,
          fontWeight: AppTextStyle.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// Internal enum for result communication
enum _TaskDetailAction { completed, deleted, edited }
