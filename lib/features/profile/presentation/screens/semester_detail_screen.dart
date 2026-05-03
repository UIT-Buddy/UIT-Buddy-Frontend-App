import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/semester_detail_entity.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/semester_detail_screen/semester_detail_bloc.dart';

class SemesterDetailScreen extends StatelessWidget {
  const SemesterDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<SemesterDetailBloc>()
            ..add(const SemesterDetailLoaded()),
      child: Scaffold(
        backgroundColor: AppColor.pureWhite,
        appBar: AppBar(
          backgroundColor: AppColor.pureWhite,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColor.primaryText),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Semester Details',
            style: AppTextStyle.h3.copyWith(fontWeight: AppTextStyle.bold),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<SemesterDetailBloc, SemesterDetailState>(
          builder: (context, state) {
            if (state.status == SemesterDetailStatus.loading ||
                state.status == SemesterDetailStatus.initial) {
              return const Center(
                child: CircularProgressIndicator(color: AppColor.primaryBlue),
              );
            }

            if (state.status == SemesterDetailStatus.error) {
              return Center(
                child: Text(
                  state.errorMessage ?? 'An error occurred',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColor.alertRed,
                  ),
                ),
              );
            }

            // Sort semesters descending by code so the newest is first
            final details = List<SemesterDetailEntity>.from(state.details)
              ..sort((a, b) => b.semesterCode.compareTo(a.semesterCode));

            if (details.isEmpty) {
              return const Center(child: Text('No details available.'));
            }

            final currentSemester = details.first;
            final previousSemesters = details.length > 1
                ? details.sublist(1)
                : <SemesterDetailEntity>[];

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderRow('Current'),
                  const SizedBox(height: 12),
                  _SemesterCard(semester: currentSemester, isCurrent: true),
                  const SizedBox(height: 24),
                  if (previousSemesters.isNotEmpty) ...[
                    _buildHeaderRow('Previous', showAdd: false),
                    const SizedBox(height: 12),
                    ...previousSemesters.map(
                      (s) => _SemesterCard(semester: s, isCurrent: false),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderRow(String title, {bool showAdd = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyle.h3.copyWith(fontWeight: AppTextStyle.bold),
        ),
        if (showAdd)
          Container(
            decoration: BoxDecoration(
              color: AppColor.primaryBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 24),
          ),
      ],
    );
  }
}

class _SemesterCard extends StatefulWidget {
  final SemesterDetailEntity semester;
  final bool isCurrent;

  const _SemesterCard({required this.semester, required this.isCurrent});

  @override
  State<_SemesterCard> createState() => _SemesterCardState();
}

class _SemesterCardState extends State<_SemesterCard> {
  bool _isExpanded = false;

  String _getCategoryName(String code) {
    switch (code.toUpperCase()) {
      case 'TOTTN':
        return 'Graduation Credits';
      case 'DC':
        return 'General Credits';
      case 'CSNN':
        return 'Foundation (Optional)';
      case 'CSN':
        return 'Foundation Credits';
      case 'CN':
        return 'Major Credits';
      case 'TC':
        return 'Elective (Tự chọn)';
      case 'CT':
        return 'Political Credits';
      case 'TD':
        return 'Free Credits (Tự do)';
      default:
        return code;
    }
  }

  @override
  Widget build(BuildContext context) {
    final semester = widget.semester;
    final lineColor = widget.isCurrent
        ? AppColor.primaryBlue
        : AppColor.dividerGrey;
    final gpaLabel = widget.isCurrent ? 'GPA' : 'Overall GPA';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.veryLightGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: lineColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        semester.semesterCode,
                        style: AppTextStyle.h3.copyWith(
                          fontWeight: AppTextStyle.bold,
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_horiz,
                          color: AppColor.secondaryText,
                        ),
                        onSelected: (value) {},
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text(
                              'Delete',
                              style: TextStyle(color: AppColor.alertRed),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColor.primaryBlue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  semester.averageGradeScale10.toStringAsFixed(
                                    2,
                                  ),
                                  style: AppTextStyle.h2.copyWith(
                                    color: Colors.white,
                                    fontWeight: AppTextStyle.bold,
                                  ),
                                ),
                                Text(
                                  '(${semester.averageGradeScale4.toStringAsFixed(2)})',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  gpaLabel,
                                  style: AppTextStyle.captionMedium.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColor.primaryBlue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${semester.totalCredits}',
                                  style: AppTextStyle.h2.copyWith(
                                    color: Colors.white,
                                    fontWeight: AppTextStyle.bold,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  'Total credits',
                                  style: AppTextStyle.captionMedium.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _isExpanded ? 'Hide Details' : 'View Details',
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: AppColor.primaryBlue,
                              fontWeight: AppTextStyle.bold,
                            ),
                          ),
                          Icon(
                            _isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: AppColor.primaryBlue,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isExpanded) ...[
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      "Credits by Category",
                      style: AppTextStyle.bodyMedium.copyWith(
                        fontWeight: AppTextStyle.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...semester.totalCreditsByCategory.entries
                        .where((e) => e.value > 0)
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    _getCategoryName(e.key),
                                    style: AppTextStyle.bodyMedium,
                                  ),
                                ),
                                Text(
                                  '${e.value} credits',
                                  style: AppTextStyle.bodyMedium.copyWith(
                                    fontWeight: AppTextStyle.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    const SizedBox(height: 16),
                    Text(
                      "Grades",
                      style: AppTextStyle.bodyMedium.copyWith(
                        fontWeight: AppTextStyle.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...semester.grades.map(
                      (g) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${g.courseCode} - ${g.courseName}',
                              style: AppTextStyle.bodyMedium.copyWith(
                                fontWeight: AppTextStyle.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Credits: ${g.credits} | Type: ${_getCategoryName(g.courseType)}',
                                  style: AppTextStyle.captionMedium.copyWith(
                                    color: AppColor.secondaryText,
                                  ),
                                ),
                                Text(
                                  g.totalGrade != null
                                      ? g.totalGrade!.toStringAsFixed(1)
                                      : 'N/A',
                                  style: AppTextStyle.bodyMedium.copyWith(
                                    color: AppColor.primaryBlue,
                                    fontWeight: AppTextStyle.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
