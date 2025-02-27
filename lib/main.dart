import 'package:echodate/app/modules/withdraw/views/add_bank_screen.dart';
import 'package:echodate/app/modules/withdraw/views/withdrawal_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
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
        splashFactory: NoSplash.splashFactory,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: AddBankScreen(),
    );
  }
}
