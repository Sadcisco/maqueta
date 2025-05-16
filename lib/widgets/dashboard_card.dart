import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final List<FlSpot> chartData;
  final Color? color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.chartData,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? AppTheme.primaryDark,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppTheme.textColor,
                  ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 60,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: chartData,
                      isCurved: true,
                      color: AppTheme.primaryLight,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 