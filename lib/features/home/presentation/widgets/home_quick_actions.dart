import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/home/presentation/constants/home_text.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({super.key, this.onScanQr, this.onDocument, this.onNote, this.onClock});

  final VoidCallback? onScanQr;
  final VoidCallback? onDocument;
  final VoidCallback? onNote;
  final VoidCallback? onClock;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ActionButton(
          icon: Icons.qr_code_scanner,
          label: HomeText.scanQr,
          color: AppColor.primaryBlue,
          backgroundColor: AppColor.primaryBlue10,
          onTap: onScanQr,
        ),
        _ActionButton(
          icon: Icons.description_outlined,
          label: HomeText.document,
          color: AppColor.successGreen,
          backgroundColor: AppColor.successGreen10,
          onTap: onDocument,
        ),
        _ActionButton(
          icon: Icons.edit_note_outlined,
          label: HomeText.note,
          color: const Color(0xFF9B59B6),
          backgroundColor: const Color(0x1A9B59B6),
          onTap: onNote,
        ),
        _ActionButton(
          icon: Icons.alarm_outlined,
          label: HomeText.clock,
          color: AppColor.warningOrange,
          backgroundColor: AppColor.warningOrangeLight,
          onTap: onClock,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.backgroundColor,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color backgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyle.captionSmall.copyWith(
              color: AppColor.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
