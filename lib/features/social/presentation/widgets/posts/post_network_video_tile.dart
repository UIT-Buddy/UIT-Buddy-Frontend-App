import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';

class PostNetworkVideoTile extends StatefulWidget {
  const PostNetworkVideoTile({super.key, required this.url});

  final String url;

  @override
  State<PostNetworkVideoTile> createState() => _PostNetworkVideoTileState();
}

class _PostNetworkVideoTileState extends State<PostNetworkVideoTile> {
  late final VideoPlayerController _controller;
  bool _initialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() => _initialized = true);
    });
    _controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (!mounted) return;
    final playing = _controller.value.isPlaying;
    if (playing != _isPlaying) setState(() => _isPlaying = playing);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      // Restart from beginning if the video finished
      if (_controller.value.position >= _controller.value.duration) {
        _controller.seekTo(Duration.zero);
      }
      _controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('video_${widget.url}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 0 && _controller.value.isPlaying) {
          _controller.pause();
        }
      },
      child: GestureDetector(
        onTap: _initialized ? _togglePlayPause : null,
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
    if (!_initialized) {
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
        width: _controller.value.size.width,
        height: _controller.value.size.height,
        child: VideoPlayer(_controller),
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
