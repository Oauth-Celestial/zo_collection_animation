import 'package:flutter/material.dart';

class ZoDestination extends StatefulWidget {
  final Widget child;
  final void Function() onCoinArrived;

  const ZoDestination({
    super.key,
    required this.child,
    required this.onCoinArrived,
  });

  @override
  State<ZoDestination> createState() => _ZoDestinationState();
}

class _ZoDestinationState extends State<ZoDestination> {
  /// Calculates global position of this widget

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
