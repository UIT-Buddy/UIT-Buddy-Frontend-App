import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/call_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/call/call_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/call/call_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/call/call_state.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/ringing_painter.dart';

/// Full-screen overlay shown when an incoming call is received.
class IncomingCallOverlay extends StatefulWidget {
  const IncomingCallOverlay({super.key});

  @override
  State<IncomingCallOverlay> createState() => _IncomingCallOverlayState();
}

class _IncomingCallOverlayState extends State<IncomingCallOverlay>
    with SingleTickerProviderStateMixin {
  bool _isBusy = false;

  // Bouncing phone icon animation
  late final AnimationController _bounceController;
  late final Animation<Offset> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _bounceAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, -6)).animate(
          CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _decline() {
    if (_isBusy) return;
    HapticFeedback.mediumImpact();
    setState(() => _isBusy = true);
    context.read<CallBloc>().add(const CallReject(busy: false));
  }

  void _accept() {
    if (_isBusy) return;
    HapticFeedback.mediumImpact();
    setState(() => _isBusy = true);
    context.read<CallBloc>().add(const CallAccept());
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<CallBloc>().state;
    final call = state is CallIncoming ? state.incomingCall : null;
    if (call == null) return const SizedBox.shrink();

    final isVideo = call.callType == CallType.video;

    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),

            // Avatar with animated rings + bouncing phone icon
            _buildAvatar(call, isVideo),

            const SizedBox(height: 24),

            // Caller name
            Text(
              call.senderName.isNotEmpty ? call.senderName : 'Unknown',
              style: AppTextStyle.h3.copyWith(
                color: AppColor.pureWhite,
                fontWeight: AppTextStyle.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Call type label with animated icon
            _buildCallTypeLabel(isVideo),

            const Spacer(flex: 3),

            // Action buttons — 2-button layout (Decline + Accept)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Decline
                  _AnimatedActionButton(
                    backgroundColor: AppColor.alertRed,
                    icon: Icons.call_end,
                    iconColor: AppColor.pureWhite,
                    label: 'Decline',
                    onTap: _decline,
                    isLoading: _isBusy,
                    size: 72,
                  ),

                  // Accept
                  _AnimatedActionButton(
                    backgroundColor: AppColor.successGreen,
                    icon: isVideo ? Icons.videocam : Icons.call,
                    iconColor: AppColor.pureWhite,
                    label: 'Accept',
                    onTap: _accept,
                    isLoading: _isBusy,
                    size: 72,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(CallEntity call, bool isVideo) {
    final avatarUrl = call.senderAvatar ?? '';
    const avatarSize = 96.0;
    final initial = call.senderName.isNotEmpty
        ? call.senderName[0].toUpperCase()
        : '?';

    return RingingAvatar(
      size: 180,
      color: AppColor.pureWhite,
      startRadius: 52,
      maxRadiusExtension: 70,
      maxOpacity: 0.45,
      strokeWidth: 2.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Avatar circle
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColor.pureWhite.withValues(alpha: 0.3),
                width: 3,
              ),
            ),
            padding: const EdgeInsets.all(4),
            child: CircleAvatar(
              radius: avatarSize / 2 - 4,
              backgroundColor: AppColor.primaryBlue.withValues(alpha: 0.3),
              backgroundImage: avatarUrl.isNotEmpty
                  ? CachedNetworkImageProvider(avatarUrl)
                  : null,
              child: avatarUrl.isEmpty
                  ? Text(
                      initial,
                      style: AppTextStyle.h3.copyWith(
                        color: AppColor.pureWhite,
                        fontWeight: AppTextStyle.bold,
                      ),
                    )
                  : null,
            ),
          ),

          // Bouncing phone icon overlaid at bottom-center of avatar
          if (!isVideo)
            Positioned(
              bottom: 0,
              right: 0,
              child: SlideTransition(
                position: _bounceAnimation,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColor.successGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.successGreen.withValues(alpha: 0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.call,
                    color: AppColor.pureWhite,
                    size: 18,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCallTypeLabel(bool isVideo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Bouncing call icon
        SlideTransition(
          position: _bounceAnimation,
          child: Icon(
            isVideo ? Icons.videocam : Icons.call,
            color: AppColor.successGreen,
            size: 16,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          isVideo ? 'Incoming video call' : 'Incoming audio call',
          style: AppTextStyle.captionSmallWhite,
        ),
      ],
    );
  }
}

/// Animated call action button with scale-press feedback.
class _AnimatedActionButton extends StatefulWidget {
  const _AnimatedActionButton({
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.size = 72,
  });

  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;
  final bool isLoading;
  final double size;

  @override
  State<_AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<_AnimatedActionButton>
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
          onTap: widget.isLoading ? null : widget.onTap,
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
              child: widget.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Icon(widget.icon, color: widget.iconColor, size: 30),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(widget.label, style: AppTextStyle.captionSmallWhite),
      ],
    );
  }
}
