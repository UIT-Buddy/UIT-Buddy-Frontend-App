import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension GoRouterNavigationExtension on BuildContext {
  void goTo(String location, {Object? extraData}) {
    go(location, extra: {'direction': 'forward', 'data': extraData});
  }

  void goBack(String location, {Object? extraData}) {
    go(location, extra: {'direction': 'backward', 'data': extraData});
  }
}
