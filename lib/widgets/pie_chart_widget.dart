import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';

class PieChartWidget extends StatelessWidget {
  final List<PieChartSectionData> sections;
  final String? legend;

  const PieChartWidget({
    super.key,
    required this.sections,
    this.legend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (legend != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              legend!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.primaryDark,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        SizedBox(
          height: 160,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 32,
              sectionsSpace: 2,
              borderData: FlBorderData(show: false),
            ),
            swapAnimationDuration: const Duration(milliseconds: 800),
          ),
        ),
      ],
    );
  }
} 