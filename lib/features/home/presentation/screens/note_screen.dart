import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:uit_buddy_mobile/app/router/extensions/router_extension.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/home/presentation/bloc/note/note_bloc.dart';
import 'package:uit_buddy_mobile/features/home/presentation/bloc/note/note_event.dart';
import 'package:uit_buddy_mobile/features/home/presentation/bloc/note/note_state.dart';
import 'package:uit_buddy_mobile/features/home/presentation/constants/home_text.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/screens/storage_screen.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  String _previewText = '';
  String _originalContent = '';
  bool _isPopping = false;
  bool _pendingSaveToDoc = false;

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

  bool get _hasUnsavedChanges => _bodyController.text != _originalContent;

  void _onSave() {
    FocusScope.of(context).unfocus();

    if (_bodyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot save an empty note.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    context.read<NoteBloc>().add(
      SaveNoteRequested(content: _bodyController.text),
    );
  }

  Future<void> _openStorageModalForDoc() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => const ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        child: StorageScreen(isSaveNoteMode: true),
      ),
    );

    if (result != null && mounted) {
      context.read<NoteBloc>().add(
        SaveNoteToDocumentRequested(
          fileName: result['fileName'] as String,
          folderId: result['folderId'] as String,
        ),
      );
    }
  }

  void _onSaveToDoc() async {
    FocusScope.of(context).unfocus();

    if (_bodyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot export an empty note.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_hasUnsavedChanges) {
      final shouldSave = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Unsaved Changes'),
          content: const Text(
            'You need to save your changes before exporting to a document. Save now?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryBlue,
                foregroundColor: AppColor.pureWhite,
              ),
              child: const Text('Save & Continue'),
            ),
          ],
        ),
      );

      if (shouldSave == true) {
        setState(() => _pendingSaveToDoc = true);
        _onSave();
        return;
      } else {
        return;
      }
    }

    _openStorageModalForDoc();
  }

  void _onClear() {
    FocusScope.of(context).unfocus();
    context.read<NoteBloc>().add(const ClearNoteRequested());
  }

  Future<bool> _handlePop() async {
    if (!_hasUnsavedChanges) return true;

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text('Do you want to save your recent changes?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Discard'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryBlue,
              foregroundColor: AppColor.pureWhite,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (shouldSave == true) {
      setState(() => _isPopping = true);
      _onSave();
      return false; // Prevent pop, let BlocConsumer handle it
    }

    return true; // Proceed with popping without saving
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        final shouldPop = await _handlePop();
        if (shouldPop) navigator.pop();
      },
      child: Scaffold(
        backgroundColor: AppColor.pureWhite,
        body: SafeArea(
          child: BlocConsumer<NoteBloc, NoteState>(
            listener: (context, state) {
              if (state is NoteLoaded) {
                if (_bodyController.text.isEmpty &&
                    state.note.content != null) {
                  _bodyController.text = state.note.content!;
                  _originalContent = state.note.content!;
                }
              } else if (state is NoteSaveSuccess) {
                _originalContent = _bodyController.text;

                if (_isPopping) {
                  context.goBack(RouteName.home);
                  return;
                }

                if (_pendingSaveToDoc) {
                  setState(() => _pendingSaveToDoc = false);
                  _openStorageModalForDoc();
                  // Skip showing the snackbar since the modal is opening
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Note "${_titleController.text}" saved',
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColor.pureWhite,
                      ),
                    ),
                    backgroundColor: AppColor.successGreen,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.all(16),
                    duration: const Duration(seconds: 2),
                  ),
                );
              } else if (state is NoteClearSuccess) {
                _bodyController.clear();
                _originalContent = '';
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Note cleared'),
                    backgroundColor: AppColor.successGreen,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else if (state is NoteSaveToDocumentSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Document saved successfully'),
                    backgroundColor: AppColor.successGreen,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else if (state is NoteError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message,
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColor.pureWhite,
                      ),
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is NoteLoading;
              return Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _NoteHeader(
                        titleController: _titleController,
                        onBack: () async {
                          final shouldPop = await _handlePop();
                          if (shouldPop && context.mounted) {
                            context.goBack(RouteName.home);
                          }
                        },
                        onSave: isLoading ? () {} : _onSaveToDoc,
                        onClear: isLoading ? () {} : _onClear,
                      ),
                      const Divider(height: 1, color: AppColor.dividerGrey),
                      _EditSection(controller: _bodyController),
                      const Divider(height: 1, color: AppColor.dividerGrey),
                      _PreviewSection(markdown: _previewText),
                    ],
                  ),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _NoteHeader extends StatelessWidget {
  const _NoteHeader({
    required this.titleController,
    required this.onBack,
    required this.onSave,
    required this.onClear,
  });

  final TextEditingController titleController;
  final VoidCallback onBack;
  final VoidCallback onSave;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
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
          IconButton(
            onPressed: onClear,
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
            tooltip: 'Clear Note',
          ),
          const SizedBox(width: 4),
          FilledButton.icon(
            onPressed: onSave,
            icon: const Icon(Icons.save_alt_rounded, size: 18),
            style: FilledButton.styleFrom(
              backgroundColor: AppColor.primaryBlue,
              foregroundColor: AppColor.pureWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              textStyle: AppTextStyle.buttonPrimary,
            ),
            label: const Text('Save to Doc'),
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
