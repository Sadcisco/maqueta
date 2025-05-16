import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;

  const DashboardScreen({
    super.key,
    required this.title,
    this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppTheme.primaryDark,
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.primaryDark,
                  ),
            ),
          ],
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
} 