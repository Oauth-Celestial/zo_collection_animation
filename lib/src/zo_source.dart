import 'package:flutter/material.dart';
import 'package:zo_collection_animation/src/zo_animation_widget.dart';

class ZoSource extends StatelessWidget {
  Widget child;
  GlobalKey? destinationKey;
  VoidCallback onAnimationComplete;
  Widget collectionWidget;
  Function()? onTap;
  ZoSource({
    super.key,
    required this.child,
    this.destinationKey,
    required this.onAnimationComplete,
    this.collectionWidget = const Icon(
      Icons.monetization_on,
      size: 30,
      color: Colors.amber,
    ),
    this.onTap,
  });

  void startAnimation(BuildContext context) {
    if (destinationKey == null) {
      print("Destination Key is null ");
      return;
    }
    final box = context.findRenderObject() as RenderBox;
    final startPosition = box.localToGlobal(Offset.zero);

    final renderBox =
        destinationKey!.currentContext!.findRenderObject() as RenderBox;
    final endPosition = renderBox.localToGlobal(Offset.zero);
    CoinEmitter.emit(
      context: context,
      start: startPosition,
      end: endPosition,
      count: 1,
      onAnimationFinised: onAnimationComplete,
      collectionWidget: collectionWidget,
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
