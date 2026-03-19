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
      create: (_) => serviceLocator<AcademicDetailBloc>()..add(const AcademicDetailLoaded()),
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
              icon: const Icon(Icons.edit_outlined, color: AppColor.primaryText),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocBuilder<AcademicDetailBloc, AcademicDetailState>(
          builder: (context, state) {
            if (state.status == AcademicDetailStatus.loading || state.status == AcademicDetailStatus.initial) {
              return const Center(child: CircularProgressIndicator(color: AppColor.primaryBlue));
            } else if (state.status == AcademicDetailStatus.error) {
              return Center(child: Text(state.errorMessage ?? 'Error', style: AppTextStyle.bodyMedium));
            }

            final detail = state.detail;
            if (detail == null) {
              return const Center(child: Text('No details found.'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection('PROGRESS', '${detail.majorProgress.toStringAsFixed(0)}%'),
                  const SizedBox(height: 24),
                  _buildSection('ACCUMULATED CREDITS', '${detail.accumulatedCredits}'),
                  const SizedBox(height: 24),
                  _buildSection('ATTEMPTED CREDITS', '${detail.attemptedCredits}'),
                  const SizedBox(height: 24),
                  _buildSection('CURRENT GPA', '${detail.currentGpa.toStringAsFixed(1)} (8.0)'),
                  const SizedBox(height: 24),
                  _buildSection('TARGET GPA', '${detail.targetGpa.toStringAsFixed(1)} (10.0)'),
                  const SizedBox(height: 24),
                  _buildSection('GENERAL CREDITS', '${detail.generalCredits}/43'),
                  const SizedBox(height: 24),
                  _buildSection('FOUNDATION CREDITS', '${detail.foundationCredits}/49'),
                  const SizedBox(height: 24),
                  _buildSection('GRADUATION CREDITS', '${detail.graduationCredits}/10'),
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
                            style: AppTextStyle.bodyLarge.copyWith(color: Colors.white, fontWeight: AppTextStyle.bold),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
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
}
