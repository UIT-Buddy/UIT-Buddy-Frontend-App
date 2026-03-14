import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/social_text.dart';

class PostContentInput extends StatelessWidget {
  const PostContentInput({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      maxLines: null,
      minLines: 4,
      textCapitalization: TextCapitalization.sentences,
      style: AppTextStyle.bodyLarge.copyWith(height: 1.6),
      decoration: InputDecoration(
        hintText: SocialText.createPostHint,
        hintStyle: AppTextStyle.bodyLarge.copyWith(
          color: AppColor.tertiaryText,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: false,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
