import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/home/presentation/bloc/home_bloc.dart';
import 'package:uit_buddy_mobile/features/home/presentation/bloc/home_event.dart';
import 'package:uit_buddy_mobile/features/home/presentation/bloc/home_state.dart';
import 'package:uit_buddy_mobile/features/home/presentation/constants/home_text.dart';
import 'package:uit_buddy_mobile/features/home/presentation/widgets/home_deadline_card.dart';
import 'package:uit_buddy_mobile/features/home/presentation/widgets/home_header_widget.dart';
import 'package:uit_buddy_mobile/features/home/presentation/widgets/home_next_class_card.dart';
import 'package:uit_buddy_mobile/features/home/presentation/widgets/home_quick_actions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<HomeBloc>()..add(const HomeStarted()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.loading ||
              state.status == HomeStatus.initial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColor.primaryBlue),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeHeaderWidget(
                  userName: state.userName,
                  classCountToday: state.classCountToday,
                ),
                const SizedBox(height: 20),
                if (state.nextClass != null)
                  HomeNextClassCard(entity: state.nextClass!),
                const SizedBox(height: 24),
                const HomeQuickActions(),
                const SizedBox(height: 28),
                _DeadlineSection(state: state),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DeadlineSection extends StatelessWidget {
  const _DeadlineSection({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${HomeText.incomingDeadline} (${state.deadlines.length})',
              style: AppTextStyle.h4.copyWith(fontWeight: AppTextStyle.bold),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                HomeText.viewAll,
                style: AppTextStyle.bodySmallBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (state.deadlines.isEmpty)
          Center(
            child: Text(
              'No upcoming deadlines',
              style: AppTextStyle.captionLarge,
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.deadlines.length,
            itemBuilder: (_, index) =>
                HomeDeadlineCard(entity: state.deadlines[index]),
          ),
      ],
    );
  }
}
