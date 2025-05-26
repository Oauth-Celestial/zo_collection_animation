import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

enum ZoCollectAnimationType {
  linear,
  quadraticCurve,
  cubicCurve,
  arc,
  bounce,
  spiral,
  zigzag,
  wave,
  teleportFade,
  wiggleFly,
}

class ZoCollectAnimation extends StatefulWidget {
  final Offset start;
  final Offset end;
  final VoidCallback onCompleted;
  final Widget child;
  final Curve? animationCurve;
  final Duration? animationDuration;
  final ZoCollectAnimationType animationType;

  const ZoCollectAnimation({
    super.key,
    required this.start,
    required this.end,
    required this.onCompleted,
    required this.child,
    this.animationDuration,
    this.animationCurve,
    this.animationType = ZoCollectAnimationType.linear,
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
        final t = _animation.value;
        final position = _getAnimatedPosition(t);

        return Positioned(
          left: position.dx,
          top: position.dy,
          child: Opacity(
            opacity: 1.0 - t,
            child: Transform.scale(
              scale: 1.0 + (0.5 * (1.0 - t)),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }

  Offset _getAnimatedPosition(double t) {
    switch (widget.animationType) {
      case ZoCollectAnimationType.linear:
        return _lerp(widget.start, widget.end, t);
      case ZoCollectAnimationType.quadraticCurve:
        return _quadraticBezier(
          widget.start,
          _controlPoint(widget.start, widget.end, -100),
          widget.end,
          t,
        );
      case ZoCollectAnimationType.cubicCurve:
        return _cubicBezier(
          widget.start,
          _controlPoint(widget.start, widget.end, -150),
          _controlPoint(widget.start, widget.end, 150),
          widget.end,
          t,
        );
      case ZoCollectAnimationType.arc:
        return _arc(widget.start, widget.end, t);
      case ZoCollectAnimationType.bounce:
        return _lerp(widget.start, widget.end, Curves.bounceOut.transform(t));
      case ZoCollectAnimationType.spiral:
        return _spiral(widget.start, widget.end, t);
      case ZoCollectAnimationType.zigzag:
        return _zigzag(widget.start, widget.end, t, waves: 5);
      case ZoCollectAnimationType.wave:
        return _wave(widget.start, widget.end, t, amplitude: 20);
      case ZoCollectAnimationType.teleportFade:
        return t < 0.5 ? widget.start : widget.end;
      case ZoCollectAnimationType.wiggleFly:
        return _wiggle(widget.start, widget.end, t);
    }
  }

  Offset _lerp(Offset a, Offset b, double t) => Offset.lerp(a, b, t)!;

  Offset _controlPoint(Offset a, Offset b, double offsetY) =>
      Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2 + offsetY);

  Offset _quadraticBezier(Offset p0, Offset p1, Offset p2, double t) {
    final x =
        (1 - t) * (1 - t) * p0.dx + 2 * (1 - t) * t * p1.dx + t * t * p2.dx;
    final y =
        (1 - t) * (1 - t) * p0.dy + 2 * (1 - t) * t * p1.dy + t * t * p2.dy;
    return Offset(x, y);
  }

  Offset _cubicBezier(Offset p0, Offset p1, Offset p2, Offset p3, double t) {
    final x =
        pow(1 - t, 3) * p0.dx +
        3 * pow(1 - t, 2) * t * p1.dx +
        3 * (1 - t) * pow(t, 2) * p2.dx +
        pow(t, 3) * p3.dx;
    final y =
        pow(1 - t, 3) * p0.dy +
        3 * pow(1 - t, 2) * t * p1.dy +
        3 * (1 - t) * pow(t, 2) * p2.dy +
        pow(t, 3) * p3.dy;
    return Offset(x.toDouble(), y.toDouble());
  }

  Offset _arc(Offset start, Offset end, double t) {
    final center = Offset((start.dx + end.dx) / 2, min(start.dy, end.dy) - 100);
    final radius = (start - center).distance;
    final angle = pi * t;
    return Offset(
      center.dx + radius * cos(angle),
      center.dy + radius * sin(angle),
    );
  }

  Offset _spiral(Offset start, Offset end, double t) {
    final center = Offset.lerp(start, end, t)!;
    final radius = 50.0 * (1 - t);
    final angle = 4 * pi * t;
    return Offset(
      center.dx + radius * cos(angle),
      center.dy + radius * sin(angle),
    );
  }

  Offset _zigzag(Offset start, Offset end, double t, {int waves = 5}) {
    final base = Offset.lerp(start, end, t)!;
    final dx = sin(t * waves * pi) * 10;
    return base.translate(dx, 0);
  }

  Offset _wave(Offset start, Offset end, double t, {double amplitude = 20}) {
    final base = Offset.lerp(start, end, t)!;
    final dy = sin(t * 2 * pi) * amplitude;
    return base.translate(0, dy);
  }

  Offset _wiggle(Offset start, Offset end, double t) {
    final base = Offset.lerp(start, end, t)!;
    final dx = sin(t * 10 * pi) * 5 * (1 - t);
    return base.translate(dx, 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AnimationEmitter {
  static void emit({
    required BuildContext context,
    required Offset start,
    required Offset end,
    required VoidCallback onAnimationFinished,
    required Widget collectionWidget,
    Duration? animationDuration,
    Curve? animationCurve,
    int count = 1,
    Duration interval = const Duration(milliseconds: 100),
    ZoCollectAnimationType animationType = ZoCollectAnimationType.linear,
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
                  onAnimationFinished();
                  entry.remove();
                },

                animationDuration: animationDuration,
                animationCurve: animationCurve,
                animationType: animationType,
                child: collectionWidget,
              ),
        );

        overlay.insert(entry);
      });
    }
  }
}
