import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage<T> buildFlexibleSlideTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  final extraMap = state.extra as Map<String, dynamic>?;
  final direction = extraMap?['direction'] as String? ?? 'forward';

  final beginOffset = direction == 'backward'
      ? const Offset(-1.0, 0.0)
      : const Offset(1.0, 0.0);

  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var tween = Tween(
        begin: beginOffset,
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOut));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
