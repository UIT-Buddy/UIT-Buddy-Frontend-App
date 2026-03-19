import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/semester_detail_entity.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/semester_detail_screen/semester_detail_bloc.dart';
import 'package:intl/intl.dart';

class SemesterDetailScreen extends StatelessWidget {
  const SemesterDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<SemesterDetailBloc>()..add(const SemesterDetailLoaded()),
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
            if (state.status == SemesterDetailStatus.loading || state.status == SemesterDetailStatus.initial) {
              return const Center(child: CircularProgressIndicator(color: AppColor.primaryBlue));
            } else if (state.status == SemesterDetailStatus.error) {
              return Center(child: Text(state.errorMessage ?? 'Error', style: AppTextStyle.bodyMedium));
            }

            final currentSemesters = state.details.where((s) => s.isCurrent).toList();
            final previousSemesters = state.details.where((s) => !s.isCurrent).toList();

            return SingleChildScrollView(
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
                  ]
                ],
              ),
            );
          },
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
  final SemesterDetailEntity semester;

  const _SemesterCard({required this.semester});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final startStr = dateFormat.format(semester.startDate);
    final endStr = dateFormat.format(semester.endDate);
    
    // According to mock design: blue border line for current, grey for previous
    final lineColor = semester.isCurrent ? AppColor.primaryBlue : AppColor.dividerGrey;
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
            Container(width: 4, decoration: BoxDecoration(color: lineColor, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('HK${semester.semesterNumber}', style: AppTextStyle.h3.copyWith(fontWeight: AppTextStyle.bold)),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_horiz, color: AppColor.secondaryText),
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
                            child: Text('Delete', style: TextStyle(color: AppColor.alertRed)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text('${semester.yearStart} - ${semester.yearEnd}', style: AppTextStyle.bodySmall.copyWith(color: AppColor.secondaryText)),
                  const SizedBox(height: 16),
                  Text('START DATE', style: AppTextStyle.captionSmall.copyWith(fontWeight: AppTextStyle.bold, color: AppColor.secondaryText)),
                  Text(startStr, style: AppTextStyle.bodySmall.copyWith(color: AppColor.secondaryText)),
                  const SizedBox(height: 12),
                  Text('END DATE', style: AppTextStyle.captionSmall.copyWith(fontWeight: AppTextStyle.bold, color: AppColor.secondaryText)),
                  Text(endStr, style: AppTextStyle.bodySmall.copyWith(color: AppColor.secondaryText)),
                  const SizedBox(height: 16),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: AppColor.primaryBlue, borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(semester.gpa.toStringAsFixed(1), style: AppTextStyle.h2.copyWith(color: Colors.white, fontWeight: AppTextStyle.bold)),
                                Text('(8.0)', style: const TextStyle(color: Colors.white, fontSize: 10)),
                                const Spacer(),
                                Text(gpaLabel, style: AppTextStyle.captionMedium.copyWith(color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: AppColor.primaryBlue, borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${semester.credits}', style: AppTextStyle.h2.copyWith(color: Colors.white, fontWeight: AppTextStyle.bold)),
                                const Spacer(),
                                Text('Credits (this term)', style: AppTextStyle.captionMedium.copyWith(color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
