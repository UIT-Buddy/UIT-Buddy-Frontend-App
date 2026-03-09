import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/course_entity.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/add_deadline/add_deadline_bloc.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/add_deadline/add_deadline_event.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/add_deadline/add_deadline_state.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/constants/calendar_text.dart';
import 'package:uit_buddy_mobile/features/shared/button.dart';
import 'package:uit_buddy_mobile/features/shared/input_text.dart';

void showAddDeadlineModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) => serviceLocator<AddDeadlineBloc>(),
      child: const _AddDeadlineModal(),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Modal shell
// ─────────────────────────────────────────────────────────────────────────────

class _AddDeadlineModal extends StatefulWidget {
  const _AddDeadlineModal();

  @override
  State<_AddDeadlineModal> createState() => _AddDeadlineModalState();
}

class _AddDeadlineModalState extends State<_AddDeadlineModal> {
  final _nameController = TextEditingController();
  final _courseController = TextEditingController();
  final _courseFocusNode = FocusNode();

  CourseEntity? _selectedCourse;
  DateTime? _selectedDate;
  int _selectedHour = 0;
  int _selectedMinute = 0;
  bool _suppressCourseListener = false;

  // Per-field validation errors
  String? _nameError;
  String? _courseError;
  String? _dateError;

  @override
  void initState() {
    super.initState();
    context.read<AddDeadlineBloc>().add(const AddDeadlineStarted());
    _courseController.addListener(_onCourseChanged);
    _courseFocusNode.addListener(_onCourseFocusChanged);
    _nameController.addListener(_onNameChanged);
  }

  void _onNameChanged() {
    if (_nameError != null && _nameController.text.isNotEmpty) {
      setState(() => _nameError = null);
    }
  }

  @override
  void dispose() {
    _nameController
      ..removeListener(_onNameChanged)
      ..dispose();
    _courseController
      ..removeListener(_onCourseChanged)
      ..dispose();
    _courseFocusNode
      ..removeListener(_onCourseFocusChanged)
      ..dispose();
    super.dispose();
  }

  void _onCourseChanged() {
    // Ignore programmatic text changes (e.g. from _selectSuggestion)
    if (_suppressCourseListener) return;
    _selectedCourse = null;
    context.read<AddDeadlineBloc>().add(
      AddDeadlineSearchCoursesRequested(_courseController.text),
    );
  }

