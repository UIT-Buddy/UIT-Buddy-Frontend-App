import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:uit_buddy_mobile/app/router/extensions/router_extension.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/home/presentation/constants/home_text.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  String _previewText = '';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: HomeText.noteDefaultTitle);
    _bodyController = TextEditingController();
    _bodyController.addListener(() {
      setState(() => _previewText = _bodyController.text);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _onSave() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Note "${_titleController.text}" saved',
          style: AppTextStyle.bodySmall.copyWith(color: AppColor.pureWhite),
        ),
        backgroundColor: AppColor.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pureWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _NoteHeader(titleController: _titleController, onSave: _onSave),
            const Divider(height: 1, color: AppColor.dividerGrey),
            _EditSection(controller: _bodyController),
            const Divider(height: 1, color: AppColor.dividerGrey),
            _PreviewSection(markdown: _previewText),
          ],
        ),
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _NoteHeader extends StatelessWidget {
  const _NoteHeader({required this.titleController, required this.onSave});

  final TextEditingController titleController;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.goBack(RouteName.home),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColor.primaryText,
              size: 20,
            ),
            style: IconButton.styleFrom(
              backgroundColor: AppColor.veryLightGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: titleController,
              style: AppTextStyle.h2.copyWith(fontWeight: FontWeight.w700),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: Colors.transparent,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 10),
          FilledButton(
            onPressed: onSave,
            style: FilledButton.styleFrom(
              backgroundColor: AppColor.primaryBlue,
              foregroundColor: AppColor.pureWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              textStyle: AppTextStyle.buttonPrimary,
            ),
            child: const Text(HomeText.noteSaveButton),
          ),
        ],
      ),
    );
  }
}

// ─── Edit Section ─────────────────────────────────────────────────────────────

class _EditSection extends StatelessWidget {
  const _EditSection({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(HomeText.noteEditLabel),
        SizedBox(
          height: 180,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: controller,
              maxLines: null,
              expands: true,
              keyboardType: TextInputType.multiline,
              style: AppTextStyle.bodySmall.copyWith(
                fontFamily: 'monospace',
                color: AppColor.primaryText,
                height: 1.6,
              ),
              decoration: InputDecoration(
                hintText: HomeText.noteEditHint,
                hintStyle: AppTextStyle.bodySmall.copyWith(
                  color: AppColor.tertiaryText,
                  height: 1.6,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Preview Section ──────────────────────────────────────────────────────────

class _PreviewSection extends StatelessWidget {
  const _PreviewSection({required this.markdown});

  final String markdown;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(HomeText.notePreviewLabel),
          Expanded(
            child: Markdown(
              data: markdown,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                  .copyWith(
                    p: AppTextStyle.bodySmall,
                    h1: AppTextStyle.h1,
                    h2: AppTextStyle.h2,
                    h3: AppTextStyle.h3,
                    code: AppTextStyle.bodySmall.copyWith(
                      fontFamily: 'monospace',
                      backgroundColor: AppColor.veryLightGrey,
                      color: AppColor.primaryBlue,
                    ),
                    codeblockDecoration: BoxDecoration(
                      color: AppColor.veryLightGrey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    blockquoteDecoration: BoxDecoration(
                      color: AppColor.primaryBlue10,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared ───────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColor.veryLightGrey,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Text(
        label,
        style: AppTextStyle.captionSmall.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColor.secondaryText,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
