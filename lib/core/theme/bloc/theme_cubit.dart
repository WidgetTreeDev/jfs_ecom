import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system) {
    _loadTheme();
  }
  void _loadTheme() {
    final authBox = Hive.box('auth_box');
    final String? themeString = authBox.get('themeMode');

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

    final authBox = Hive.box('auth_box');
    await authBox.put('themeMode', isDark ? 'dark' : 'light');
  }
}