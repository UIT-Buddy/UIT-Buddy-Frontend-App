import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/profile_entity.dart';

class ProfileCoverHeaderWidget extends StatelessWidget {
  const ProfileCoverHeaderWidget({
    super.key,
    required this.profileInfo,
    this.onNotificationTap,
    this.onSettingsTap,
  });

  final ProfileEntity profileInfo;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSettingsTap;

  static const double _coverHeight = 150.0;
  static const double _avatarRadius = 48.0;
  static const double _avatarOverlap = _avatarRadius;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final avatarImage = _resolveAvatarImage(profileInfo.avatarUrl);

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Cover image
            GestureDetector(
              onTap: () {
                if (_isNetworkOrValidUrl(profileInfo.coverUrl)) {
                  Navigator.of(context).push(
                    PageRouteBuilder<void>(
                      opaque: false,
                      barrierColor: Colors.black,
                      transitionDuration: const Duration(milliseconds: 220),
                      reverseTransitionDuration: const Duration(
                        milliseconds: 200,
                      ),
                      pageBuilder: (_, _, _) => _FullscreenImageViewer(
                        imageUrl: profileInfo.coverUrl,
                      ),
                      transitionsBuilder: (_, animation, _, child) =>
                          FadeTransition(opacity: animation, child: child),
                    ),
                  );
                }
              },
              child: SizedBox(
                height: _coverHeight + topPadding,
                width: double.infinity,
                child: Image.asset(
                  profileInfo.coverUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Image.asset(
                    'assets/images/placeholder/bg-placeholder-transparent.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Top bar icons
            Positioned(
              top: topPadding + 8,
              left: 12,
              child: _CircleIconButton(
                icon: Icons.notifications_outlined,
                onTap: onNotificationTap,
              ),
            ),
            Positioned(
              top: topPadding + 8,
              right: 12,
              child: _CircleIconButton(
                icon: Icons.settings_outlined,
                onTap: onSettingsTap,
              ),
            ),

            // Avatar overlapping the cover bottom
            Positioned(
              bottom: -_avatarOverlap,
              left: 0,
              right: 0,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Decorative border and shadow (non-interactive)
                    IgnorePointer(
                      child: Container(
                        width: _avatarRadius * 2 + 6,
                        height: _avatarRadius * 2 + 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColor.pureWhite,
                            width: 3,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColor.shadowColor,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Tappable avatar
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (_isNetworkOrValidUrl(profileInfo.avatarUrl)) {
                          Navigator.of(context).push(
                            PageRouteBuilder<void>(
                              opaque: false,
                              barrierColor: Colors.black,
                              transitionDuration: const Duration(
                                milliseconds: 220,
                              ),
                              reverseTransitionDuration: const Duration(
                                milliseconds: 200,
                              ),
                              pageBuilder: (_, _, _) => _FullscreenImageViewer(
                                imageUrl: profileInfo.avatarUrl,
                              ),
                              transitionsBuilder: (_, animation, _, child) =>
                                  FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                            ),
                          );
                        }
                      },
                      child: CircleAvatar(
                        radius: _avatarRadius,
                        backgroundImage: avatarImage,
                        onBackgroundImageError: (_, _) {},
                        child: avatarImage != null
                            ? null
                            : Image.asset(
                                'assets/images/placeholder/user-icon.png',
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Spacer for avatar overlap
        const SizedBox(height: _avatarOverlap + 8),

        // Name
        Text(
          profileInfo.fullName,
          style: AppTextStyle.h3.copyWith(fontWeight: AppTextStyle.bold),
        ),
        const SizedBox(height: 2),

        // MSSV
        Text('MSSV: ${profileInfo.mssv}', style: AppTextStyle.captionMedium),
        const SizedBox(height: 4),

        // Bio
        Text(
          profileInfo.bio,
          textAlign: TextAlign.center,
          style: AppTextStyle.bodySmall.copyWith(
            color: AppColor.secondaryText,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  bool _isNetworkOrValidUrl(String path) {
    if (path.isEmpty) return false;
    return path.startsWith('http://') ||
        path.startsWith('https://') ||
        path.startsWith('data:image');
  }

  ImageProvider? _resolveAvatarImage(String path) {
    if (path.isEmpty) return null;

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    }

    if (path.startsWith('data:image')) {
      final parts = path.split(',');
      if (parts.length != 2) return null;
      try {
        return MemoryImage(base64Decode(parts[1]));
      } catch (_) {
        return null;
      }
    }

    return AssetImage(path);
  }
}

class _FullscreenImageViewer extends StatelessWidget {
  const _FullscreenImageViewer({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Image with pinch-to-zoom
          InteractiveViewer(
            minScale: 0.5,
            maxScale: 5.0,
            child: Center(child: _buildImage()),
          ),
          // Close button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: IconButton(
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.contain,
        placeholder: (_, _) => const Center(
          child: CircularProgressIndicator(
            color: Colors.white60,
            strokeWidth: 2,
          ),
        ),
        errorWidget: (_, _, _) => const Center(
          child: Icon(
            Icons.broken_image_outlined,
            color: Colors.white38,
            size: 64,
          ),
        ),
      );
    }

    if (imageUrl.startsWith('data:image')) {
      final parts = imageUrl.split(',');
      if (parts.length == 2) {
        try {
          final imageBytes = base64Decode(parts[1]);
          return Image.memory(imageBytes, fit: BoxFit.contain);
        } catch (_) {
          return const Center(
            child: Icon(
              Icons.broken_image_outlined,
              color: Colors.white38,
              size: 64,
            ),
          );
        }
      }
    }

    // Fallback for asset
    return Image.asset(
      imageUrl,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => const Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: Colors.white38,
          size: 64,
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.25),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColor.pureWhite, size: 20),
      ),
    );
  }
}
