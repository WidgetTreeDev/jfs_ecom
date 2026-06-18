import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorStateWidget extends StatelessWidget {
  final String lottiePath;
  final String title;
  final String? subtitle;
  final double size;
  final Widget? actionButton;

  const ErrorStateWidget({
    super.key,
    required this.lottiePath,
    required this.title,
    this.subtitle,
    this.size = 200,
    this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: Lottie.asset(
                'assets/lotties/$lottiePath',
                fit: BoxFit.contain,
              ),
            ),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],

            if (actionButton != null) ...[
              const SizedBox(height: 24),
              actionButton!,
            ],
          ],
        ),
      ),
    );
  }
}