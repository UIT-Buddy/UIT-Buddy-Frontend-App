import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/call/call_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/call/call_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/call/call_state.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/animated_dots.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/ringing_painter.dart';

/// Full-screen overlay shown when an outgoing call is initiated
/// (CallOutgoing / CallConnecting states).
class CallingOverlay extends StatefulWidget {
  const CallingOverlay({super.key});

  @override
  State<CallingOverlay> createState() => _CallingOverlayState();
}

class _CallingOverlayState extends State<CallingOverlay> {
  @override
  Widget build(BuildContext context) {
    final state = context.read<CallBloc>().state;

    String receiverName = '';
    bool isConnecting = false;

    if (state is CallOutgoing) {
      receiverName = state.receiverName;
    } else if (state is CallConnecting) {
      receiverName = state.receiverName;
      isConnecting = true;
    }

    final initial = receiverName.isNotEmpty
        ? receiverName[0].toUpperCase()
        : '?';

    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),

            // Avatar with expanding rings
            RingingAvatar(
              size: 160,
              color: AppColor.primaryBlue,
              startRadius: 44,
              maxRadiusExtension: 60,
              maxOpacity: 0.5,
              strokeWidth: 2.0,
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.primaryBlue.withValues(alpha: 0.15),
                  border: Border.all(
                    color: AppColor.primaryBlue.withValues(alpha: 0.3),
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: AppTextStyle.h2.copyWith(
                      color: AppColor.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Animated "Calling..." / "Connecting..." text
            AnimatedDots(
              text: isConnecting ? 'Connecting' : 'Calling $receiverName',
              style: AppTextStyle.bodyLarge.copyWith(
                color: AppColor.pureWhite,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Audio call',
              style: AppTextStyle.bodySmall.copyWith(
                color: AppColor.pureWhite.withValues(alpha: 0.6),
              ),
            ),

            const Spacer(flex: 3),

            // End call button with scale press animation
            _AnimatedCallButton(
              backgroundColor: AppColor.alertRed,
              icon: Icons.call_end,
              iconColor: AppColor.pureWhite,
              size: 72,
              label: 'Cancel',
              labelColor: AppColor.pureWhite.withValues(alpha: 0.7),
              onTap: () {
                context.read<CallBloc>().add(const CallEnd());
              },
            ),

            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}

/// Call action button with scale-press animation.
class _AnimatedCallButton extends StatefulWidget {
  const _AnimatedCallButton({
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.labelColor,
    required this.onTap,
    this.size = 64,
  });

  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;
  final String label;
  final Color labelColor;
  final VoidCallback onTap;
  final double size;

  @override
  State<_AnimatedCallButton> createState() => _AnimatedCallButtonState();
}

class _AnimatedCallButtonState extends State<_AnimatedCallButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 180),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.88,
    ).animate(CurvedAnimation(parent: _pressController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTapDown: (_) => _pressController.forward(),
          onTapUp: (_) => _pressController.reverse(),
          onTapCancel: () => _pressController.reverse(),
          onTap: widget.onTap,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.backgroundColor.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(widget.icon, color: widget.iconColor, size: 30),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          widget.label,
          style: AppTextStyle.captionExtraSmall.copyWith(
            color: widget.labelColor,
          ),
        ),
      ],
    );
  }
}
