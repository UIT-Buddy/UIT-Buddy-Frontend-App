import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/call/call_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/call/call_state.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/incoming_call_overlay.dart';

/// Shared GlobalKey for the root Navigator.
/// Set once in [GoRouter] config. Used by [AppOverlay] to insert overlay entries
/// from anywhere in the widget tree.
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Manages app-wide overlay entries (e.g. incoming call overlay).
///
/// This class stores a reference to the root [NavigatorState] so that overlays
/// can be inserted even from widgets whose context does not have an Overlay
/// ancestor (e.g. a BLoC listener at the app root).
class AppOverlay {
  AppOverlay._();
  static final AppOverlay I = AppOverlay._();

  OverlayEntry? _incomingCallEntry;

  /// Insert the incoming call overlay if not already shown.
  void showIncomingCall() {
    if (_incomingCallEntry != null) return;

    final entry = OverlayEntry(
      builder: (_) => const IncomingCallOverlay(),
    );
    _incomingCallEntry = entry;

    // Defer to ensure the navigator is built before we insert into it.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _insert(entry);
    });
  }

  /// Dismiss the incoming call overlay if shown.
  void hideIncomingCall() {
    _incomingCallEntry?.remove();
    _incomingCallEntry = null;
  }

  void _insert(OverlayEntry entry) {
    final nav = rootNavigatorKey.currentState;
    if (nav == null) return;
    nav.overlay?.insert(entry);
  }
}

/// A [StatefulWidget] that listens to [CallBloc] state changes and shows /
/// dismisses the incoming call overlay globally.
class AppOverlayManager extends StatefulWidget {
  const AppOverlayManager({super.key, required this.child});

  final Widget child;

  @override
  State<AppOverlayManager> createState() => _AppOverlayManagerState();
}

class _AppOverlayManagerState extends State<AppOverlayManager> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<CallBloc, CallState>(
      listener: (context, state) {
        if (state is CallIncoming) {
          AppOverlay.I.showIncomingCall();
        } else {
          AppOverlay.I.hideIncomingCall();
        }
      },
      child: widget.child,
    );
  }
}
