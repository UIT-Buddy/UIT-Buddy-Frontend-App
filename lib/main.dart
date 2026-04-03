import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/app/app.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize bot_toast assertion guard (must happen before any BotToast.show... call)
  BotToastNavigatorObserver();

  await initDependencies();
  runApp(const MainApp());
}
