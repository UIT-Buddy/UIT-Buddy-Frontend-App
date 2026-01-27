import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/app/router/app_router.dart';
import 'package:uit_buddy_mobile/core/theme/app_theme.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    routerConfig: goRouter,
    title: 'UIT Buddy Mobile',
    themeMode: ThemeMode.light,
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
  );
}
