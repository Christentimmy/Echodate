import 'package:echodate/app/bindings/app_bindings.dart';
import 'package:echodate/app/controller/one_signal_controller.dart';
import 'package:echodate/app/controller/storage_controller.dart';
import 'package:echodate/app/controller/theme_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/bottom_navigation/views/bottom_navigation_screen.dart';
import 'package:echodate/app/modules/splash/views/echo_splash_screen.dart';
import 'package:echodate/app/theme/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:app_links/app_links.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(OneSignalController());
  Get.put(StorageController());
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final AppLinks _appLinks = AppLinks();
  final userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    try {
      // Get the initial deep link if app was opened with one
      final appLink = await _appLinks.getInitialLink();
      if (appLink != null) {
        _handleDeepLink(appLink);
      }

      // Listen for deep links while app is running
      _appLinks.uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
          _handleDeepLink(uri);
        }
      });
    } catch (e) {
      print('Error initializing deep links: $e');
    }
  }

  void _handleDeepLink(Uri uri) {
    if (uri.host == 'payment-success') {
      // Use a small delay to ensure the app is fully initialized
      Future.delayed(const Duration(milliseconds: 1000), () {
        try {
          
          userController.getUserCoinHistory();
          if (Get.currentRoute != '/bottom-navigation') {
            Get.offAll(
              () => BottomNavigationScreen(),
              predicate: (route) => false,
            );
          }
        } catch (e) {
          print('Error handling deep link: $e');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorObservers: [routeObserver],
        themeMode:
            themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        darkTheme: darkTheme,
        theme: lightTheme,
        home: EchodateSplashScreen(),
        initialBinding: AppBindings(),
      ),
    );
  }
}
