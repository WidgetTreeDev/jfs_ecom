import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jfs_ecommerce/core/theme/app_theme.dart';
import '../bloc/theme_cubit.dart';

class ThemeSwitcherButton extends StatelessWidget {
  const ThemeSwitcherButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: isDark ? Colors.white : Colors.grey[800],
        border: Border.all(
          color: isDark ? AppTheme.charcoal : Colors.white,
          width: 2,
        ),
      ),
      child: IconButton(
        tooltip: 'Toggle Theme',
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return RotationTransition(
              turns: animation,
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child: isDark
              ? const Icon(
                  Icons.wb_sunny_outlined,
                  key: ValueKey('sunny_icon'),
                  color: Colors.amber,
                )
              : Icon(
                  Icons.nightlight_outlined,
                  key: ValueKey('night_icon'),
                  color: theme.primaryColor,
                ),
        ),
        onPressed: () {
          context.read<ThemeCubit>().toggleTheme(!isDark);
        },
      ),
    );
  }
}
