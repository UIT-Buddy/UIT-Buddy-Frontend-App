import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/overlay/app_overlay.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/call/call_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/call/call_event.dart';

/// Full-screen overlay shown briefly when a call ends (CallEnded state).
class CallEndedOverlay extends StatefulWidget {
  const CallEndedOverlay({
    super.key,
    required this.receiverName,
    required this.durationSeconds,
    required this.receiverId,
  });

  final String receiverName;
  final int durationSeconds;
  final String receiverId;

  @override
  State<CallEndedOverlay> createState() => _CallEndedOverlayState();
}

class _CallEndedOverlayState extends State<CallEndedOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _iconAnimController;
  late final Animation<double> _iconFadeAnimation;
  Timer? _autoDismissTimer;

  @override
  void initState() {
    super.initState();
    _iconAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _iconFadeAnimation = CurvedAnimation(
      parent: _iconAnimController,
      curve: Curves.easeOut,
    );
    _iconAnimController.forward();

    // Auto-dismiss after 4 seconds — use Timer to avoid Duration? closure warning
    _autoDismissTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) AppOverlay.I.hideCallEnded();
    });
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    _iconAnimController.dispose();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(1, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _redial() {
    HapticFeedback.lightImpact();
    AppOverlay.I.hideCallEnded();
    context.read<CallBloc>().add(
      CallInitiate(
        receiverId: widget.receiverId,
        isGroup: false,
        receiverName: widget.receiverName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final duration = _formatDuration(widget.durationSeconds);

    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),

            // Call end icon with fade-in
            FadeTransition(
              opacity: _iconFadeAnimation,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.secondaryText.withValues(alpha: 0.2),
                ),
                child: const Icon(
                  Icons.call_end,
                  color: AppColor.secondaryText,
                  size: 40,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text('Call Ended', style: AppTextStyle.h2White),

            const SizedBox(height: 8),

            // Duration
            Text(
              duration,
              style: AppTextStyle.heroNumberWhite.copyWith(
                fontWeight: AppTextStyle.bold,
                fontSize: 48,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'with ${widget.receiverName}',
              style: AppTextStyle.bodySmall.copyWith(
                color: AppColor.pureWhite.withValues(alpha: 0.6),
              ),
            ),

            const Spacer(flex: 3),

            // Redial button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: OutlinedButton.icon(
                onPressed: _redial,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.pureWhite,
                  side: const BorderSide(color: AppColor.pureWhite, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  minimumSize: const Size(double.infinity, 52),
                ),
                icon: const Icon(Icons.call, size: 20),
                label: Text('Redial', style: AppTextStyle.captionSmallWhite),
              ),
            ),

            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}
