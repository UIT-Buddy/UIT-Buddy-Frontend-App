import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/social_text.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen>
    with SingleTickerProviderStateMixin {
  final _contentController = TextEditingController();
  final _focusNode = FocusNode();
  bool _hasContent = false;

  @override
  void initState() {
    super.initState();
    _contentController.addListener(() {
      final hasText = _contentController.text.trim().isNotEmpty;
      if (hasText != _hasContent) {
        setState(() => _hasContent = hasText);
      }
    });
    // Auto-focus the text field on open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pureWhite,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildAuthorRow(),
                  const SizedBox(height: 16),
                  _buildContentInput(),
                ],
              ),
            ),
          ),
          _buildBottomToolbar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.pureWhite,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.close, color: AppColor.primaryText, size: 24),
        splashRadius: 20,
      ),
      title: Text(
        SocialText.createPostTitle,
        style: AppTextStyle.h3.copyWith(fontWeight: AppTextStyle.bold),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _hasContent ? 1.0 : 0.5,
            child: ElevatedButton(
              onPressed: _hasContent ? _onPostPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryBlue,
                disabledBackgroundColor: AppColor.primaryBlue20,
                foregroundColor: AppColor.pureWhite,
                disabledForegroundColor: AppColor.pureWhite,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
                minimumSize: const Size(0, 34),
              ),
              child: Text(
                SocialText.post,
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColor.pureWhite,
                  fontWeight: AppTextStyle.medium,
                ),
              ),
            ),
          ),
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColor.dividerGrey),
      ),
    );
  }

  Widget _buildAuthorRow() {
    return Row(
      children: [
        // Avatar
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColor.blueAvatarGradient,
          ),
          child: const Center(
            child: Text(
              'M',
              style: TextStyle(
                color: AppColor.pureWhite,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Name & visibility
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Minh',
              style: AppTextStyle.bodyMedium.copyWith(
                fontWeight: AppTextStyle.bold,
              ),
            ),
            const SizedBox(height: 4),

            // Visibility selector pill
          ],
        ),
      ],
    );
  }

  Widget _buildContentInput() {
    return TextField(
      controller: _contentController,
      focusNode: _focusNode,
      maxLines: null,
      minLines: 8,
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

  Widget _buildBottomToolbar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.pureWhite,
        border: Border(top: BorderSide(color: AppColor.dividerGrey, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              _buildToolbarButton(
                icon: Icons.image_outlined,
                color: AppColor.successGreen,
                onTap: () {
                  // TODO: Pick image
                },
              ),
              _buildToolbarButton(
                icon: Icons.camera_alt_outlined,
                color: AppColor.primaryBlue,
                onTap: () {
                  // TODO: Open camera
                },
              ),
              _buildToolbarButton(
                icon: Icons.emoji_emotions_outlined,
                color: AppColor.warningOrange,
                onTap: () {
                  // TODO: Open emoji picker
                },
              ),
              _buildToolbarButton(
                icon: Icons.location_on_outlined,
                color: AppColor.alertRed,
                onTap: () {
                  // TODO: Add location
                },
              ),
              _buildToolbarButton(
                icon: Icons.person_add_alt_outlined,
                color: AppColor.primaryBlue,
                onTap: () {
                  // TODO: Tag people
                },
              ),
              const Spacer(),
              // Character hint
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _hasContent ? 1.0 : 0.0,
                child: Text(
                  '${_contentController.text.length}',
                  style: AppTextStyle.captionMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: color, size: 24),
      splashRadius: 20,
      padding: const EdgeInsets.all(10),
      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
    );
  }

  void _onPostPressed() {
    // TODO: Dispatch event to BLoC to create post
    Navigator.of(context).pop(_contentController.text.trim());
  }
}
