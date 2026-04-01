import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/call_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/call/call_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/call/call_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/call/call_state.dart';

/// Full-screen overlay shown when an incoming call is received.
class IncomingCallOverlay extends StatefulWidget {
  const IncomingCallOverlay({super.key});

  @override
  State<IncomingCallOverlay> createState() => _IncomingCallOverlayState();
}

class _IncomingCallOverlayState extends State<IncomingCallOverlay> {
  bool _isBusy = false;

  void _cancel() {
    if (_isBusy) return;
    setState(() => _isBusy = true);
    context.read<CallBloc>()
      ..add(const CallReject(busy: true))
      ..add(const CallEnd());
  }

  void _decline() {
    if (_isBusy) return;
    setState(() => _isBusy = true);
    context.read<CallBloc>().add(const CallReject(busy: false));
  }

  void _accept() {
    if (_isBusy) return;
    setState(() => _isBusy = true);
    context.read<CallBloc>().add(const CallAccept());
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<CallBloc>().state;
    final call = state is CallIncoming ? state.incomingCall : null;
    if (call == null) return const SizedBox.shrink();

    return Container(
      color: AppColor.primaryText.withValues(alpha: 0.85),
      child: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            // Caller avatar
            _buildAvatar(call),
            const SizedBox(height: 24),
            // Caller name
            Text(
              call.senderName.isNotEmpty ? call.senderName : 'Unknown',
              style: AppTextStyle.h3.copyWith(
                color: AppColor.pureWhite,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Call type label
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.call, color: AppColor.successGreen, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Incoming audio call',
                  style: AppTextStyle.bodySmall.copyWith(
                    color: AppColor.pureWhite.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
            const Spacer(flex: 3),
            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Cancel (hang up / busy)
                  _ActionButton(
                    icon: Icons.call_end,
                    iconColor: AppColor.pureWhite,
                    backgroundColor: AppColor.alertRed,
                    label: 'Cancel',
                    onTap: _cancel,
                    isLoading: _isBusy,
                  ),
                  // Decline (reject)
                  _ActionButton(
                    icon: Icons.not_interested,
                    iconColor: AppColor.pureWhite,
                    backgroundColor: AppColor.secondaryText,
                    label: 'Decline',
                    onTap: _decline,
                    isLoading: _isBusy,
                  ),
                  // Accept
                  _ActionButton(
                    icon: Icons.call,
                    iconColor: AppColor.pureWhite,
                    backgroundColor: AppColor.successGreen,
                    label: 'Accept',
                    onTap: _accept,
                    isLoading: _isBusy,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(CallEntity call) {
    final avatarUrl = call.senderAvatar ?? '';
    const size = 96.0;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColor.pureWhite.withValues(alpha: 0.3),
          width: 3,
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: AppColor.primaryBlue.withValues(alpha: 0.3),
        backgroundImage: avatarUrl.isNotEmpty
            ? CachedNetworkImageProvider(avatarUrl)
            : null,
        child: avatarUrl.isEmpty
            ? Text(
                _initial(call.senderName),
                style: AppTextStyle.h3.copyWith(
                  color: AppColor.pureWhite,
                  fontWeight: FontWeight.w600,
                ),
              )
            : null,
      ),
    );
  }

  String _initial(String name) {
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

/// Animated call action button.
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String label;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: isLoading ? null : onTap,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: backgroundColor.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(18),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Icon(icon, color: iconColor, size: 28),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: AppTextStyle.captionExtraSmall.copyWith(
            color: AppColor.pureWhite.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
