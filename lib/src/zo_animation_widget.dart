import 'dart:ui';

import 'package:flutter/material.dart';

class ZoCollectAnimation extends StatefulWidget {
  final Offset start;
  final Offset end;
  final VoidCallback onCompleted;
  final Widget child;

  const ZoCollectAnimation({
    super.key,
    required this.start,
    required this.end,
    required this.onCompleted,
    required this.child,
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
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
      ..addStatusListener((status) {
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

class CoinEmitter {
  static void emit({
    required BuildContext context,
    required Offset start,
    required Offset end,
    required VoidCallback onAnimationFinised,
    required Widget collectionWidget,

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
