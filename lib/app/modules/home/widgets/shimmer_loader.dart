
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AltTinderCardShimmerLoader extends StatelessWidget {
  const AltTinderCardShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Background shimmer (image area)
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: width,
            height: height,
            color: Colors.white,
          ),
        ),
        // Indicator shimmer (dots)
        Positioned(
          bottom: height / 2.8,
          left: width / 2.3,
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade400,
            highlightColor: Colors.grey.shade200,
            child: Row(
              children: List.generate(
                  4,
                  (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.white,
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
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
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
                        color: Colors.white,
                      ),
                      const Spacer(),
                      Container(
                        width: 60,
                        height: 14,
                        color: Colors.white,
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
                              color: Colors.white,
                            )),
                  ),
                  const SizedBox(height: 15),
                  // Bio
                  Container(
                    width: width * 0.7,
                    height: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: width * 0.5,
                    height: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 43,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 43,
                          decoration: BoxDecoration(
                            color: Colors.white,
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