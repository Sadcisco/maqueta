import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';

class BarChartWidget extends StatelessWidget {
  final List<BarChartGroupData> barGroups;
  final List<String> xLabels;
  final String yLabel;
  final String? legend;

  const BarChartWidget({
    super.key,
    required this.barGroups,
    required this.xLabels,
    required this.yLabel,
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
          height: 180,
          child: BarChart(
            BarChartData(
              barGroups: barGroups,
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 32),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      return idx >= 0 && idx < xLabels.length
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                xLabels[idx],
                                style: const TextStyle(fontSize: 12),
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            yLabel,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
} 