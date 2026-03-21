import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/features/home/presentation/widgets/home_deadline_widget.dart';
import 'package:uit_buddy_mobile/features/home/presentation/widgets/home_header_widget.dart';
import 'package:uit_buddy_mobile/features/home/presentation/widgets/home_main_widget.dart';
import 'package:uit_buddy_mobile/features/home/presentation/widgets/selection_option.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pureWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeaderWidget(),
              const SizedBox(height: 20),
              const HomeMainWidget(),
              const SizedBox(height: 24),
              const SelectionOptionWidget(),
              const SizedBox(height: 28),
              const HomeDeadlineWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
