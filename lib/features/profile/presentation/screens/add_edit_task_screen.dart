import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/task_detail_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/task_entity.dart';

class AddEditTaskScreen extends StatefulWidget {
  const AddEditTaskScreen({super.key, this.existingTask});

  /// Pass an existing task to enter edit mode; null to create a new task.
  final TaskEntity? existingTask;

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _classCdCtrl;
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _urlCtrl;

  late TaskPriority _priority;
  late DateTime _openDate;
  late DateTime _dueDate;
  late TimeOfDay _reminderTime;

  bool get _isEditing => widget.existingTask != null;

  @override
  void initState() {
    super.initState();
    final t = widget.existingTask;
    _nameCtrl = TextEditingController(text: t?.taskDetail.name ?? '');
    _classCdCtrl = TextEditingController(text: t?.classCode ?? '');
    _titleCtrl = TextEditingController(text: t?.taskDetail.title ?? '');
    _descCtrl = TextEditingController(text: t?.taskDetail.description ?? '');
    _urlCtrl = TextEditingController(text: t?.taskDetail.url ?? '');
    _priority = t?.taskDetail.priority ?? TaskPriority.medium;
    _openDate = t?.taskDetail.openDate ?? DateTime.now();
    _dueDate =
        t?.taskDetail.dueDate ?? DateTime.now().add(const Duration(days: 7));
    final reminder = t?.taskDetail.reminderTime;
    _reminderTime = reminder != null
        ? TimeOfDay(hour: reminder.hour, minute: reminder.minute)
        : const TimeOfDay(hour: 16, minute: 0);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _classCdCtrl.dispose();
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _urlCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final reminderAsDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _reminderTime.hour,
      _reminderTime.minute,
    );

    final detail = TaskDetailEntity(
      name: _nameCtrl.text.trim(),
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      url: _urlCtrl.text.trim(),
      priority: _priority,
      openDate: _openDate,
      dueDate: _dueDate,
      reminderTime: reminderAsDateTime,
      status: widget.existingTask?.taskDetail.status ?? TaskStatus.pending,
    );

    final task = TaskEntity(
      id:
          widget.existingTask?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      classCode: _classCdCtrl.text.trim(),
      taskDetail: detail,
    );

    context.pop(task);
  }

  Future<void> _pickDate({
    required BuildContext context,
    required DateTime initial,
    required void Function(DateTime) onPicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initial),
      );
      if (time != null && context.mounted) {
        onPicked(
          DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          ),
        );
      }
    }
  }

  Future<void> _pickReminderTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null) {
      setState(() => _reminderTime = picked);
    }
  }

  String _formatDateTime(DateTime dt) =>
      DateFormat('d MMM yyyy, HH:mm').format(dt);

  @override
  Widget build(BuildContext context) {
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
                    icon: const Icon(Icons.close, color: AppColor.primaryText),
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: Text(
                      _isEditing ? 'Edit Task' : 'New Task',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.h3.copyWith(
                        fontWeight: AppTextStyle.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _submit,
                    child: Text(
                      'Save',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColor.primaryBlue,
                        fontWeight: AppTextStyle.medium,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: AppColor.dividerGrey),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _nameCtrl,
                        label: 'Task Name',
                        hint: 'e.g. Nộp bài công nghệ web',
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _classCdCtrl,
                        label: 'Class Code',
                        hint: 'e.g. SE347.Q14',
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _titleCtrl,
                        label: 'Subject Title',
                        hint: 'e.g. SE347.Q14 - Công nghệ Web',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _descCtrl,
                        label: 'Description',
                        hint: 'Task description',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _urlCtrl,
                        label: 'URL',
                        hint: 'https://courses.uit.edu.vn/...',
                        keyboardType: TextInputType.url,
                      ),
                      const SizedBox(height: 16),
                      _buildPriorityDropdown(),
                      const SizedBox(height: 16),
                      _buildDateTile(
                        label: 'Open Date',
                        value: _formatDateTime(_openDate),
                        onTap: () => _pickDate(
                          context: context,
                          initial: _openDate,
                          onPicked: (dt) => setState(() => _openDate = dt),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDateTile(
                        label: 'Due Date',
                        value: _formatDateTime(_dueDate),
                        onTap: () => _pickDate(
                          context: context,
                          initial: _dueDate,
                          onPicked: (dt) => setState(() => _dueDate = dt),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDateTile(
                        label: 'Reminder Time',
                        value: '${_reminderTime.format(context)} every day',
                        onTap: () => _pickReminderTime(context),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submit,
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
                            _isEditing ? 'Save Changes' : 'Create Task',
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: AppColor.pureWhite,
                              fontWeight: AppTextStyle.medium,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.captionLarge.copyWith(
            fontWeight: AppTextStyle.medium,
            color: AppColor.primaryText,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTextStyle.bodySmall,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyle.placeholder.copyWith(fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor.dividerGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor.dividerGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColor.primaryBlue),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColor.alertRed),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColor.alertRed),
            ),
            filled: true,
            fillColor: AppColor.veryLightGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: AppTextStyle.captionLarge.copyWith(
            fontWeight: AppTextStyle.medium,
            color: AppColor.primaryText,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<TaskPriority>(
          initialValue: _priority,
          style: AppTextStyle.bodySmall,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor.dividerGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor.dividerGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColor.primaryBlue),
            ),
            filled: true,
            fillColor: AppColor.veryLightGrey,
          ),
          items: const [
            DropdownMenuItem(value: TaskPriority.low, child: Text('Low')),
            DropdownMenuItem(value: TaskPriority.medium, child: Text('Medium')),
            DropdownMenuItem(value: TaskPriority.high, child: Text('High')),
          ],
          onChanged: (v) {
            if (v != null) setState(() => _priority = v);
          },
        ),
      ],
    );
  }

  Widget _buildDateTile({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColor.veryLightGrey,
          border: Border.all(color: AppColor.dividerGrey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyle.captionMedium.copyWith(
                      fontWeight: AppTextStyle.medium,
                      color: AppColor.primaryText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(value, style: AppTextStyle.bodySmall),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColor.secondaryText,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