  void _onCourseFocusChanged() {
    if (!_courseFocusNode.hasFocus) {
      // Small delay so a suggestion tap registers before dismissal
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) {
          context.read<AddDeadlineBloc>().add(
            const AddDeadlineSearchCoursesRequested(''),
          );
        }
      });
    }
  }

  void _selectSuggestion(CourseEntity course) {
    _suppressCourseListener = true;
    setState(() {
      _selectedCourse = course;
      _courseError = null;
    });
    _courseController
      ..text = course.displayName
      ..selection = TextSelection.collapsed(offset: course.displayName.length);
    _suppressCourseListener = false;
    _courseFocusNode.unfocus();
    context.read<AddDeadlineBloc>().add(
      const AddDeadlineSearchCoursesRequested(''),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (ctx, child) => Theme(
        data: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: AppColor.primaryBlue,
            onPrimary: AppColor.pureWhite,
            surface: AppColor.pureWhite,
            onSurface: AppColor.primaryText,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateError = null;
      });
    }
  }

  void _onCreatePressed() {
    final name = _nameController.text.trim();
    final course = _selectedCourse;
    final date = _selectedDate;

    // Validate all fields and collect errors
    final nameErr = name.isEmpty ? 'Deadline name is required.' : null;
    final courseErr = course == null ? 'Please select a course.' : null;
    final dateErr = date == null ? 'Please select a due date.' : null;

    if (nameErr != null || courseErr != null || dateErr != null) {
      setState(() {
        _nameError = nameErr;
        _courseError = courseErr;
        _dateError = dateErr;
      });
      return;
    }

    final deadline = DateTime(
      date!.year,
      date.month,
      date.day,
      _selectedHour,
      _selectedMinute,
    );

    context.read<AddDeadlineBloc>().add(
      AddDeadlineCreateRequested(
        name: name,
        courseId: course!.courseId,
        deadline: deadline,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocListener<AddDeadlineBloc, AddDeadlineState>(
      listenWhen: (prev, curr) => curr.status == AddDeadlineStatus.created,
      listener: (context, state) {
        // Capture messenger before pop so it outlives the modal's context.
        final messenger = ScaffoldMessenger.of(context);
        Navigator.of(context).pop();
        messenger.showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 10),
                Text(CalendarText.snackbarDeadlineCreated),
              ],
            ),
            backgroundColor: AppColor.successGreen,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          color: AppColor.pureWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.only(bottom: bottomInset),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Drag handle ───────────────────────────────────────────
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColor.dividerGrey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Header row ────────────────────────────────────────────
              Row(
                children: [
                  Text(
                    CalendarText.addDeadlineTitle,
                    style: AppTextStyle.h3.copyWith(
                      fontWeight: AppTextStyle.bold,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: AppColor.veryLightGrey,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: AppColor.secondaryText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ── Deadline Name ─────────────────────────────────────────
              const _FieldLabel(label: CalendarText.fieldDeadlineName),
              const SizedBox(height: 8),
              InputText(
                controller: _nameController,
                hintText: CalendarText.hintDeadlineName,
                leftIcon: Icons.assignment_outlined,
              ),
              if (_nameError != null) _FieldErrorText(message: _nameError!),
              const SizedBox(height: 20),

              // ── Course / Class ────────────────────────────────────────
              const _FieldLabel(label: CalendarText.fieldCourse),
              const SizedBox(height: 8),
              BlocBuilder<AddDeadlineBloc, AddDeadlineState>(
                builder: (context, state) => _CoursePicker(
                  controller: _courseController,
                  focusNode: _courseFocusNode,
                  suggestions: state.suggestions,
                  onSuggestionSelected: _selectSuggestion,
                ),
              ),
              if (_courseError != null) _FieldErrorText(message: _courseError!),
              const SizedBox(height: 20),

              // ── Due Date & Due Time ───────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _FieldLabel(label: CalendarText.fieldDueDate),
                        const SizedBox(height: 8),
                        _DateTimeTile(
                          icon: Icons.calendar_today,
                          value: _selectedDate != null
                              ? DateFormat(
                                  CalendarText.dateFormatDisplay,
                                ).format(_selectedDate!)
                              : null,
                          placeholder: CalendarText.placeholderSelectDate,
                          onTap: _pickDate,
                          hasError: _dateError != null,
                        ),
                        if (_dateError != null)
                          _FieldErrorText(message: _dateError!),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _FieldLabel(label: CalendarText.fieldDueTime),
                        const SizedBox(height: 8),
                        _TimeInput(
                          hour: _selectedHour,
                          minute: _selectedMinute,
                          onHourChanged: (v) =>
                              setState(() => _selectedHour = v),
                          onMinuteChanged: (v) =>
                              setState(() => _selectedMinute = v),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // ── Create Deadline button ────────────────────────────────
              BlocBuilder<AddDeadlineBloc, AddDeadlineState>(
                buildWhen: (prev, curr) => prev.status != curr.status,
                builder: (context, state) => Button(
                  text: CalendarText.buttonCreateDeadline,
                  iconLeft: Icons.add,
                  onPressed: _onCreatePressed,
                  isLoading: state.status == AddDeadlineStatus.loading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Supporting widgets
// ─────────────────────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyle.captionLarge.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: AppColor.secondaryText,
      ),
    );
  }
}

class _FieldErrorText extends StatelessWidget {
  const _FieldErrorText({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 14, color: AppColor.alertRed),
          const SizedBox(width: 4),
          Text(
            message,
            style: AppTextStyle.captionSmall.copyWith(color: AppColor.alertRed),
          ),
        ],
      ),
    );
  }
}

/// Styled text field with a live-filtered suggestions dropdown.
class _CoursePicker extends StatelessWidget {
  const _CoursePicker({
    required this.controller,
    required this.focusNode,
    required this.suggestions,
    required this.onSuggestionSelected,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final List<CourseEntity> suggestions;
  final ValueChanged<CourseEntity> onSuggestionSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: focusNode,
      builder: (context, _) {
        final isFocused = focusNode.hasFocus;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search text field
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: isFocused
                    ? [
                        BoxShadow(
                          color: AppColor.primaryBlue.withValues(alpha: 0.18),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: AppColor.primaryText,
                ),
                decoration: InputDecoration(
                  hintText: CalendarText.hintCourseSearch,
                  hintStyle: const TextStyle(color: AppColor.secondaryText),
                  filled: true,
                  fillColor: isFocused
                      ? AppColor.primaryBlue10
                      : AppColor.veryLightGrey,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColor.primaryBlue,
                      width: 1.5,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isFocused
                        ? AppColor.primaryBlue
                        : AppColor.secondaryText,
                  ),
                ),
              ),
            ),

            // Suggestions dropdown
            if (suggestions.isNotEmpty) ...[
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: AppColor.pureWhite,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    const BoxShadow(
                      color: AppColor.shadowColor,
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                    BoxShadow(
                      color: AppColor.primaryBlue.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: suggestions.asMap().entries.map((entry) {
                      final isLast = entry.key == suggestions.length - 1;
                      return _SuggestionItem(
                        course: entry.value,
                        showDivider: !isLast,
                        onTap: () => onSuggestionSelected(entry.value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _SuggestionItem extends StatelessWidget {
  const _SuggestionItem({
    required this.course,
    required this.showDivider,
    required this.onTap,
  });

  final CourseEntity course;
  final bool showDivider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final code = course.courseId;
    final name = course.courseName;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColor.primaryBlue.withValues(alpha: 0.08),
        highlightColor: AppColor.primaryBlue.withValues(alpha: 0.04),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              child: Row(
                children: [
                  // Course code badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.primaryBlue10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      code,
                      style: AppTextStyle.captionMedium.copyWith(
                        color: AppColor.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Course name
                  Expanded(
                    child: Text(
                      name,
                      style: AppTextStyle.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            if (showDivider)
              const Divider(
                height: 1,
                indent: 14,
                endIndent: 14,
                color: AppColor.dividerGrey,
              ),
          ],
        ),
      ),
    );
  }
}

/// Tappable tile used for date selection.
class _DateTimeTile extends StatelessWidget {
  const _DateTimeTile({
    required this.icon,
    required this.value,
    required this.placeholder,
    required this.onTap,
    this.hasError = false,
  });

  final IconData icon;
  final String? value;
  final String placeholder;
  final VoidCallback onTap;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: hasError
              ? AppColor.alertRed.withValues(alpha: 0.06)
              : hasValue
              ? AppColor.primaryBlue10
              : AppColor.veryLightGrey,
          borderRadius: BorderRadius.circular(16),
          border: hasError
              ? Border.all(color: AppColor.alertRed, width: 1.5)
              : hasValue
              ? Border.all(color: AppColor.primaryBlue, width: 1.5)
              : null,
          boxShadow: hasError
              ? [
                  BoxShadow(
                    color: AppColor.alertRed.withValues(alpha: 0.10),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : hasValue
              ? [
                  BoxShadow(
                    color: AppColor.primaryBlue.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: hasError
                  ? AppColor.alertRed
                  : hasValue
                  ? AppColor.primaryBlue
                  : AppColor.secondaryText,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value ?? placeholder,
                style: hasError
                    ? AppTextStyle.bodySmall.copyWith(
                        color: AppColor.alertRed,
                        fontWeight: FontWeight.w600,
                      )
                    : hasValue
                    ? AppTextStyle.bodySmall.copyWith(
                        color: AppColor.primaryBlue,
                        fontWeight: FontWeight.w600,
                      )
                    : AppTextStyle.bodySmall.copyWith(
                        color: AppColor.secondaryText,
                      ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Inline HH : MM input for selecting a time without a dialog.
/// Drum-roll scroll picker for hour and minute.
class _TimeInput extends StatelessWidget {
  const _TimeInput({
    required this.hour,
    required this.minute,
    required this.onHourChanged,
    required this.onMinuteChanged,
  });

  final int hour;
  final int minute;
  final ValueChanged<int> onHourChanged;
  final ValueChanged<int> onMinuteChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TimeDropdown(
            value: hour,
            count: 24,
            hint: 'HH',
            onChanged: onHourChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            ':',
            style: AppTextStyle.h3.copyWith(
              color: AppColor.secondaryText,
              fontWeight: AppTextStyle.bold,
            ),
          ),
        ),
        Expanded(
          child: _TimeDropdown(
            value: minute,
            count: 60,
            hint: 'MM',
            onChanged: onMinuteChanged,
          ),
        ),
      ],
    );
  }
}

class _TimeDropdown extends StatelessWidget {
  const _TimeDropdown({
    required this.value,
    required this.count,
    required this.hint,
    required this.onChanged,
  });

  final int value;
  final int count;
  final String hint;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: AppColor.primaryBlue10,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.primaryBlue, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryBlue.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.expand_more_rounded,
            color: AppColor.primaryBlue,
            size: 20,
          ),
          dropdownColor: AppColor.pureWhite,
          borderRadius: BorderRadius.circular(14),
          style: AppTextStyle.bodySmall.copyWith(
            color: AppColor.primaryBlue,
            fontWeight: FontWeight.w600,
          ),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
          items: List.generate(count, (i) {
            final label = i.toString().padLeft(2, '0');
            return DropdownMenuItem<int>(
              value: i,
              child: Text(
                label,
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColor.primaryText,
                  fontWeight: FontWeight.normal,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
