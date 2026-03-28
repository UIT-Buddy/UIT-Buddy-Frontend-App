import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_posts_screen/your_posts_bloc.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_posts_screen/your_posts_event.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/widgets/your_posts_body.dart';

class YourPostsScreen extends StatelessWidget {
  const YourPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<YourPostsBloc>()..add(const YourPostsLoaded()),
      child: const YourPostsBody(),
    );
  }
}

