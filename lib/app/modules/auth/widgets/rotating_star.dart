import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';

class RotatingStarWidget extends StatefulWidget {
  const RotatingStarWidget({super.key});

  @override
  State<RotatingStarWidget> createState() => _RotatingStarWidgetState();
}

class _RotatingStarWidgetState extends State<RotatingStarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: child,
        );
      },
      child: Icon(
        Icons.star,
        size: 25,
        color: AppColors.bgOrange400,
      ),
    );
  }
}
