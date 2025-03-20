import 'package:device_preview/device_preview.dart';
import 'package:echodate/app/bindings/app_bindings.dart';
import 'package:echodate/app/controller/one_signal_controller.dart';
import 'package:echodate/app/modules/splash/views/splash_screen.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(OneSignalController());
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MainApp(),
    ),
    // const MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      useInheritedMediaQuery: true,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
        splashColor: Colors.transparent,
        primaryColor: AppColors.primaryColor,
        splashFactory: NoSplash.splashFactory,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashScreen1(),
      initialBinding: AppBindings(),
    );
  }
}
