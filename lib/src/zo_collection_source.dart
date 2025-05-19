import 'package:flutter/material.dart';
import 'package:zo_collection_animation/src/zo_collection_animation.dart';

/// A widget that acts as the source point for a collection animation,
/// animating items (like coins) from its position to a destination widget.

class ZoCollectionSource extends StatelessWidget {
  /// The child widget displayed by this source .
  final Widget child;

  /// A [GlobalKey] that identifies the target widget where the collection animation ends.
  final GlobalKey destinationKey;

  /// A callback invoked after the animation completes.
  final VoidCallback onAnimationComplete;

  /// The widget used to represent the animated item (e.g., a coin).
  ///
  /// Defaults to an amber monetization icon.
  final Widget collectionWidget;

  /// Optional callback triggered on tap before starting the animation.
  final Function()? onTap;

  /// Optional animation curve to customize the movement trajectory.
  final Curve? animationCurve;

  /// Optional duration for the animation.
  final Duration? animationDuration;

  /// Optional number of items to animate.
  ///
  /// Defaults to 1 if not provided.
  final int? count;

  const ZoCollectionSource({
    super.key,
    required this.child,
    required this.destinationKey,
    required this.onAnimationComplete,
    this.collectionWidget = const Icon(
      Icons.monetization_on,
      size: 30,
      color: Colors.amber,
    ),
    this.onTap,
    this.animationCurve,
    this.animationDuration,
    this.count,
  });

  void startAnimation(BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    final startPosition = box.localToGlobal(Offset.zero);

    final renderBox =
        destinationKey.currentContext!.findRenderObject() as RenderBox;
    final endPosition = renderBox.localToGlobal(Offset.zero);

    AnimationEmitter.emit(
      context: context,
      start: startPosition,
      end: endPosition,
      count: count ?? 1,
      onAnimationFinised: onAnimationComplete,
      collectionWidget: collectionWidget,
      animationCurve: animationCurve,
      animationDuration: animationDuration,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap?.call();
        startAnimation(context);
      },
      child: child,
    );
  }
}
