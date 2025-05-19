import 'dart:ui';

import 'package:flutter/material.dart';

class ZoCollectAnimation extends StatefulWidget {
  /// The starting position of the animation in global coordinates.
  final Offset start;

  /// The ending position of the animation in global coordinates.
  final Offset end;

  /// A callback invoked when the animation completes.
  final VoidCallback onCompleted;

  /// The widget to animate (e.g., a coin or icon).
  final Widget child;

  /// Optional animation curve to control the easing of the motion.
  final Curve? animationCurve;

  /// Optional duration for the animation.
  ///
  /// Defaults to 600 milliseconds if not specified.
  final Duration? animationDuration;

  const ZoCollectAnimation({
    super.key,
    required this.start,
    required this.end,
    required this.onCompleted,
    required this.child,
    this.animationDuration,
    this.animationCurve,
  });

  @override
  State<ZoCollectAnimation> createState() => _ZoCollectAnimationState();
}

class _ZoCollectAnimationState extends State<ZoCollectAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve ?? Curves.easeInOut,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onCompleted();
      }
    });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        final dx =
            lerpDouble(widget.start.dx, widget.end.dx, _animation.value)!;
        final dy =
            lerpDouble(widget.start.dy, widget.end.dy, _animation.value)!;

        return Positioned(
          left: dx,
          top: dy,
          child: Opacity(
            opacity: 1.0 - _animation.value,
            child: Transform.scale(
              scale: 1.0 + (0.5 * (1.0 - _animation.value)),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AnimationEmitter {
  /// The animation is inserted into the app's [Overlay] so it appears on top of the UI.
  ///
  /// [context] – Required. Used to access the overlay.
  ///
  /// [start] and [end] – Required. Specify the global positions.
  ///
  /// [onAnimationFinised] – Called when each animation completes.
  ///
  /// [collectionWidget] – The widget to animate.
  ///
  /// [animationDuration] – Optional duration for each animation.
  ///
  /// [animationCurve] – Optional animation curve.
  ///
  /// [count] – Number of animations to fire. Defaults to 1.
  ///
  /// [interval] – Delay between consecutive animations if [count] > 1. Defaults to 100ms.
  static void emit({
    required BuildContext context,
    required Offset start,
    required Offset end,
    required VoidCallback onAnimationFinised,
    required Widget collectionWidget,
    Duration? animationDuration,
    Curve? animationCurve,
    int count = 1,
    Duration interval = const Duration(milliseconds: 100),
  }) {
    final overlay = Overlay.of(context);

    for (int i = 0; i < count; i++) {
      Future.delayed(interval * i, () {
        late OverlayEntry entry;

        entry = OverlayEntry(
          builder:
              (context) => ZoCollectAnimation(
                animationCurve: animationCurve,
                animationDuration: animationDuration,
                start: start,
                end: end,
                onCompleted: () {
                  onAnimationFinised();
                  entry.remove();
                },
                child: collectionWidget,
              ),
        );

        overlay.insert(entry);
      });
    }
  }
}
