import 'package:flutter/material.dart';

/// Expanding concentric ring animation painter.
///
/// Used by both the incoming call overlay (white rings) and
/// the calling overlay (primaryBlue rings).
class RingingPainter extends CustomPainter {
  /// [ringCount] rings are staggered [stagger]ms apart.
  /// Each ring expands from [startRadius] to [startRadius] + [maxRadiusExtension]
  /// over [durationMs]ms while fading from [maxOpacity] to 0.
  RingingPainter({
    required this.animation,
    required this.color,
    this.ringCount = 3,
    this.startRadius = 48.0,
    this.maxRadiusExtension = 60.0,
    this.maxOpacity = 0.5,
    this.strokeWidth = 2.0,
    this.durationMs = 1600,
    this.staggerMs = 400,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color color;
  final int ringCount;
  final double startRadius;
  final double maxRadiusExtension;
  final double maxOpacity;
  final double strokeWidth;
  final int durationMs;
  final int staggerMs;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final totalDuration = durationMs + staggerMs * (ringCount - 1);

    for (int i = 0; i < ringCount; i++) {
      // Stagger offset in "animation progress" units
      final staggerOffset = (i * staggerMs) / totalDuration;
      var progress =
          (animation.value - staggerOffset) /
          (1 - staggerOffset * ringCount / totalDuration);
      progress = progress.clamp(0.0, 1.0);

      final ringRadius = startRadius + (maxRadiusExtension * progress);
      final opacity = maxOpacity * (1 - progress);

      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      canvas.drawCircle(center, ringRadius, paint);
    }
  }

  @override
  bool shouldRepaint(RingingPainter oldDelegate) =>
      oldDelegate.animation != animation ||
      oldDelegate.color != color ||
      oldDelegate.ringCount != ringCount;
}

/// Wraps a [child] (typically a CircleAvatar) with animated expanding rings.
class RingingAvatar extends StatefulWidget {
  const RingingAvatar({
    super.key,
    required this.child,
    required this.color,
    this.ringCount = 3,
    this.startRadius = 48.0,
    this.maxRadiusExtension = 60.0,
    this.maxOpacity = 0.5,
    this.strokeWidth = 2.0,
    this.durationMs = 1600,
    this.staggerMs = 400,
    this.size = 140.0,
  });

  final Widget child;
  final Color color;
  final int ringCount;
  final double startRadius;
  final double maxRadiusExtension;
  final double maxOpacity;
  final double strokeWidth;
  final int durationMs;
  final int staggerMs;
  final double size;

  @override
  State<RingingAvatar> createState() => _RingingAvatarState();
}

class _RingingAvatarState extends State<RingingAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.durationMs),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CustomPaint(
        painter: RingingPainter(
          animation: _controller,
          color: widget.color,
          ringCount: widget.ringCount,
          startRadius: widget.startRadius,
          maxRadiusExtension: widget.maxRadiusExtension,
          maxOpacity: widget.maxOpacity,
          strokeWidth: widget.strokeWidth,
          durationMs: widget.durationMs,
          staggerMs: widget.staggerMs,
        ),
        child: Center(child: widget.child),
      ),
    );
  }
}
