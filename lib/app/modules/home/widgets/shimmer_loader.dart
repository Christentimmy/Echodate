import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';

class AltTinderCardShimmerLoader extends StatelessWidget {
  const AltTinderCardShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isDark = Get.isDarkMode;

    // Define shimmer and background colors based on theme
    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.grey.shade700 : Colors.grey.shade100;
    final bgColor = isDark ? Colors.grey.shade900 : Colors.white;

    return Stack(
      children: [
        // Background shimmer (image area)
        Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            width: width,
            height: height,
            color: bgColor,
          ),
        ),
        // Indicator shimmer (dots)
        Positioned(
          bottom: height / 2.8,
          left: width / 2.3,
          child: Shimmer.fromColors(
            baseColor: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
            highlightColor:
                isDark ? Colors.grey.shade600 : Colors.grey.shade200,
            child: Row(
              children: List.generate(
                  4,
                  (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      )),
            ),
          ),
        ),
        // Content shimmer (bottom area)
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and location
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 18,
                        color: bgColor,
                      ),
                      const Spacer(),
                      Container(
                        width: 60,
                        height: 14,
                        color: bgColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // Hobbies/interests
                  Row(
                    children: List.generate(
                        3,
                        (index) => Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 50,
                              height: 20,
                              color: bgColor,
                            )),
                  ),
                  const SizedBox(height: 15),
                  // Bio
                  Container(
                    width: width * 0.7,
                    height: 16,
                    color: bgColor,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: width * 0.5,
                    height: 16,
                    color: bgColor,
                  ),
                  const SizedBox(height: 20),
                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 43,
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 43,
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class EnhancedAltTinderCardShimmerLoader extends StatelessWidget {
  const EnhancedAltTinderCardShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isDark = Get.isDarkMode;

    // Enhanced color scheme for better visual appeal
    final baseColor = isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade300;
    final highlightColor =
        isDark ? const Color(0xFF3D3D3D) : Colors.grey.shade100;
    final shimmerColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    // Gradient overlay for more realistic shimmer
    final gradientColors = isDark
        ? [
            const Color(0xFF1E1E1E).withOpacity(0.3),
            const Color(0xFF2D2D2D).withOpacity(0.1),
            const Color(0xFF1E1E1E).withOpacity(0.3),
          ]
        : [
            Colors.white.withOpacity(0.3),
            Colors.grey.shade50.withOpacity(0.1),
            Colors.white.withOpacity(0.3),
          ];

    return Stack(
      children: [
        // Background shimmer with gradient overlay
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
          ),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              width: width,
              height: height,
              color: shimmerColor,
            ),
          ),
        ),

        // Indicator shimmer with enhanced styling
        Positioned(
          bottom: height / 2.8,
          left: width / 2.3,
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Row(
              children: List.generate(
                4,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: isDark
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Content shimmer with enhanced styling
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  (isDark ? Colors.black : Colors.white).withOpacity(0.8),
                  (isDark ? Colors.black : Colors.white).withOpacity(0.9),
                ],
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and location with enhanced styling
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 18,
                        decoration: BoxDecoration(
                          color: shimmerColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 60,
                        height: 14,
                        decoration: BoxDecoration(
                          color: shimmerColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Hobbies/interests with pill-shaped design
                  Row(
                    children: List.generate(
                      3,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 50 + (index * 10), // Varying widths for realism
                        height: 22,
                        decoration: BoxDecoration(
                          color: shimmerColor,
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Bio lines with varying widths
                  Container(
                    width: width * 0.7,
                    height: 16,
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: width * 0.5,
                    height: 16,
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action buttons with enhanced styling
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 43,
                          decoration: BoxDecoration(
                            color: shimmerColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 43,
                          decoration: BoxDecoration(
                            color: shimmerColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
