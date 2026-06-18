import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system) {
    _loadTheme();
  }
  void _loadTheme() {
    final settingsBox = Hive.box('settings_box');
    final String? themeString = settingsBox.get('themeMode');

    if (themeString == 'light') {
      emit(ThemeMode.light);
    } else if (themeString == 'dark') {
      emit(ThemeMode.dark);
    } else {
      emit(ThemeMode.system);
    }
  }
  void toggleTheme(bool isDark) async {
    final newMode = isDark ? ThemeMode.dark : ThemeMode.light;
    emit(newMode);

    final settingsBox = Hive.box('settings_box');
    await settingsBox.put('themeMode', isDark ? 'dark' : 'light');
  }
}