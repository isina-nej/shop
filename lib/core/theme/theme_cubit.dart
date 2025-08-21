// Theme Management Cubit
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../storage/storage_service.dart';
import '../constants/app_constants.dart';

enum ThemeStatus { light, dark, system }

class ThemeCubit extends Cubit<ThemeStatus> {
  ThemeCubit() : super(ThemeStatus.system) {
    _loadTheme();
  }

  void _loadTheme() async {
    // TODO: Load theme from storage
    final themeString = await SharedPreferencesService.instance.getString(
      AppConstants.themeKey,
    );
    if (themeString != null) {
      final theme = ThemeStatus.values.firstWhere(
        (e) => e.toString() == themeString,
        orElse: () => ThemeStatus.system,
      );
      emit(theme);
    }
  }

  void changeTheme(ThemeStatus theme) async {
    emit(theme);
    await SharedPreferencesService.instance.setString(
      AppConstants.themeKey,
      theme.toString(),
    );
  }

  ThemeMode get themeMode {
    switch (state) {
      case ThemeStatus.light:
        return ThemeMode.light;
      case ThemeStatus.dark:
        return ThemeMode.dark;
      case ThemeStatus.system:
        return ThemeMode.system;
    }
  }
}
