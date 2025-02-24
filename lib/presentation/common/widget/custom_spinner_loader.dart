import 'package:flutter/material.dart';

class CustomSpinnerLoader extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const CustomSpinnerLoader({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
  }) : super(key: key);

  @override
  CustomSpinnerLoaderState createState() => CustomSpinnerLoaderState();
}

class CustomSpinnerLoaderState extends State<CustomSpinnerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Widget _child;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
    _child = widget.child;

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: _child,
    );
  }
}
