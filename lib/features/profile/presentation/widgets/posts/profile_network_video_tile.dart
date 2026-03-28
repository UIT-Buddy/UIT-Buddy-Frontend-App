import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';

class ProfileNetworkVideoTile extends StatefulWidget {
  final String url;
  final VoidCallback? onTap;

  const ProfileNetworkVideoTile({super.key, required this.url, this.onTap});

  @override
  State<ProfileNetworkVideoTile> createState() =>
      _ProfileNetworkVideoTileState();
}

class _ProfileNetworkVideoTileState extends State<ProfileNetworkVideoTile> {
  late final CachedVideoPlayerPlus _player;
  bool _thumbnailReady = false;

  @override
  void initState() {
    super.initState();
    _player = CachedVideoPlayerPlus.networkUrl(Uri.parse(widget.url));
    _player
        .initialize()
        .then((_) {
          if (!mounted) return;
          _player.controller.seekTo(const Duration(milliseconds: 500));
          setState(() => _thumbnailReady = true);
        })
        .catchError((_) {
          if (mounted) setState(() => _thumbnailReady = true);
        });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_thumbnailReady && _player.controller.value.isInitialized)
            VideoPlayer(_player.controller)
          else
            Container(
              color: AppColor.veryLightGrey,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColor.primaryBlue,
                ),
              ),
            ),
          // Play button overlay
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
            ),
            child: Center(
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.black,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
