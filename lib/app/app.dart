import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/app/router/app_router.dart';
import 'package:uit_buddy_mobile/core/theme/app_theme.dart';
import 'package:uit_buddy_mobile/features/session/presentation/bloc/session_bloc.dart';
import 'package:uit_buddy_mobile/features/session/presentation/bloc/session_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/call/call_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/call/call_state.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/incoming_call_overlay.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider<SessionBloc>(
        create: (_) =>
            serviceLocator<SessionBloc>()..add(SessionUserFetchRequested()),
      ),
      // CallBloc is a singleton — accessible from any screen for incoming call overlay
      BlocProvider<CallBloc>.value(value: serviceLocator<CallBloc>()),
    ],
    child: _AppCallOverlay(
      child: MaterialApp.router(
        title: 'UIT Buddy Mobile',
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        routerConfig: goRouter,
      ),
    ),
  );
}

/// Manages the incoming call overlay at the root level.
/// Uses BlocBuilder so the overlay is shown/dismissed based on CallBloc state,
/// rendering above everything including the bottom navigation bar.
class _AppCallOverlay extends StatefulWidget {
  const _AppCallOverlay({required this.child});

  final Widget child;

  @override
  State<_AppCallOverlay> createState() => _AppCallOverlayState();
}

class _AppCallOverlayState extends State<_AppCallOverlay> {
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CallBloc, CallState>(
      listener: (context, state) {
        debugPrint('[AppOverlay] state changed: $state');
        if (state is CallIncoming) {
          debugPrint('[AppOverlay] → inserting overlay');
          _insertOverlay();
        } else {
          debugPrint('[AppOverlay] → removing overlay');
          _removeOverlay();
        }
      },
      child: widget.child,
    );
  }

  void _insertOverlay() {
    if (_overlayEntry != null) {
      debugPrint('[AppOverlay] already showing, skip');
      return;
    }
    _overlayEntry = OverlayEntry(builder: (_) => const IncomingCallOverlay());
    Overlay.of(context).insert(_overlayEntry!);
    debugPrint('[AppOverlay] overlay inserted');
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
