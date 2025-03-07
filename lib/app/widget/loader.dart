import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: LoadingIndicator(
        indicatorType: Indicator.lineScale,
        colors: [Colors.white],
        strokeWidth: 1,
      ),
    );
  }
}
