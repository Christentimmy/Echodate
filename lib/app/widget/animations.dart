import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AnimatedWrapper extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double verticalOffset;
  final double horizontalOffset;

  const AnimatedWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.verticalOffset = 50.0,
    this.horizontalOffset = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.synchronized(
      child: SlideAnimation(
        duration: duration,
        verticalOffset: verticalOffset,
        horizontalOffset: horizontalOffset,
        child: FadeInAnimation(child: child),
      ),
    );
  }
}

class AnimatedListWrapper extends StatelessWidget {
  final List<Widget> children;
  final Duration duration;
  final double verticalOffset;
  final double horizontalOffset;
  final CrossAxisAlignment? crossAxisAlignment;

  const AnimatedListWrapper({
    super.key,
    required this.children,
    this.duration = const Duration(milliseconds: 500),
    this.verticalOffset = 50.0,
    this.horizontalOffset = 0.0,
    this.crossAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: Column(
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
        children: List.generate(children.length, (index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: duration,
            child: SlideAnimation(
              verticalOffset: verticalOffset,
              horizontalOffset: horizontalOffset,
              child: FadeInAnimation(child: children[index]),
            ),
          );
        }),
      ),
    );
  }
}
