import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';

/// Animated cycling dots widget for "Calling..." / "Connecting..." text.
///
/// Cycles through 0→1→2→3 dots with a fixed step interval.
class AnimatedDots extends StatefulWidget {
  const AnimatedDots({
    super.key,
    required this.text,
    this.style,
    this.dotCount = 3,
    this.stepMs = 400,
  });

  /// The base text, e.g. "Calling John" — dots are appended after this.
  final String text;

  /// Style for the entire text. Defaults to [AppTextStyle.bodyMedium].
  final TextStyle? style;

  /// Number of dots to cycle through (0..dotCount).
  final int dotCount;

  /// Milliseconds between each dot step.
  final int stepMs;

  @override
  State<AnimatedDots> createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<AnimatedDots> {
  late int _dotIndex;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _dotIndex = 0;
    _timer = Timer.periodic(Duration(milliseconds: widget.stepMs), (_) {
      if (!mounted) return;
      setState(() => _dotIndex = (_dotIndex + 1) % (widget.dotCount + 1));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _dots => '.' * _dotIndex;

  @override
  Widget build(BuildContext context) {
    final style =
        widget.style ?? AppTextStyle.bodyMedium.copyWith(color: Colors.white);
    return Text('${widget.text}$_dots', style: style);
  }
}
