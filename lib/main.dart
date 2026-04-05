import 'package:bot_toast/bot_toast.dart';
import 'package:cometchat_calls_uikit/cometchat_calls_uikit.dart';
import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/app/app.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/app/router/app_router_keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize bot_toast assertion guard (must happen before any BotToast.show... call)
  BotToastNavigatorObserver();

  // Initialize call navigation so incoming call overlays appear above all routes
  initCallNavigation();
  CometChatThemeMode.mode = ThemeMode.light;
  await initDependencies();
  runApp(const MainApp());
}
