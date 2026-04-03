import 'package:flutter/material.dart';
import 'package:cometchat_calls_uikit/cometchat_calls_uikit.dart';

/// Root navigator key shared between GoRouter, bot_toast, and CallNavigationContext.
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Assign CallNavigationContext to use the same navigator key so
/// incoming call overlays can appear above all routes.
void initCallNavigation() {
  CallNavigationContext.navigatorKey = rootNavigatorKey;
}
