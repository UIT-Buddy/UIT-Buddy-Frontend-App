import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/session/presentation/bloc/session_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/new_feed/new_feed_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/new_feed/new_feed_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/new_feed/new_feed_state.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/social_text.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/posts/post_author_header.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/posts/post_bottom_toolbar.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/posts/post_content_input.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/posts/post_file_chips.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/posts/post_media_grid.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _focusNode = FocusNode();
  final _imagePicker = ImagePicker();

  bool _hasTitle = false;
  final List<XFile> _mediaFiles = [];
  final List<PlatformFile> _attachedFiles = [];

  bool get _canPost => _hasTitle;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() {
      final hasText = _titleController.text.trim().isNotEmpty;
      if (hasText != _hasTitle) setState(() => _hasTitle = hasText);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  List<XFile> get _images => _mediaFiles
      .where((f) => !(f.mimeType?.startsWith('video/') ?? false))
      .toList();

  List<XFile> get _videos => _mediaFiles
      .where((f) => f.mimeType?.startsWith('video/') ?? false)
      .toList();

  // ─── Media picking ─────────────────────────────────────────────────────────

  Future<void> _pickFromGallery() async {
    final files = await _imagePicker.pickMultipleMedia();
    if (files.isEmpty) return;
    setState(() => _mediaFiles.addAll(files));
  }

  Future<void> _pickFromCamera() async {
    final choice = await _showCameraSheet();
    if (choice == null || !mounted) return;

    final XFile? file = choice == 'photo'
        ? await _imagePicker.pickImage(
            source: ImageSource.camera,
            imageQuality: 85,
          )
        : await _imagePicker.pickVideo(source: ImageSource.camera);

    if (file != null) setState(() => _mediaFiles.add(file));
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );
    if (result == null || result.files.isEmpty) return;
    setState(() => _attachedFiles.addAll(result.files));
  }

  Future<String?> _showCameraSheet() {
    return showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: AppColor.dividerGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColor.primaryBlue,
                child: Icon(
                  Icons.photo_camera_outlined,
                  color: AppColor.pureWhite,
                  size: 20,
                ),
              ),
              title: const Text('Chụp ảnh'),
              onTap: () => Navigator.pop(ctx, 'photo'),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColor.alertRed,
                child: Icon(
                  Icons.videocam_outlined,
                  color: AppColor.pureWhite,
                  size: 20,
                ),
              ),
              title: const Text('Quay video'),
              onTap: () => Navigator.pop(ctx, 'video'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ─── Submit ────────────────────────────────────────────────────────────────

  void _onPostPressed() {
    if (!_canPost) return;
    context.read<NewFeedBloc>().add(
      NewFeedPostSubmitted(
        title: _titleController.text.trim(),
        content: _contentController.text.trim().isEmpty
            ? null
            : _contentController.text.trim(),
        images: _images,
        videos: _videos,
      ),
    );
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocListener<NewFeedBloc, NewFeedState>(
      listenWhen: (prev, curr) =>
          prev.isSubmittingPost && !curr.isSubmittingPost,
      listener: (context, state) {
        if (state.submitPostError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.submitPostError!),
              backgroundColor: AppColor.alertRed,
            ),
          );
        } else {
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<NewFeedBloc, NewFeedState>(
        buildWhen: (prev, curr) =>
            prev.isSubmittingPost != curr.isSubmittingPost,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColor.pureWhite,
            appBar: _buildAppBar(state.isSubmittingPost),
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            _buildAuthorHeader(context),
                            const SizedBox(height: 12),
                            _buildTitleInput(),
                            const Divider(
                              height: 20,
                              color: AppColor.dividerGrey,
                            ),
                            PostContentInput(
                              controller: _contentController,
                              focusNode: _focusNode,
                            ),
                            if (_mediaFiles.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              PostMediaGrid(
                                files: _mediaFiles,
                                onRemove: (i) =>
                                    setState(() => _mediaFiles.removeAt(i)),
                              ),
                            ],
                            if (_attachedFiles.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              PostFileChips(
                                files: _attachedFiles,
                                onRemove: (i) =>
                                    setState(() => _attachedFiles.removeAt(i)),
                              ),
                            ],
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                    PostBottomToolbar(
                      onPickGallery: _pickFromGallery,
                      onPickCamera: _pickFromCamera,
                      onPickFile: _pickFile,
                      charCount: _titleController.text.length,
                      showCharCount: _hasTitle,
                    ),
                  ],
                ),
                if (state.isSubmittingPost)
                  const Positioned.fill(
                    child: ColoredBox(
                      color: Color(0x66FFFFFF),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColor.primaryBlue,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitleInput() {
    return TextField(
      controller: _titleController,
      maxLines: 1,
      maxLength: 255,
      textCapitalization: TextCapitalization.sentences,
      style: AppTextStyle.h3.copyWith(fontWeight: AppTextStyle.bold),
      decoration: InputDecoration(
        hintText: SocialText.createPostHint,
        hintStyle: AppTextStyle.h3.copyWith(
          color: AppColor.tertiaryText,
          fontWeight: AppTextStyle.regular,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: false,
        contentPadding: EdgeInsets.zero,
        counterText: '',
      ),
    );
  }

  Widget _buildAuthorHeader(BuildContext context) {
    final user = context.read<SessionBloc>().state.user;
    return PostAuthorHeader(
      name: user?.fullName ?? '',
      avatarLetter: user?.userLetterAvatar ?? 'U',
      avatarUrl: user?.avatarUrl,
    );
  }

  PreferredSizeWidget _buildAppBar(bool isSubmitting) {
    return AppBar(
      backgroundColor: AppColor.pureWhite,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      leading: IconButton(
        onPressed: isSubmitting ? null : () => Navigator.of(context).pop(),
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
            opacity: (_canPost && !isSubmitting) ? 1.0 : 0.5,
            child: ElevatedButton(
              onPressed: (_canPost && !isSubmitting) ? _onPostPressed : null,
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
              child: isSubmitting
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.pureWhite,
                      ),
                    )
                  : Text(
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
}
