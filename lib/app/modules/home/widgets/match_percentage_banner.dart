

import 'package:flutter/material.dart';

class MatchPercentageWidget extends StatelessWidget {
  final int? percentage;

  const MatchPercentageWidget({
    super.key,
    this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    if (percentage == null || percentage == 0) {
      return const SizedBox.shrink();
    }
    
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 5,
        ),
        decoration: const BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Text(
          "$percentage% match",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}