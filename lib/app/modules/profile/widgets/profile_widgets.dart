import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildStatShimmerPlaceholder() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Row(
      children: [
        Expanded(
          child: _buildShimmerCard(),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildShimmerCard(),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildShimmerCard(),
        ),
      ],
    ),
  );
}

Widget _buildShimmerCard() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 12,
          color: Colors.grey[300],
        ),
        const SizedBox(height: 6),
        Container(
          width: 60,
          height: 12,
          color: Colors.grey[300],
        ),
      ],
    ),
  );
}
