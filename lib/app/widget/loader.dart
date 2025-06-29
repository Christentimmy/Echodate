import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Loader extends StatelessWidget {
  final Color? color;
  final double? height;
  const Loader({super.key, this.color, this.height});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: height ?? 40,
        child: LoadingIndicator(
          indicatorType: Indicator.lineScale,
          colors: [color ?? Colors.white],
          strokeWidth: 1,
        ),
      ),
    );
  }
}
