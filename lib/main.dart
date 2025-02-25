import 'package:echodate/app/modules/favourtie/views/favourite_screen.dart';
import 'package:echodate/app/modules/home/views/home_screen.dart';
import 'package:echodate/app/modules/live/views/watch_live_screen.dart';
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
      ),
      home: FavouriteScreen(),
    );
  }
}
