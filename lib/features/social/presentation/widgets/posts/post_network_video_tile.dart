import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';

class PostNetworkVideoTile extends StatefulWidget {
  const PostNetworkVideoTile({super.key, required this.url, this.onTap});

  final String url;

  /// When provided, overrides the default play/pause tap behaviour.
  final VoidCallback? onTap;

  @override
  State<PostNetworkVideoTile> createState() => _PostNetworkVideoTileState();
}

class _PostNetworkVideoTileState extends State<PostNetworkVideoTile> {
  late final CachedVideoPlayerPlus _player;
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = CachedVideoPlayerPlus.networkUrl(Uri.parse(widget.url));
    _player.initialize().then((_) {
      if (!mounted) return;
      _controller = _player.controller;
      _controller!.addListener(_onControllerUpdate);
      setState(() => _initialized = true);
    });
  }

  void _onControllerUpdate() {
    if (!mounted) return;
    final playing = _controller?.value.isPlaying ?? false;
    if (playing != _isPlaying) setState(() => _isPlaying = playing);
  }

  @override
  void dispose() {
    _controller?.removeListener(_onControllerUpdate);
    _player.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    final ctrl = _controller;
    if (ctrl == null) return;
    if (ctrl.value.isPlaying) {
      ctrl.pause();
    } else {
      if (ctrl.value.position >= ctrl.value.duration) {
        ctrl.seekTo(Duration.zero);
      }
      ctrl.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('video_${widget.url}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 0) _controller?.pause();
      },
      child: GestureDetector(
        onTap: widget.onTap ?? (_initialized ? _togglePlayPause : null),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildVideoOrPlaceholder(),
            if (!_isPlaying) _buildPlayButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoOrPlaceholder() {
    final ctrl = _controller;
    if (!_initialized || ctrl == null) {
      return Shimmer.fromColors(
        baseColor: AppColor.dividerGrey,
        highlightColor: AppColor.veryLightGrey,
        child: Container(color: Colors.white),
      );
    }

    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: ctrl.value.size.width,
        height: ctrl.value.size.height,
        child: VideoPlayer(ctrl),
      ),
    );
  }

  Widget _buildPlayButton() {
    return Center(
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.55),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.play_arrow_rounded,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
