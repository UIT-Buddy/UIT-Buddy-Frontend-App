import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Ensure this is imported
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/features/home/presentation/widgets/home_deadline_widget.dart';
import 'package:uit_buddy_mobile/features/home/presentation/widgets/home_header_widget.dart';
import 'package:uit_buddy_mobile/features/home/presentation/widgets/home_main_widget.dart';
import 'package:uit_buddy_mobile/features/home/presentation/widgets/selection_option.dart';
import 'package:uit_buddy_mobile/features/session/presentation/bloc/session_bloc.dart';
import 'package:uit_buddy_mobile/features/session/presentation/bloc/session_event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SessionBloc>().add(const SessionUserFetchRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pureWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              HomeHeaderWidget(),
              SizedBox(height: 20),
              HomeMainWidget(),
              SizedBox(height: 24),
              SelectionOptionWidget(),
              SizedBox(height: 28),
              HomeDeadlineWidget(),
            ],
          ),
        ),
      ),
    );
  }
}