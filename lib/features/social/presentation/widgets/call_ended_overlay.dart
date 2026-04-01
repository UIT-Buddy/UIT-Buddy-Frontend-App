import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
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
    required this.receiverAvatar,
  });

  final String receiverName;
  final int durationSeconds;
  final String receiverId;
  final String receiverAvatar;

  @override
  State<CallEndedOverlay> createState() => _CallEndedOverlayState();
}

class _AvatarInitial extends StatelessWidget {
  const _AvatarInitial({required this.initial});

  final String initial;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initial,
        style: AppTextStyle.h2.copyWith(
          color: AppColor.primaryText,
          fontWeight: AppTextStyle.bold,
        ),
      ),
    );
  }
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

    // Auto-dismiss after 4 seconds
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
        receiverAvatar: widget.receiverAvatar,
      ),
    );
  }

  Widget _buildAvatar() {
    final avatarUrl = widget.receiverAvatar;
    final initial = widget.receiverName.isNotEmpty
        ? widget.receiverName[0].toUpperCase()
        : '?';
    const size = 80.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColor.primaryBlue, width: 3),
        color: AppColor.veryLightGrey,
      ),
      child: ClipOval(
        child: avatarUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: avatarUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => _AvatarInitial(initial: initial),
                errorWidget: (context, url, error) =>
                    _AvatarInitial(initial: initial),
              )
            : _AvatarInitial(initial: initial),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final duration = _formatDuration(widget.durationSeconds);

    return Container(
      color: AppColor.pureWhite,
      child: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),

            // Avatar with fade-in
            FadeTransition(opacity: _iconFadeAnimation, child: _buildAvatar()),

            const SizedBox(height: 24),

            Text(
              'Call Ended',
              style: AppTextStyle.h2.copyWith(color: AppColor.primaryText),
            ),

            const SizedBox(height: 8),

            // Duration
            Text(
              duration,
              style: AppTextStyle.heroNumber.copyWith(
                color: AppColor.primaryBlue,
                fontWeight: AppTextStyle.bold,
                fontSize: 48,
              ),
            ),

            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: Text(
                'with ${widget.receiverName}',
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColor.secondaryText,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const Spacer(flex: 3),

            // Redial button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: OutlinedButton.icon(
                onPressed: _redial,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.primaryBlue,
                  side: const BorderSide(
                    color: AppColor.primaryBlue,
                    width: 1.5,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  minimumSize: const Size(double.infinity, 52),
                ),
                icon: const Icon(Icons.call, size: 20),
                label: Text(
                  'Redial',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColor.primaryBlue,
                    fontWeight: AppTextStyle.medium,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}
