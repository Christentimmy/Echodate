import 'package:echodate/app/controller/socket_controller.dart';
import 'package:echodate/app/controller/storage_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/Interest/views/pick_hobbies_screen.dart';
import 'package:echodate/app/modules/auth/views/signup_screen.dart';
import 'package:echodate/app/modules/onboarding/views/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _heartController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  late AnimationController _loveIconController;

  AnimationController get mainController => _mainController;
  AnimationController get heartController => _heartController;
  AnimationController get pulseController => _pulseController;
  AnimationController get particleController => _particleController;
  AnimationController get loveIconController => _loveIconController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _loveIconBounceAnimation;
  late Animation<double> _loveIconScaleAnimation;

  Animation<double> get scaleAnimation => _scaleAnimation;
  Animation<double> get fadeAnimation => _fadeAnimation;
  Animation<double> get slideAnimation => _slideAnimation;
  Animation<double> get pulseAnimation => _pulseAnimation;
  Animation<double> get loveIconBounceAnimation => _loveIconBounceAnimation;
  Animation<double> get loveIconScaleAnimation => _loveIconScaleAnimation;

  final List<AnimationController> _letterControllers = [];
  final List<Animation<double>> _letterAnimations = [];
  final List<Animation<double>> _letterFadeAnimations = [];

  List<AnimationController> get letterControllers => _letterControllers;
  List<Animation<double>> get letterAnimations => _letterAnimations;
  List<Animation<double>> get letterFadeAnimations => _letterFadeAnimations;

  final String appName = "ECHODATE";

  @override
  void onInit() {
    super.onInit();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _heartController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    _loveIconController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Initialize letter controllers and animations
    for (int i = 0; i < appName.length; i++) {
      final letterController = AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      );
      _letterControllers.add(letterController);

      // Brick breaking animation - pieces coming together
      final letterAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: letterController,
        curve: Curves.elasticOut,
      ));
      _letterAnimations.add(letterAnimation);

      // Fade animation for each letter
      final letterFadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: letterController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ));
      _letterFadeAnimations.add(letterFadeAnimation);
    }

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
    ));

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeOutBack,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Love icon bounce animation
    _loveIconBounceAnimation = Tween<double>(
      begin: -50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _loveIconController,
      curve: Curves.bounceOut,
    ));

    _loveIconScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loveIconController,
      curve: Curves.elasticOut,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _mainController.forward();
    _heartController.repeat();
    _pulseController.repeat(reverse: true);
    _particleController.repeat();

    // Start letter animations one by one
    await Future.delayed(const Duration(milliseconds: 400));
    for (int i = 0; i < appName.length; i++) {
      await Future.delayed(const Duration(milliseconds: 80));
      _letterControllers[i].forward();
    }

    // Start love icon animation after last letter
    await Future.delayed(const Duration(milliseconds: 500));
    _loveIconController.forward().then((_) {
      naviagte();
    });
  }

  void naviagte() async {
    final userController = Get.find<UserController>();
    final socketController = Get.find<SocketController>();
    final storageController = Get.find<StorageController>();
    bool newUser = await storageController.getUserStatus();
    if (newUser) {
      Get.offAll(() => const OnboardingScreen());
      await storageController.saveStatus("notNewAgain");
      return;
    }
    String? token = await storageController.getToken();
    if (token == null || token.isEmpty) {
      Get.off(() => const RegisterScreen());
      // Get.off(() => const PickHobbiesScreen());
      return;
    }
    await userController.getUserStatus();
    socketController.initializeSocket();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _heartController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    _loveIconController.dispose();

    for (final controller in _letterControllers) {
      controller.dispose();
    }

    super.dispose();
  }
}
