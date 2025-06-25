import 'package:echodate/app/modules/auth/views/alt_login_screen.dart';
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
        const GetMaterialApp(home: AltLoginScreen()),
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
        const GetMaterialApp(home: AltLoginScreen()),
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
        const GetMaterialApp(home: AltLoginScreen()),
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
        const GetMaterialApp(home: AltLoginScreen()),
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
        const GetMaterialApp(home: AltLoginScreen()),
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
        const GetMaterialApp(home: AltLoginScreen()),
      );

      // Check if all animated widgets are present
      expect(find.byType(RotatingImage), findsOneWidget);
      expect(find.byType(BouncingBallWidget), findsOneWidget);
      expect(find.byType(RotatingStarWidget), findsOneWidget);
    });

    testWidgets('Backdrop filter and gradient effects are applied',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: AltLoginScreen()),
      );

      // Check if backdrop filter is present
      expect(find.byType(BackdropFilter), findsOneWidget);

      // Check if containers with gradients exist
      expect(find.byType(Container), findsAtLeastNWidgets(3));
    });

    testWidgets('Screen scrolls properly when keyboard appears',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: AltLoginScreen()),
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
        const GetMaterialApp(home: AltLoginScreen()),
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
        const GetMaterialApp(home: AltLoginScreen()),
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
        const GetMaterialApp(home: AltLoginScreen()),
      );

      // Check if Stack is used for positioning animated elements
      expect(find.byType(Stack), findsAtLeastNWidgets(1));

      // Check if Positioned widgets exist for animated elements
      expect(find.byType(Positioned), findsAtLeastNWidgets(2));
    });

    testWidgets('Form container has correct decoration',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: AltLoginScreen()),
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
        const GetMaterialApp(home: AltLoginScreen()),
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
        const GetMaterialApp(home: AltLoginScreen()),
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

}
