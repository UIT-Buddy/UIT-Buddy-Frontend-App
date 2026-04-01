import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/call/call_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/call/call_state.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/call_ended_overlay.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/calling_overlay.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/incoming_call_overlay.dart';

/// Shared GlobalKey for the root Navigator.
/// Set once in [GoRouter] config. Used by [AppOverlay] to insert overlay entries
/// from anywhere in the widget tree.
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Manages app-wide overlay entries (incoming call, calling, call ended).
///
/// This class stores a reference to the root [NavigatorState] so that overlays
/// can be inserted even from widgets whose context does not have an Overlay
/// ancestor (e.g. a BLoC listener at the app root).
class AppOverlay {
  AppOverlay._();
  static final AppOverlay I = AppOverlay._();

  OverlayEntry? _incomingCallEntry;
  OverlayEntry? _callingEntry;
  OverlayEntry? _callEndedEntry;

  /// Insert the incoming call overlay if not already shown.
  void showIncomingCall() {
    if (_incomingCallEntry != null) return;

    final entry = OverlayEntry(builder: (_) => const IncomingCallOverlay());
    _incomingCallEntry = entry;

    _deferInsert(entry);
  }

  /// Dismiss the incoming call overlay if shown.
  void hideIncomingCall() {
    _incomingCallEntry?.remove();
    _incomingCallEntry = null;
  }

  /// Insert the calling overlay (shown during CallOutgoing / CallConnecting).
  void showCalling() {
    if (_callingEntry != null) return;

    final entry = OverlayEntry(builder: (_) => const CallingOverlay());
    _callingEntry = entry;

    _deferInsert(entry);
  }

  /// Dismiss the calling overlay.
  void hideCalling() {
    _callingEntry?.remove();
    _callingEntry = null;
  }

  /// Insert the call-ended overlay.
  void showCallEnded({
    required String receiverName,
    required int durationSeconds,
    required String receiverId,
    required String receiverAvatar,
  }) {
    if (_callEndedEntry != null) return;

    final entry = OverlayEntry(
      builder: (_) => CallEndedOverlay(
        receiverName: receiverName,
        durationSeconds: durationSeconds,
        receiverId: receiverId,
        receiverAvatar: receiverAvatar,
      ),
    );
    _callEndedEntry = entry;

    _deferInsert(entry);
  }

  /// Dismiss the call-ended overlay.
  void hideCallEnded() {
    _callEndedEntry?.remove();
    _callEndedEntry = null;
  }

  /// Dismiss all call-related overlays.
  void hideAll() {
    hideIncomingCall();
    hideCalling();
    hideCallEnded();
  }

  void _deferInsert(OverlayEntry entry) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _insert(entry);
    });
  }

  void _insert(OverlayEntry entry) {
    final nav = rootNavigatorKey.currentState;
    if (nav == null) return;
    nav.overlay?.insert(entry);
  }
}

/// A [StatefulWidget] that listens to [CallBloc] state changes and shows /
/// dismisses call overlays globally.
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
        // ── Incoming call ──────────────────────────────────────────────
        if (state is CallIncoming) {
          AppOverlay.I.showIncomingCall();
        } else {
          AppOverlay.I.hideIncomingCall();
        }

        // ── Calling (outgoing / connecting) ────────────────────────────
        if (state is CallOutgoing || state is CallConnecting) {
          AppOverlay.I.showCalling();
        } else {
          AppOverlay.I.hideCalling();
        }

        // ── Call ended ─────────────────────────────────────────────────
        if (state is CallEnded) {
          AppOverlay.I.showCallEnded(
            receiverName: state.receiverName,
            durationSeconds: state.durationSeconds,
            receiverId: state.receiverId,
            receiverAvatar: state.receiverAvatar,
          );
        } else {
          AppOverlay.I.hideCallEnded();
        }
      },
      child: widget.child,
    );
  }
}
