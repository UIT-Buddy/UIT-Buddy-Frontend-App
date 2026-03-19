import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_media_entity.dart';

class MediaViewerScreen extends StatefulWidget {
  final List<PostMediaEntity> medias;
  final int initialIndex;

  const MediaViewerScreen({
    super.key,
    required this.medias,
    required this.initialIndex,
  });

  static Route<void> route({
    required List<PostMediaEntity> medias,
    required int initialIndex,
  }) {
    return PageRouteBuilder<void>(
      opaque: false,
      barrierColor: Colors.black,
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) =>
          MediaViewerScreen(medias: medias, initialIndex: initialIndex),
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }

  @override
  State<MediaViewerScreen> createState() => _MediaViewerScreenState();
}

class _MediaViewerScreenState extends State<MediaViewerScreen> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    _pageController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.medias.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (context, index) {
              final media = widget.medias[index];
              if (media.type == PostMediaType.video) {
                return _FullscreenVideoPage(
                  key: ValueKey(media.url),
                  url: media.url,
                );
              }
              return _FullscreenImagePage(url: media.url);
            },
          ),
          _TopOverlay(
            currentIndex: _currentIndex,
            total: widget.medias.length,
          ),
        ],
      ),
    );
  }
}

// ─── Top overlay: close button + counter ─────────────────────────────────────

class _TopOverlay extends StatelessWidget {
  final int currentIndex;
  final int total;

  const _TopOverlay({required this.currentIndex, required this.total});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xBB000000), Colors.transparent],
          ),
        ),
        padding: EdgeInsets.only(
          top: topPadding + 6,
          left: 4,
          right: 16,
          bottom: 24,
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 26,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            const Spacer(),
            if (total > 1)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${currentIndex + 1} / $total',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Image page with pinch-to-zoom ───────────────────────────────────────────

class _FullscreenImagePage extends StatelessWidget {
  final String url;

  const _FullscreenImagePage({required this.url});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 5.0,
      child: Center(
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.contain,
          placeholder: (_, __) => const Center(
            child: CircularProgressIndicator(
              color: Colors.white60,
              strokeWidth: 2,
            ),
          ),
          errorWidget: (_, __, ___) => const Center(
            child: Icon(
              Icons.broken_image_outlined,
              color: Colors.white38,
              size: 64,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Fullscreen video page ────────────────────────────────────────────────────

class _FullscreenVideoPage extends StatefulWidget {
  final String url;

  const _FullscreenVideoPage({super.key, required this.url});

  @override
  State<_FullscreenVideoPage> createState() => _FullscreenVideoPageState();
}

class _FullscreenVideoPageState extends State<_FullscreenVideoPage> {
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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _togglePlayPause,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video
          Center(
            child: _initialized && _controller != null
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  )
                : const CircularProgressIndicator(
                    color: Colors.white60,
                    strokeWidth: 2,
                  ),
          ),

          // Play/pause button
          if (_initialized && !_isPlaying)
            Center(
              child: IgnorePointer(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),

          // Progress bar
          if (_initialized && _controller != null)
            Positioned(
              bottom: 48,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VideoProgressIndicator(
                    _controller!,
                    allowScrubbing: true,
                    padding: EdgeInsets.zero,
                    colors: const VideoProgressColors(
                      playedColor: Colors.white,
                      bufferedColor: Colors.white38,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _VideoTimestamp(controller: _controller!),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Video timestamp ──────────────────────────────────────────────────────────

class _VideoTimestamp extends StatefulWidget {
  final VideoPlayerController controller;

  const _VideoTimestamp({required this.controller});

  @override
  State<_VideoTimestamp> createState() => _VideoTimestampState();
}

class _VideoTimestampState extends State<_VideoTimestamp> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTick);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTick);
    super.dispose();
  }

  void _onTick() {
    if (mounted) setState(() {});
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final pos = widget.controller.value.position;
    final dur = widget.controller.value.duration;
    return Text(
      '${_fmt(pos)} / ${_fmt(dur)}',
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
