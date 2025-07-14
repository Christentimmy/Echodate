import 'package:echodate/app/bindings/app_bindings.dart';
import 'package:echodate/app/controller/one_signal_controller.dart';
import 'package:echodate/app/modules/splash/views/echo_splash_screen.dart';
import 'package:echodate/app/theme/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(OneSignalController());
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.changeThemeMode(ThemeMode.dark);
    // final ThemeController themeController = Get.put(ThemeController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      themeMode: ThemeMode.dark,
      darkTheme: darkTheme,
      theme: lightTheme,
      home: EchodateSplashScreen(),
      initialBinding: AppBindings(),
    );
  }
}
