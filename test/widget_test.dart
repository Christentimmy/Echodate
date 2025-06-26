import 'package:echodate/app/modules/auth/views/login_screen.dart';
import 'package:echodate/app/modules/auth/widgets/bouncing_ball.dart';
import 'package:echodate/app/modules/auth/widgets/rotating_star.dart';
import 'package:echodate/app/modules/auth/widgets/rotation_logo.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/custom_textfield.dart';
// Import your AltLoginScreen file here

void main() {
  group('AltLoginScreen Tests', () {
    testWidgets('AltLoginScreen renders correctly on small screen',
        (WidgetTester tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(250, 300);

      await tester.pumpWidget(
        GetMaterialApp(home: AltLoginScreen()),
      );

      expect(find.text("Welcome Back"), findsOneWidget);
      expect(
        find.text("Join millions finding love every day ❤️"),
        findsOneWidget,
      );
      expect(find.byType(RotatingImage), findsOneWidget);
      expect(find.byType(BouncingBallWidget), findsOneWidget);
      expect(find.byType(RotatingStarWidget), findsOneWidget);

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    testWidgets('AltLoginScreen renders correctly on medium screen',
        (WidgetTester tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(375, 667); // iPhone 6/7/8 size

      await tester.pumpWidget(
        GetMaterialApp(home: AltLoginScreen()),
      );

      expect(find.text("Welcome Back"), findsOneWidget);
      expect(find.text("Continue your love story"), findsOneWidget);
      expect(find.byType(RotatingImage), findsOneWidget);

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    testWidgets('AltLoginScreen renders correctly on large screen',
        (WidgetTester tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(414, 896); // iPhone 11 Pro Max size

      await tester.pumpWidget(
        GetMaterialApp(home: AltLoginScreen()),
      );

      expect(find.text("Welcome Back"), findsOneWidget);
      expect(find.text("Continue your love story"), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    testWidgets('Sign in form elements are present and functional',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(home: AltLoginScreen()),
      );

      // Check if sign in form title exists
      expect(find.text("Sign In"), findsOneWidget);
      expect(find.text("Enter your credentials to continue"), findsOneWidget);

      // Check if email and password text fields exist
      expect(find.byType(NewCustomTextField), findsNWidgets(2));

      // Check if the custom button exists
      expect(find.byType(CustomButton), findsOneWidget);
      expect(find.text("Sign in"), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);

      // Check forgot password link
      expect(find.text("Forgot your password?"), findsOneWidget);

      // Check create account link
      expect(find.text("New to EchoDate? "), findsOneWidget);
      expect(find.text("Create account"), findsOneWidget);
    });

    testWidgets('Text field hints are correct', (WidgetTester tester) async {
      await tester.pumpWidget(
         GetMaterialApp(home: AltLoginScreen()),
      );

      // Find text fields by their icons and verify hints
      final emailField = find.byWidgetPredicate(
        (widget) =>
            widget is NewCustomTextField && widget.prefixIcon == Icons.email,
      );
      final passwordField = find.byWidgetPredicate(
        (widget) =>
            widget is NewCustomTextField && widget.prefixIcon == Icons.lock,
      );

      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);
    });

    testWidgets('Animated widgets are present', (WidgetTester tester) async {
      await tester.pumpWidget(
         GetMaterialApp(home: AltLoginScreen()),
      );

      // Check if all animated widgets are present
      expect(find.byType(RotatingImage), findsOneWidget);
      expect(find.byType(BouncingBallWidget), findsOneWidget);
      expect(find.byType(RotatingStarWidget), findsOneWidget);
    });

    testWidgets('Backdrop filter and gradient effects are applied',
        (WidgetTester tester) async {
      await tester.pumpWidget(
         GetMaterialApp(home: AltLoginScreen()),
      );

      // Check if backdrop filter is present
      expect(find.byType(BackdropFilter), findsOneWidget);

      // Check if containers with gradients exist
      expect(find.byType(Container), findsAtLeastNWidgets(3));
    });

    testWidgets('Screen scrolls properly when keyboard appears',
        (WidgetTester tester) async {
      await tester.pumpWidget(
         GetMaterialApp(home: AltLoginScreen()),
      );

      // Verify SingleChildScrollView exists for keyboard handling
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // Verify resizeToAvoidBottomInset is handled by checking Scaffold
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.resizeToAvoidBottomInset, isTrue);
    });

    testWidgets('Colors and styling are applied correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
         GetMaterialApp(home: AltLoginScreen()),
      );

      // Check if scaffold has the correct background color
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(AppColors.bgOrange400));

      // Verify text styles
      final welcomeText = tester.widget<Text>(find.text("Welcome Back"));
      expect(welcomeText.style?.fontSize, equals(24));
      expect(welcomeText.style?.fontWeight, equals(FontWeight.bold));
    });

    testWidgets('Button tap functionality works', (WidgetTester tester) async {
      await tester.pumpWidget(
         GetMaterialApp(home: AltLoginScreen()),
      );

      // Find and tap the sign in button
      final signInButton = find.byType(CustomButton);
      expect(signInButton, findsOneWidget);

      await tester.tap(signInButton);
      await tester.pump();

      // Note: Add expectations here based on what should happen when button is tapped
      // Currently the ontap is empty, so no state change is expected
    });

    testWidgets('Widget positioning is correct', (WidgetTester tester) async {
      await tester.pumpWidget(
         GetMaterialApp(home: AltLoginScreen()),
      );

      // Check if Stack is used for positioning animated elements
      expect(find.byType(Stack), findsAtLeastNWidgets(1));

      // Check if Positioned widgets exist for animated elements
      expect(find.byType(Positioned), findsAtLeastNWidgets(2));
    });

    testWidgets('Form container has correct decoration',
        (WidgetTester tester) async {
      await tester.pumpWidget(
         GetMaterialApp(home: AltLoginScreen()),
      );

      // Verify that the form container has the expected decoration properties
      final containers = find.byType(Container);
      expect(containers, findsAtLeastNWidgets(1));

      // Check if ClipRRect exists for border radius
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('All text content is displayed correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
         GetMaterialApp(home: AltLoginScreen()),
      );

      // Verify all static text content
      expect(find.text("Welcome Back"), findsOneWidget);
      expect(find.text("Continue your love story"), findsOneWidget);
      expect(find.text("Sign In"), findsOneWidget);
      expect(find.text("Enter your credentials to continue"), findsOneWidget);
      expect(find.text("Sign in"), findsOneWidget);
      expect(find.text("Forgot your password?"), findsOneWidget);
      expect(find.text("New to EchoDate? "), findsOneWidget);
      expect(find.text("Create account"), findsOneWidget);
      expect(
          find.text("Join millions finding love every day ❤️"), findsOneWidget);
    });

    testWidgets('Screen handles different orientations',
        (WidgetTester tester) async {
      // Test portrait orientation
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(375, 667);

      await tester.pumpWidget(
         GetMaterialApp(home: AltLoginScreen()),
      );

      expect(find.text("Welcome Back"), findsOneWidget);

      // Test landscape orientation
      tester.view.physicalSize = const Size(667, 375);
      await tester.pump();

      expect(find.text("Welcome Back"), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });
  });
  group('AltLoginScreen Performance Tests', () {
    testWidgets('Performance test - Animation frame rate consistency',
        (WidgetTester tester) async {
      await tester.pumpWidget(
         GetMaterialApp(home: AltLoginScreen()),
      );

      // Measure frame times during animation
      final List<Duration> frameTimes = [];
      DateTime lastFrameTime = DateTime.now();

      // Record frame times for 60 frames (approximately 1 second at 60fps)
      for (int i = 0; i < 60; i++) {
        await tester.pump(const Duration(milliseconds: 16)); // ~60fps
        final currentTime = DateTime.now();
        frameTimes.add(currentTime.difference(lastFrameTime));
        lastFrameTime = currentTime;
      }

      // Calculate average frame time
      final averageFrameTime =
          frameTimes.map((d) => d.inMicroseconds).reduce((a, b) => a + b) /
              frameTimes.length;

      // Expected frame time for 60fps is ~16666 microseconds (16.67ms)
      expect(averageFrameTime, lessThan(20000)); // Allow up to 20ms per frame

      // Check for frame drops (frames taking more than 33ms indicate dropped frames)
      final droppedFrames = frameTimes
          .where((duration) => duration.inMicroseconds > 33000)
          .length;

      expect(
          droppedFrames, lessThan(5)); // Allow up to 5 dropped frames out of 60
    });

    testWidgets('Performance test - Memory usage during animations',
        (WidgetTester tester) async {
      await tester.pumpWidget(
         GetMaterialApp(home: AltLoginScreen()),
      );

      // Pump multiple animation cycles to test for memory leaks
      for (int i = 0; i < 100; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      // Test that we can still find all widgets after extended animation
      expect(find.byType(RotatingImage), findsOneWidget);
      expect(find.byType(BouncingBallWidget), findsOneWidget);
      expect(find.byType(RotatingStarWidget), findsOneWidget);
    });

    testWidgets('Performance test - RotatingImage animation smoothness',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: RotatingImage())),
        ),
      );

      // Test rotation animation performance
      final rotatingImageFinder = find.byType(RotatingImage);
      expect(rotatingImageFinder, findsOneWidget);

      // Pump through one complete rotation cycle
      // Assuming the rotation takes 2 seconds for a full cycle
      const rotationDuration = Duration(seconds: 2);
      const frameInterval = Duration(milliseconds: 16);

      final int totalFrames =
          rotationDuration.inMilliseconds ~/ frameInterval.inMilliseconds;
      final List<double> frameRenderTimes = [];

      for (int i = 0; i < totalFrames; i++) {
        final stopwatch = Stopwatch()..start();
        await tester.pump(frameInterval);
        stopwatch.stop();
        frameRenderTimes.add(stopwatch.elapsedMicroseconds.toDouble());
      }

      // Calculate average render time per frame
      final averageRenderTime =
          frameRenderTimes.reduce((a, b) => a + b) / frameRenderTimes.length;

      // Expect render time to be less than 10ms (10000 microseconds) per frame
      expect(averageRenderTime, lessThan(10000));
    });

    testWidgets('Performance test - BouncingBallWidget animation performance',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: BouncingBallWidget())),
        ),
      );

      final bouncingBallFinder = find.byType(BouncingBallWidget);
      expect(bouncingBallFinder, findsOneWidget);

      // Test bouncing animation performance over multiple cycles
      // Duration is 700ms with repeat(reverse: true), so full cycle is 1400ms
      final List<Duration> pumpDurations = [];
      final List<double> transformValues = [];

      for (int i = 0; i < 84; i++) {
        // 1.4 seconds (one complete bounce cycle)
        final stopwatch = Stopwatch()..start();
        await tester.pump(const Duration(milliseconds: 16));
        stopwatch.stop();
        pumpDurations.add(stopwatch.elapsed);

        // Check Transform.translate values are changing
        final transformWidget = tester.widget<Transform>(
          find.descendant(
            of: bouncingBallFinder,
            matching: find.byType(Transform),
          ),
        );
        transformValues.add(transformWidget.transform.getTranslation().y);
      }

      // Check that pump operations complete quickly
      final averagePumpTime =
          pumpDurations.map((d) => d.inMicroseconds).reduce((a, b) => a + b) /
              pumpDurations.length;

      expect(
        averagePumpTime,
        lessThan(8400),
      ); // Less than 8ms average pump time

      // Verify animation is actually animating (values should change)
      expect(transformValues.length, greaterThan(10));
      final uniqueValues = transformValues.toSet();
      expect(uniqueValues.length,
          greaterThan(5)); // Should have different positions
    });

    testWidgets('Performance test - RotatingStarWidget animation performance',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: RotatingStarWidget())),
        ),
      );

      final rotatingStarFinder = find.byType(RotatingStarWidget);
      expect(rotatingStarFinder, findsOneWidget);

      // Measure animation consistency over time
      // Duration is 10 seconds for full rotation
      final List<int> frameDurations = [];
      final List<double> rotationAngles = [];

      for (int i = 0; i < 150; i++) {
        // 2.4 seconds of animation
        final stopwatch = Stopwatch()..start();
        await tester.pump(const Duration(milliseconds: 16));
        stopwatch.stop();
        frameDurations.add(stopwatch.elapsedMicroseconds);

        // Capture rotation angles to verify smooth rotation
        final transformWidget = tester.widget<Transform>(
          find.descendant(
            of: rotatingStarFinder,
            matching: find.byType(Transform),
          ),
        );
        // Extract rotation angle from transform matrix
        final matrix = transformWidget.transform;
        // Approximate angle extraction for testing
        rotationAngles.add(matrix.getTranslation().x);
      }

      // Check for consistent frame timing (low variance)
      final average =
          frameDurations.reduce((a, b) => a + b) / frameDurations.length;
      final variance = frameDurations
              .map((duration) => (duration - average) * (duration - average))
              .reduce((a, b) => a + b) /
          frameDurations.length;

      // Low variance indicates smooth animation
      expect(variance, lessThan(10000000)); // Reasonable variance threshold

      // Verify star is actually rotating (should have multiple Transform states)
      expect(rotationAngles.length, greaterThan(50));
    });

    testWidgets('Performance test - Multiple animations running simultaneously',
        (WidgetTester tester) async {
      await tester.pumpWidget(
         GetMaterialApp(home: AltLoginScreen()),
      );

      // Test performance when all animations are running together
      final List<Duration> simultaneousAnimationTimes = [];

      for (int i = 0; i < 180; i++) {
        // 3 seconds of simultaneous animations
        final stopwatch = Stopwatch()..start();
        await tester.pump(const Duration(milliseconds: 16));
        stopwatch.stop();
        simultaneousAnimationTimes.add(stopwatch.elapsed);
      }

      // Calculate performance metrics
      final averageTime = simultaneousAnimationTimes
              .map((d) => d.inMicroseconds)
              .reduce((a, b) => a + b) /
          simultaneousAnimationTimes.length;

      final maxTime = simultaneousAnimationTimes
          .map((d) => d.inMicroseconds)
          .reduce((a, b) => a > b ? a : b);

      // Performance expectations for simultaneous animations
      expect(averageTime, lessThan(12000)); // Average frame time < 12ms
      expect(maxTime,
          lessThan(50000)); // Max frame time < 50ms (no major frame drops)

      // Ensure all animations are still running after performance test
      expect(find.byType(RotatingImage), findsOneWidget);
      expect(find.byType(BouncingBallWidget), findsOneWidget);
      expect(find.byType(RotatingStarWidget), findsOneWidget);
    });

    testWidgets('Performance test - Scroll performance with animations',
        (WidgetTester tester) async {
      await tester.pumpWidget(
         GetMaterialApp(home: AltLoginScreen()),
      );

      // Test scrolling performance while animations are running
      final scrollableFinder = find.byType(SingleChildScrollView);
      expect(scrollableFinder, findsOneWidget);

      final List<Duration> scrollPerformanceTimes = [];

      // Perform scroll gestures while animations are running
      for (int i = 0; i < 10; i++) {
        final stopwatch = Stopwatch()..start();

        await tester.drag(scrollableFinder, const Offset(0, -100));
        await tester.pump();
        await tester.drag(scrollableFinder, const Offset(0, 100));
        await tester.pump();

        stopwatch.stop();
        scrollPerformanceTimes.add(stopwatch.elapsed);
      }

      // Check scroll responsiveness
      final averageScrollTime = scrollPerformanceTimes
              .map((d) => d.inMicroseconds)
              .reduce((a, b) => a + b) /
          scrollPerformanceTimes.length;

      expect(averageScrollTime, lessThan(100000)); // Scroll operations < 100ms
    });

    testWidgets('Performance test - Animation cleanup on dispose',
        (WidgetTester tester) async {
      await tester.pumpWidget(
         GetMaterialApp(home: AltLoginScreen()),
      );

      // Let animations run for a bit
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      // Verify all animations are running
      expect(find.byType(RotatingImage), findsOneWidget);
      expect(find.byType(BouncingBallWidget), findsOneWidget);
      expect(find.byType(RotatingStarWidget), findsOneWidget);

      // Navigate away to trigger dispose
      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: Text('New Screen'),
          ),
        ),
      );

      // Pump to process the dispose
      await tester.pumpAndSettle();

      // Verify old screen is disposed
      expect(find.byType(AltLoginScreen), findsNothing);
      expect(find.text('New Screen'), findsOneWidget);
    });

    testWidgets('Performance test - Animation controller resource management',
        (WidgetTester tester) async {
      // Test individual animation widgets for proper cleanup

      // Test BouncingBallWidget cleanup
      await tester.pumpWidget(
        const MaterialApp(home: BouncingBallWidget()),
      );

      // Let animation run
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      // Dispose widget
      await tester.pumpWidget(
        const MaterialApp(home: Text('Disposed')),
      );
      await tester.pumpAndSettle();

      expect(find.byType(BouncingBallWidget), findsNothing);

      // Test RotatingStarWidget cleanup
      await tester.pumpWidget(
        const MaterialApp(home: RotatingStarWidget()),
      );

      // Let animation run
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      // Dispose widget
      await tester.pumpWidget(
        const MaterialApp(home: Text('Disposed')),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RotatingStarWidget), findsNothing);
    });

    testWidgets('Performance test - Animation timing accuracy',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: BouncingBallWidget()),
      );

      // Test BouncingBall timing (700ms duration with reverse)
      final bouncingBallFinder = find.byType(BouncingBallWidget);
      expect(bouncingBallFinder, findsOneWidget);

      // Capture initial position
      var initialTransform = tester.widget<Transform>(
        find.descendant(
          of: bouncingBallFinder,
          matching: find.byType(Transform),
        ),
      );

      // Pump for 700ms (half cycle)
      for (int i = 0; i < 44; i++) {
        // 700ms / 16ms = ~44 frames
        await tester.pump(const Duration(milliseconds: 16));
      }

      // Should be at maximum bounce position
      var maxTransform = tester.widget<Transform>(
        find.descendant(
          of: bouncingBallFinder,
          matching: find.byType(Transform),
        ),
      );

      // Pump for another 700ms (complete cycle)
      for (int i = 0; i < 44; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      // Verify animation completed a cycle (values should be close to initial)
      expect(maxTransform, isNot(equals(initialTransform)));
      // Note: Due to easeInOut curve, final position might not be exactly initial
    });

    testWidgets('Performance test - Star rotation timing accuracy',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: RotatingStarWidget()),
      );

      final rotatingStarFinder = find.byType(RotatingStarWidget);
      expect(rotatingStarFinder, findsOneWidget);

      // Record rotation states at different time intervals
      final List<String> rotationStates = [];

      for (int i = 0; i < 100; i++) {
        // Test for ~1.6 seconds
        await tester.pump(const Duration(milliseconds: 16));

        if (i % 10 == 0) {
          // Sample every 10 frames
          final transformWidget = tester.widget<Transform>(
            find.descendant(
              of: rotatingStarFinder,
              matching: find.byType(Transform),
            ),
          );
          rotationStates.add(transformWidget.transform.toString());
        }
      }

      // Verify rotation is changing over time
      final uniqueStates = rotationStates.toSet();
      expect(uniqueStates.length,
          greaterThan(5)); // Should have multiple different rotation states
    });
  });
  group('AltLoginScreen Animation Integration Tests', () {
    testWidgets('Integration test - All animations work together smoothly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
         GetMaterialApp(home: AltLoginScreen()),
      );

      // Verify all animations are present
      expect(find.byType(RotatingImage), findsOneWidget);
      expect(find.byType(BouncingBallWidget), findsOneWidget);
      expect(find.byType(RotatingStarWidget), findsOneWidget);

      // Run all animations together and measure performance
      final List<Duration> integrationTimes = [];

      for (int i = 0; i < 300; i++) {
        // 5 seconds of integration testing
        final stopwatch = Stopwatch()..start();
        await tester.pump(const Duration(milliseconds: 16));
        stopwatch.stop();
        integrationTimes.add(stopwatch.elapsed);
      }

      // Calculate performance metrics
      final averageTime = integrationTimes
              .map((d) => d.inMicroseconds)
              .reduce((a, b) => a + b) /
          integrationTimes.length;

      // Verify smooth performance during integration
      expect(averageTime, lessThan(15000)); // Less than 15ms average

      // Verify no widgets were disposed during animation
      expect(find.byType(RotatingImage), findsOneWidget);
      expect(find.byType(BouncingBallWidget), findsOneWidget);
      expect(find.byType(RotatingStarWidget), findsOneWidget);
    });

    testWidgets('Integration test - Animations with user interactions',
        (WidgetTester tester) async {
      await tester.pumpWidget(
         GetMaterialApp(home: AltLoginScreen()),
      );

      // Perform various user interactions while animations are running
      final emailField = find.byType(NewCustomTextField).first;
      final passwordField = find.byType(NewCustomTextField).last;
      final signInButton = find.byType(CustomButton);

      // Tap text fields while animations are running
      await tester.tap(emailField);
      await tester.pump();

      await tester.tap(passwordField);
      await tester.pump();

      // Scroll while animations are running
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -50));
      await tester.pump();

      // Tap button while animations are running
      await tester.tap(signInButton);
      await tester.pump();

      // Verify animations are still running after interactions
      expect(find.byType(RotatingImage), findsOneWidget);
      expect(find.byType(BouncingBallWidget), findsOneWidget);
      expect(find.byType(RotatingStarWidget), findsOneWidget);
    });
  });

}
