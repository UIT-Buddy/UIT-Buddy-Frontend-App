import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/academic_detail_screen/academic_detail_bloc.dart';

class AcademicDetailScreen extends StatelessWidget {
  const AcademicDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<AcademicDetailBloc>()
            ..add(const AcademicDetailLoaded()),
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
            'Academic Details',
            style: AppTextStyle.h3.copyWith(fontWeight: AppTextStyle.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.edit_outlined,
                color: AppColor.primaryText,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocConsumer<AcademicDetailBloc, AcademicDetailState>(
          listenWhen: (prev, curr) => prev.importStatus != curr.importStatus,
          listener: (context, state) {
            if (state.importStatus == AcademicDetailImportStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.importMessage ?? 'Grades imported successfully.',
                  ),
                  backgroundColor: AppColor.successGreen,
                  duration: const Duration(seconds: 2),
                ),
              );
            } else if (state.importStatus ==
                AcademicDetailImportStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.importMessage ?? 'Failed to import grades.',
                  ),
                  backgroundColor: AppColor.alertRed,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.status == AcademicDetailStatus.loading ||
                state.status == AcademicDetailStatus.initial) {
              return const Center(
                child: CircularProgressIndicator(color: AppColor.primaryBlue),
              );
            } else if (state.status == AcademicDetailStatus.error) {
              return Center(
                child: Text(
                  state.errorMessage ?? 'Error',
                  style: AppTextStyle.bodyMedium,
                ),
              );
            }

            final detail = state.detail;
            if (detail == null) {
              return const Center(child: Text('No details found.'));
            }

            final isImporting =
                state.importStatus == AcademicDetailImportStatus.loading;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    'PROGRESS',
                    _formatProgress(detail.majorProgress),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    'ACCUMULATED CREDITS',
                    '${detail.accumulatedCredits}',
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    'ATTEMPTED CREDITS',
                    '${detail.attemptedCredits}',
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    'ACCUMULATED GPA',
                    _formatGpa(
                      detail.accumulatedGpaScale4,
                      detail.accumulatedGpaScale10,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    'ATTEMPTED GPA',
                    _formatGpa(
                      detail.attemptedGpaScale4,
                      detail.attemptedGpaScale10,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    'GENERAL CREDITS',
                    '${detail.accumulatedGeneralCredits}',
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    'FOUNDATION CREDITS',
                    '${detail.accumulatedFoundationCredits}',
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    'MAJOR CREDITS',
                    '${detail.accumulatedMajorCredits}',
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    'ELECTIVE CREDITS',
                    '${detail.accumulatedElectiveCredits}',
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    'POLITICAL CREDITS',
                    '${detail.accumulatedPoliticalCredits}',
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    'GRADUATION CREDITS',
                    '${detail.accumulatedGraduationCredits}',
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.push(RouteName.semesterDetail),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'See semester details',
                            style: AppTextStyle.bodyLarge.copyWith(
                              color: Colors.white,
                              fontWeight: AppTextStyle.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isImporting
                          ? null
                          : () => _onImportGrades(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Import grades',
                            style: AppTextStyle.bodyLarge.copyWith(
                              color: AppColor.primaryBlue,
                              fontWeight: AppTextStyle.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (isImporting)
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColor.primaryBlue,
                              ),
                            )
                          else
                            const Icon(
                              Icons.document_scanner_outlined,
                              color: AppColor.primaryBlue,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle.captionSmall.copyWith(
            color: AppColor.secondaryText,
            fontWeight: AppTextStyle.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppTextStyle.bodyLarge.copyWith(
            fontWeight: AppTextStyle.medium,
          ),
        ),
      ],
    );
  }

  static String _formatProgress(double value) {
    final percent = value <= 1 ? value * 100 : value;
    return '${percent.toStringAsFixed(0)}%';
  }

  static String _formatGpa(double scale4, double scale10) {
    return '${scale4.toStringAsFixed(2)} (${scale10.toStringAsFixed(2)})';
  }

  Future<void> _onImportGrades(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Select grade PDF',
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.single;
    final filePath = file.path;
    if (filePath == null || filePath.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not read the selected file.'),
          backgroundColor: AppColor.alertRed,
        ),
      );
      return;
    }

    if (!context.mounted) return;
    context.read<AcademicDetailBloc>().add(
      AcademicDetailImportRequested(filePath: filePath, fileName: file.name),
    );
  }
}
