import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';

class PostVideoPreviewTile extends StatefulWidget {
  const PostVideoPreviewTile({
    super.key,
    required this.file,
    required this.height,
    required this.onRemove,
    this.radius = 10,
  });

  final XFile file;
  final double height;
  final double radius;
  final VoidCallback onRemove;

  @override
  State<PostVideoPreviewTile> createState() => _PostVideoPreviewTileState();
}

class _PostVideoPreviewTileState extends State<PostVideoPreviewTile> {
  late final VideoPlayerController _controller;
  bool _initialized = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.file.path))
      ..initialize().then((_) {
        if (mounted) setState(() => _initialized = true);
      });
    _controller.addListener(_onVideoEvent);
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoEvent);
    _controller.dispose();
    super.dispose();
  }

  void _onVideoEvent() {
    if (!_initialized) return;
    final finished = _controller.value.position >= _controller.value.duration;
    if (finished && !_controller.value.isPlaying && mounted) {
      setState(() => _showControls = true);
      _controller.seekTo(Duration.zero);
    }
  }

  void _togglePlay() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _showControls = true;
      } else {
        _controller.play();
        _showControls = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: SizedBox(
        width: double.infinity,
        height: widget.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildVideoFrame(),
            _buildPlayPauseOverlay(),
            if (!_showControls) _buildTapToRevealControls(),
            if (_initialized) _buildProgressBar(),
            _buildRemoveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoFrame() {
    if (!_initialized) return Container(color: Colors.black87);
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: _controller.value.size.width,
        height: _controller.value.size.height,
        child: VideoPlayer(_controller),
      ),
    );
  }

  Widget _buildPlayPauseOverlay() {
    return GestureDetector(
      onTap: _togglePlay,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: _showControls ? 1.0 : 0.0,
        child: Container(
          color: Colors.black38,
          child: Center(
            child: _initialized
                ? Icon(
                    _controller.value.isPlaying
                        ? Icons.pause_circle_outline
                        : Icons.play_circle_outline,
                    color: Colors.white,
                    size: 52,
                  )
                : const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildTapToRevealControls() {
    return GestureDetector(
      onTap: () => setState(() => _showControls = true),
      child: const ColoredBox(color: Colors.transparent),
    );
  }

  Widget _buildProgressBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: VideoProgressIndicator(
        _controller,
        allowScrubbing: true,
        padding: EdgeInsets.zero,
        colors: const VideoProgressColors(
          playedColor: AppColor.primaryBlue,
          bufferedColor: Colors.white38,
          backgroundColor: Colors.white24,
        ),
      ),
    );
  }

  Widget _buildRemoveButton() {
    return Positioned(
      top: 6,
      right: 6,
      child: GestureDetector(
        onTap: widget.onRemove,
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.close, color: Colors.white, size: 15),
        ),
      ),
    );
  }
}
