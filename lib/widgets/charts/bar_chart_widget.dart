import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';

class BarChartWidget extends StatelessWidget {
  final List<BarChartGroupData> barGroups;
  final List<String> xLabels;
  final String yLabel;
  final String legend;

  const BarChartWidget({
    super.key,
    required this.barGroups,
    required this.xLabels,
    required this.yLabel,
    required this.legend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          legend,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textColor,
              ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 100,
              barGroups: barGroups,
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value >= 0 && value < xLabels.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            xLabels[value.toInt()],
                            style: const TextStyle(
                              color: AppTheme.textColor,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          color: AppTheme.textColor,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: false),
            ),
          ),
        ),
      ],
    );
  }
} 