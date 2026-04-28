import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';

class _MockSemester {
  final String title;
  final String yearLabel;
  final String startDate;
  final String endDate;
  final double gpa;
  final int credits;
  final bool isCurrent;

  _MockSemester({
    required this.title,
    required this.yearLabel,
    required this.startDate,
    required this.endDate,
    required this.gpa,
    required this.credits,
    required this.isCurrent,
  });
}

class SemesterDetailScreen extends StatelessWidget {
  const SemesterDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mockSemesters = [
      _MockSemester(
        title: 'HK1',
        yearLabel: '2023 - 2024',
        startDate: '05/09/2023',
        endDate: '15/01/2024',
        gpa: 8.5,
        credits: 18,
        isCurrent: true,
      ),
      _MockSemester(
        title: 'HK2',
        yearLabel: '2022 - 2023',
        startDate: '01/02/2023',
        endDate: '10/06/2023',
        gpa: 8.0,
        credits: 20,
        isCurrent: false,
      ),
      _MockSemester(
        title: 'HK1',
        yearLabel: '2022 - 2023',
        startDate: '05/09/2022',
        endDate: '15/01/2023',
        gpa: 7.8,
        credits: 18,
        isCurrent: false,
      ),
    ];

    final currentSemesters = mockSemesters.where((s) => s.isCurrent).toList();
    final previousSemesters = mockSemesters.where((s) => !s.isCurrent).toList();

    return Scaffold(
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderRow('Current'),
            const SizedBox(height: 12),
            ...currentSemesters.map((s) => _SemesterCard(semester: s)),
            const SizedBox(height: 24),
            if (previousSemesters.isNotEmpty) ...[
              _buildHeaderRow('Previous', showAdd: false),
              const SizedBox(height: 12),
              ...previousSemesters.map((s) => _SemesterCard(semester: s)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(String title, {bool showAdd = true}) {
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

class _SemesterCard extends StatelessWidget {
  final _MockSemester semester;

  const _SemesterCard({required this.semester});

  @override
  Widget build(BuildContext context) {
    final lineColor = semester.isCurrent
        ? AppColor.primaryBlue
        : AppColor.dividerGrey;
    final gpaLabel = semester.isCurrent ? 'GPA' : 'Overall GPA';

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
                        semester.title,
                        style: AppTextStyle.h3.copyWith(
                          fontWeight: AppTextStyle.bold,
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_horiz,
                          color: AppColor.secondaryText,
                        ),
                        onSelected: (value) {
                          // Handle edit/delete
                        },
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
                  Text(
                    semester.yearLabel,
                    style: AppTextStyle.bodySmall.copyWith(
                      color: AppColor.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'START DATE',
                    style: AppTextStyle.captionSmall.copyWith(
                      fontWeight: AppTextStyle.bold,
                      color: AppColor.secondaryText,
                    ),
                  ),
                  Text(
                    semester.startDate,
                    style: AppTextStyle.bodySmall.copyWith(
                      color: AppColor.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'END DATE',
                    style: AppTextStyle.captionSmall.copyWith(
                      fontWeight: AppTextStyle.bold,
                      color: AppColor.secondaryText,
                    ),
                  ),
                  Text(
                    semester.endDate,
                    style: AppTextStyle.bodySmall.copyWith(
                      color: AppColor.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 16),
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
                                  semester.gpa.toStringAsFixed(1),
                                  style: AppTextStyle.h2.copyWith(
                                    color: Colors.white,
                                    fontWeight: AppTextStyle.bold,
                                  ),
                                ),
                                const Text(
                                  '(8.0)',
                                  style: TextStyle(
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
                                  '${semester.credits}',
                                  style: AppTextStyle.h2.copyWith(
                                    color: Colors.white,
                                    fontWeight: AppTextStyle.bold,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  'Credits (this term)',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
