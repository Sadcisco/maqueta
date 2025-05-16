import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';

class PieChartWidget extends StatelessWidget {
  final List<PieChartSectionData> sections;
  final String legend;

  const PieChartWidget({
    super.key,
    this.sections = const [],
    this.legend = '',
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
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 40,
              sectionsSpace: 2,
            ),
          ),
        ),
      ],
    );
  }
} 