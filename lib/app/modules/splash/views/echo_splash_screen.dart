import 'package:echodate/app/modules/splash/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:get/get.dart';

class EchodateSplashScreen extends StatelessWidget {
  EchodateSplashScreen({super.key});

  final _splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFF6B35), // Orange primary
              Color(0xFFFF8E53), // Lighter orange
              Color(0xFFFFB380), // Even lighter orange
              Color(0xFFFFA726), // Amber orange
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated particles background
            ...List.generate(20, (index) => _buildParticle(index)),

            // Main content
            Center(
              child: SizedBox(
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Letters appearing one by one
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_splashController.appName.length,
                          (index) {
                        return AnimatedBuilder(
                          animation: _splashController.letterControllers[index],
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                  0,
                                  30 *
                                      (1 -
                                          _splashController
                                              .letterAnimations[index].value)),
                              child: Transform.scale(
                                scale: _splashController
                                    .letterAnimations[index].value,
                                child: Opacity(
                                  opacity: _splashController
                                      .letterFadeAnimations[index].value,
                                  child: _buildBrickLetter(
                                      _splashController.appName[index], index),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                    // Heart icon that bounces on the last letter
                    if (_splashController.appName.isNotEmpty)
                      AnimatedBuilder(
                        animation: _splashController.loveIconController,
                        builder: (context, child) {
                          // Find the position of the last letter
                          const letterWidth = 39.0;
                          final totalWidth =
                              letterWidth * _splashController.appName.length;
                          return Positioned(
                            left: (totalWidth / 2) +
                                (letterWidth *
                                    (_splashController.appName.length / 2 -
                                        0.5)),
                            bottom: 27,
                            child: Transform.translate(
                              offset: Offset(
                                  0,
                                  _splashController
                                          .loveIconBounceAnimation.value -
                                      24),
                              child: Transform.scale(
                                scale: _splashController
                                    .loveIconScaleAnimation.value,
                                child: const Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),

            // Floating hearts
            ...List.generate(8, (index) => _buildFloatingHeart(index)),
          ],
        ),
      ),
    );
  }

  Widget _buildParticle(int index) {
    return AnimatedBuilder(
      animation: _splashController.particleController,
      builder: (context, child) {
        final progress =
            (_splashController.particleController.value + index * 0.1) % 1.0;
        final size = MediaQuery.of(context).size;

        return Positioned(
          left: (size.width * 0.1) + (index * size.width * 0.08) % size.width,
          top: size.height * progress,
          child: Opacity(
            opacity: (1 - progress) * 0.6,
            child: Container(
              width: 4 + (index % 3) * 2,
              height: 4 + (index % 3) * 2,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingHeart(int index) {
    return AnimatedBuilder(
      animation: _splashController.heartController,
      builder: (context, child) {
        final progress =
            (_splashController.heartController.value + index * 0.15) % 1.0;
        final size = MediaQuery.of(context).size;
        final heartSize = 15.0 + (index % 3) * 5;

        return Positioned(
          left: (size.width * 0.1) + (index * size.width * 0.1) % size.width,
          top: size.height - (size.height * progress),
          child: Transform.rotate(
            angle: progress * 2 * math.pi,
            child: Opacity(
              opacity: (math.sin(progress * math.pi) * 0.7).clamp(0.0, 1.0),
              child: Icon(
                Icons.favorite,
                color: Colors.white.withOpacity(0.6),
                size: heartSize,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBrickLetter(String letter, int index) {
    return AnimatedBuilder(
      animation: _splashController.letterControllers[index],
      builder: (context, child) {
        final progress = _splashController.letterAnimations[index].value;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Brick pieces effect - multiple fragments coming together
            if (progress < 1.0) ...[
              // Top left piece
              Transform.translate(
                offset: Offset(
                  -20 * (1 - progress) - 5,
                  -15 * (1 - progress) - 5,
                ),
                child: Transform.rotate(
                  angle: -0.5 * (1 - progress),
                  child: Opacity(
                    opacity: progress,
                    child: ClipRect(
                      child: Align(
                        alignment: Alignment.topLeft,
                        widthFactor: 0.5,
                        heightFactor: 0.5,
                        child: Text(
                          letter,
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Top right piece
              Transform.translate(
                offset: Offset(
                  25 * (1 - progress) + 5,
                  -20 * (1 - progress) - 5,
                ),
                child: Transform.rotate(
                  angle: 0.3 * (1 - progress),
                  child: Opacity(
                    opacity: progress,
                    child: ClipRect(
                      child: Align(
                        alignment: Alignment.topRight,
                        widthFactor: 0.5,
                        heightFactor: 0.5,
                        child: Text(
                          letter,
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom left piece
              Transform.translate(
                offset: Offset(
                  -25 * (1 - progress) - 3,
                  20 * (1 - progress) + 3,
                ),
                child: Transform.rotate(
                  angle: 0.4 * (1 - progress),
                  child: Opacity(
                    opacity: progress,
                    child: ClipRect(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        widthFactor: 0.5,
                        heightFactor: 0.5,
                        child: Text(
                          letter,
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom right piece
              Transform.translate(
                offset: Offset(
                  20 * (1 - progress) + 3,
                  25 * (1 - progress) + 5,
                ),
                child: Transform.rotate(
                  angle: -0.3 * (1 - progress),
                  child: Opacity(
                    opacity: progress,
                    child: ClipRect(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        widthFactor: 0.5,
                        heightFactor: 0.5,
                        child: Text(
                          letter,
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],

            // Complete letter when animation is done
            if (progress >= 0.7)
              Opacity(
                opacity: ((progress - 0.7) / 0.3).clamp(0.0, 1.0),
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.white, Color(0xFFFFF3E0)],
                  ).createShader(bounds),
                  child: Text(
                    letter,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
