import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/session/presentation/bloc/session_bloc.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_media_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/edit_post/edit_post_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/edit_post/edit_post_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/edit_post/edit_post_state.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/social_text.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/posts/post_author_header.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/posts/post_content_input.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/posts/post_network_video_tile.dart';

class EditPostScreen extends StatelessWidget {
  const EditPostScreen({super.key, required this.post});

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<EditPostBloc>(),
      child: _EditPostView(post: post),
    );
  }
}

// ─── View ──────────────────────────────────────────────────────────────────────

class _EditPostView extends StatefulWidget {
  const _EditPostView({required this.post});

  final PostEntity post;

  @override
  State<_EditPostView> createState() => _EditPostViewState();
}

class _EditPostViewState extends State<_EditPostView> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final FocusNode _focusNode;

  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post.title);
    _contentController = TextEditingController(
      text: widget.post.contentSnippet,
    );
    _focusNode = FocusNode();

    void onChanged() {
      final changed =
          _titleController.text.trim() != widget.post.title ||
          _contentController.text.trim() != widget.post.contentSnippet;
      if (changed != _hasChanges) setState(() => _hasChanges = changed);
    }

    _titleController.addListener(onChanged);
    _contentController.addListener(onChanged);

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

  bool get _canSave =>
      _titleController.text.trim().isNotEmpty && _hasChanges;

  void _onSavePressed() {
    if (!_canSave) return;
    context.read<EditPostBloc>().add(
      EditPostSubmitted(
        originalPost: widget.post,
        title: _titleController.text.trim(),
        content: _contentController.text.trim().isEmpty
            ? null
            : _contentController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditPostBloc, EditPostState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status &&
          curr.status != EditPostStatus.loading,
      listener: (context, state) {
        if (state.status == EditPostStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ?? SocialText.genericError,
              ),
              backgroundColor: AppColor.alertRed,
            ),
          );
        } else if (state.status == EditPostStatus.success) {
          Navigator.of(context).pop(state.updatedPost);
        }
      },
      child: BlocBuilder<EditPostBloc, EditPostState>(
        buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColor.pureWhite,
            appBar: _buildAppBar(state.isLoading),
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
                            if (widget.post.medias.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              _ReadOnlyMediaGrid(medias: widget.post.medias),
                            ],
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (state.isLoading)
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

  Widget _buildAuthorHeader(BuildContext context) {
    final user = context.read<SessionBloc>().state.user;
    return PostAuthorHeader(
      name: user?.fullName ?? '',
      avatarLetter: user?.userLetterAvatar ?? 'U',
      avatarUrl: user?.avatarUrl,
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
        hintText: SocialText.createPostTitleHint,
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

  PreferredSizeWidget _buildAppBar(bool isLoading) {
    return AppBar(
      backgroundColor: AppColor.pureWhite,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      leading: IconButton(
        onPressed: isLoading ? null : () => Navigator.of(context).pop(),
        icon: const Icon(Icons.close, color: AppColor.primaryText, size: 24),
        splashRadius: 20,
      ),
      title: Text(
        SocialText.editPostTitle,
        style: AppTextStyle.h3.copyWith(fontWeight: AppTextStyle.bold),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: (_canSave && !isLoading) ? 1.0 : 0.5,
            child: ElevatedButton(
              onPressed: (_canSave && !isLoading) ? _onSavePressed : null,
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
              child: isLoading
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.pureWhite,
                      ),
                    )
                  : Text(
                      SocialText.save,
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

// ─── Read-only media grid (same layout as PostCard, no remove button) ──────────

class _ReadOnlyMediaGrid extends StatelessWidget {
  const _ReadOnlyMediaGrid({required this.medias});

  final List<PostMediaEntity> medias;

  @override
  Widget build(BuildContext context) {
    final count = medias.length;

    if (count == 1) {
      return AspectRatio(
        aspectRatio: 16 / 10,
        child: _ReadOnlyMediaTile(media: medias[0]),
      );
    }

    if (count == 2) {
      return SizedBox(
        height: 220,
        child: Row(
          children: [
            Expanded(child: _ReadOnlyMediaTile(media: medias[0])),
            const SizedBox(width: 2),
            Expanded(child: _ReadOnlyMediaTile(media: medias[1])),
          ],
        ),
      );
    }

    if (count == 3) {
      return SizedBox(
        height: 240,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: _ReadOnlyMediaTile(media: medias[0]),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: _ReadOnlyMediaTile(media: medias[1])),
                  const SizedBox(height: 2),
                  Expanded(child: _ReadOnlyMediaTile(media: medias[2])),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // 4+ → 2×2 grid with overflow count on last tile
    final visible = medias.take(4).toList();
    final overflow = count - 4;

    return SizedBox(
      height: 240,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: _ReadOnlyMediaTile(media: visible[0])),
                const SizedBox(width: 2),
                Expanded(child: _ReadOnlyMediaTile(media: visible[1])),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _ReadOnlyMediaTile(media: visible[2])),
                const SizedBox(width: 2),
                Expanded(
                  child: _ReadOnlyMediaTile(
                    media: visible[3],
                    overflowCount: overflow > 0 ? overflow : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadOnlyMediaTile extends StatelessWidget {
  const _ReadOnlyMediaTile({required this.media, this.overflowCount});

  final PostMediaEntity media;
  final int? overflowCount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildMedia(),
        if (overflowCount != null && overflowCount! > 0)
          Container(
            color: Colors.black54,
            child: Center(
              child: Text(
                '+$overflowCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMedia() {
    if (media.type == PostMediaType.video) {
      return PostNetworkVideoTile(url: media.url);
    }

    return CachedNetworkImage(
      imageUrl: media.url,
      fit: BoxFit.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: AppColor.dividerGrey,
        highlightColor: AppColor.veryLightGrey,
        child: Container(color: Colors.white),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColor.veryLightGrey,
        child: const Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: AppColor.secondaryText,
            size: 32,
          ),
        ),
      ),
    );
  }
}
