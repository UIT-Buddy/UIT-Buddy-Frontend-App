import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/deadline/domain/entities/deadline_entity.dart';
import 'package:uit_buddy_mobile/features/deadline/presentation/bloc/deadline_bloc.dart';
import 'package:uit_buddy_mobile/features/deadline/presentation/bloc/deadline_event.dart';
import 'package:uit_buddy_mobile/features/deadline/presentation/bloc/deadline_state.dart';

class DeadlineDetailScreen extends StatelessWidget {
  const DeadlineDetailScreen({super.key, required this.deadlineId});

  final String deadlineId;

  String _formatDate(DateTime dt) => DateFormat('H:mm EEEE d, yyyy').format(dt);

  Future<void> _showUpdateDialog(
    BuildContext context, {
    required DeadlineEntity detail,
    required bool isUpdating,
  }) async {
    String newName = detail.exerciseName;
    DeadlineStatus newStatus = detail.status;
    DateTime newDueDate = detail.dueDate;
    String? nameError;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            return AlertDialog(
              title: Text(
                'Update deadline',
                style: AppTextStyle.bodyLarge.copyWith(
                  fontWeight: AppTextStyle.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name',
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColor.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: newName,
                          onChanged: (value) {
                            newName = value;
                            if (nameError == null) return;
                            setState(() {
                              nameError = value.trim().isEmpty
                                  ? 'Deadline name cannot be empty.'
                                  : null;
                            });
                          },
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'New Deadline Name',
                            errorText: nameError,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status',
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColor.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownMenu<DeadlineStatus>(
                          initialSelection: newStatus,
                          onSelected: (value) {
                            if (value != null) {
                              setState(() => newStatus = value);
                            }
                          },
                          dropdownMenuEntries: DeadlineStatus.values
                              .map(
                                (status) => DropdownMenuEntry(
                                  value: status,
                                  label: status.name.toUpperCase(),
                                ),
                              )
                              .toList(),
                          width: MediaQuery.of(context).size.width * 0.6,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Due Date',
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColor.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: newDueDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );

                            if (selectedDate != null) {
                              if (!context.mounted) return;
                              final selectedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(newDueDate),
                              );
                              if (selectedTime != null) {
                                setState(() {
                                  newDueDate = DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    selectedTime.hour,
                                    selectedTime.minute,
                                  );
                                });
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat(
                                    'yyyy-MM-dd HH:mm',
                                  ).format(newDueDate),
                                  style: AppTextStyle.bodyMedium,
                                ),
                                const Icon(Icons.calendar_today, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                          final trimmedName = newName.trim();
                          if (trimmedName.isEmpty) {
                            setState(() {
                              nameError = 'Deadline name cannot be empty.';
                            });
                            return;
                          }

                          context.read<DeadlineBloc>().add(
                            UpdateDeadlineRequested(
                              exerciseName: trimmedName,
                              studentTaskId: detail.id,
                              status: newStatus.name.toUpperCase(),
                              dueDate: newDueDate,
                            ),
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
    return Scaffold(
      backgroundColor: AppColor.pureWhite,
      body: SafeArea(
        child: BlocBuilder<DeadlineBloc, DeadlineState>(
          builder: (context, state) {
            if (state.status == DeadlineStateStatus.loading ||
                state.status == DeadlineStateStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == DeadlineStateStatus.error) {
              return Center(
                child: Text(
                  state.errorMessage ?? 'Error',
                  style: TextStyle(color: AppColor.alertRed),
                ),
              );
            } else if (state.status == DeadlineStateStatus.loaded &&
                state.deadlineDetail != null) {
              final detail = state.deadlineDetail!;
              return Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
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
                            'Deadline Details',
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
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (detail.url != null && detail.url!.isNotEmpty)
                              _DetailField(
                                label: 'URL',
                                child: Text(
                                  detail.url!,
                                  style: AppTextStyle.bodyLarge.copyWith(
                                    color: AppColor.primaryBlue,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColor.primaryBlue,
                                  ),
                                ),
                              ),
                            _DetailField(
                              label: 'NAME',
                              child: Text(
                                detail.exerciseName,
                                style: AppTextStyle.bodyLarge,
                              ),
                            ),
                            _DetailField(
                              label: 'DUE DATE',
                              child: Text(
                                _formatDate(detail.dueDate),
                                style: AppTextStyle.bodyLarge,
                              ),
                            ),
                            if (detail.classCode != null &&
                                detail.classCode!.isNotEmpty)
                              _DetailField(
                                label: 'CLASS CODE',
                                child: Text(
                                  detail.classCode!,
                                  style: AppTextStyle.bodyLarge,
                                ),
                              ),
                            _DetailField(
                              label: 'STATUS',
                              child: _StatusBadge(status: detail.status.name),
                            ),
                            _DetailField(
                              label: 'TYPE',
                              child: Text(
                                detail.isPersonal ? 'Personal' : 'Course',
                                style: AppTextStyle.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _showUpdateDialog(
                          context,
                          detail: detail,
                          isUpdating:
                              state.status == DeadlineStateStatus.loading,
                        ),
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
                          'Update Deadline',
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColor.pureWhite,
                            fontWeight: AppTextStyle.medium,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _DetailField extends StatelessWidget {
  const _DetailField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyle.captionLarge.copyWith(
              fontSize: 14,
              fontWeight: AppTextStyle.extraBold,
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

  final String status;

  @override
  Widget build(BuildContext context) {
    Color color = AppColor.primaryText;
    String label = status.toUpperCase();

    if (label.contains('PENDING') || label.contains('UPCOMING')) {
      color = AppColor.primaryBlue;
    } else if (label.contains('DONE') || label.contains('COMPLETED')) {
      color = AppColor.successGreen;
    } else if (label.contains('NEARDEADLINE')) {
      color = AppColor.warningOrange;
    } else if (label.contains('OVERDUE')) {
      color = AppColor.alertRed;
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
