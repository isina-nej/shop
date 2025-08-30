// Theme Controller using GetX
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ThemeStatus { light, dark, system }

class ThemeController extends GetxController {
  var currentTheme = ThemeStatus.system.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void _loadTheme() async {
    // TODO: Load theme from storage when storage service is implemented
    // For now, use system theme
    currentTheme.value = ThemeStatus.system;
  }

  void changeTheme(ThemeStatus theme) async {
    currentTheme.value = theme;
    // TODO: Save theme to storage when storage service is implemented
  }

  void toggleTheme() {
    if (currentTheme.value == ThemeStatus.light) {
      changeTheme(ThemeStatus.dark);
    } else {
      changeTheme(ThemeStatus.light);
    }
  }

  ThemeMode get themeMode {
    switch (currentTheme.value) {
      case ThemeStatus.light:
        return ThemeMode.light;
      case ThemeStatus.dark:
        return ThemeMode.dark;
      case ThemeStatus.system:
        return ThemeMode.system;
    }
  }
}
