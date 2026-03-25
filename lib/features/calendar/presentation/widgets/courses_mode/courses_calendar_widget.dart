import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/courses_mode/courses_mode_bloc.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/courses_mode/courses_mode_event.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/courses_mode/courses_mode_state.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/constants/calendar_text.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/courses_mode/courses_error_view.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/courses_mode/courses_header.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/courses_mode/courses_timetable_grid.dart';

// ── Main widget ────────────────────────────────────────────────────────────
class CoursesCalendarWidget extends StatelessWidget {
  const CoursesCalendarWidget({super.key});

  Future<void> _onUpdateCourses(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: CalendarText.updateCoursesPickerTitle,
      type: FileType.custom,
      allowedExtensions: ['ics'],
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) return;
    final file = result.files.single;
    if (file.path == null) return;

    if (!context.mounted) return;
    context.read<CoursesModeBloc>().add(
      CoursesModeUploadScheduleRequested(
        filePath: file.path!,
        fileName: file.name,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoursesModeBloc, CoursesModeState>(
      listenWhen: (prev, curr) => prev.uploadStatus != curr.uploadStatus,
      listener: (context, state) {
        if (state.uploadStatus == UploadScheduleStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(CalendarText.updateCoursesSuccess),
              backgroundColor: AppColor.successGreen,
            ),
          );
        } else if (state.uploadStatus == UploadScheduleStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${CalendarText.updateCoursesError}: ${context.read<CoursesModeBloc>().state.uploadErrorMessage ?? ''}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<CoursesModeBloc, CoursesModeState>(
        builder: (context, state) {
          final screenWidth = MediaQuery.of(context).size.width;
          final hPad = screenWidth * 0.045;
          final radius = screenWidth * 0.065;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Update courses button — above the calendar card
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: _UpdateCoursesButton(
                    isLoading:
                        state.uploadStatus == UploadScheduleStatus.loading,
                    onTap: () => _onUpdateCourses(context),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColor.pureWhite,
                    borderRadius: BorderRadius.circular(radius),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primaryBlue.withValues(alpha: 0.10),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                      BoxShadow(
                        color: AppColor.shadowColor,
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Gradient header strip
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: hPad,
                          vertical: hPad * 0.75,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColor.primaryGradient,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(radius),
                          ),
                        ),
                        child: const CoursesHeader(),
                      ),
                      // Grid / loading / error
                      Padding(
                        padding: EdgeInsets.all(hPad),
                        child: state.status == CoursesModeStatus.loading
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : state.status == CoursesModeStatus.error
                            ? CoursesErrorView(message: state.errorMessage)
                            : CoursesTimetableGrid(courses: state.courses),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _UpdateCoursesButton extends StatelessWidget {
  const _UpdateCoursesButton({required this.isLoading, required this.onTap});

  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColor.primaryBlue.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColor.primaryBlue.withValues(alpha: 0.30),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColor.primaryBlue,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.upload_file,
                    color: AppColor.primaryBlue,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    CalendarText.updateCoursesButton,
                    style: AppTextStyle.captionSmall.copyWith(
                      color: AppColor.primaryBlue,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
