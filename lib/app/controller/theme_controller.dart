

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;
  final String _key = 'isDarkMode';

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPreferences();
  }

  Future<void> _loadThemeFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool(_key) ?? false;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> _saveThemeToPreferences(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_key, isDarkMode);
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _saveThemeToPreferences(isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}