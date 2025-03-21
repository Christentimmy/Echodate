import 'package:echodate/app/bindings/app_bindings.dart';
import 'package:echodate/app/controller/one_signal_controller.dart';
import 'package:echodate/app/modules/splash/views/splash_screen.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motion/motion.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(OneSignalController());
  await Motion.instance.initialize();
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
        splashColor: Colors.transparent,
        primaryColor: AppColors.primaryColor,
        splashFactory: NoSplash.splashFactory,
        scaffoldBackgroundColor: Colors.white,
      ),
      home:  const SplashScreen1(),
      initialBinding: AppBindings(),
    );
  }
}
