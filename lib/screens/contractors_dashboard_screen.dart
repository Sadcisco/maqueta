import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../widgets/charts/bar_chart_widget.dart';
import '../widgets/charts/line_chart_widget.dart';
import '../widgets/charts/pie_chart_widget.dart';
import '../widgets/charts/stacked_bar_chart_widget.dart';

class ContractorsDashboardScreen extends StatelessWidget {
  const ContractorsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard de Contratistas',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.textColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _buildSummaryCard(
                  context,
                  'Total Contratistas',
                  '45',
                  Icons.business,
                  AppTheme.primaryLight,
                ),
                const SizedBox(width: 16),
                _buildSummaryCard(
                  context,
                  'Activos',
                  '38',
                  Icons.check_circle,
                  Colors.green,
                ),
                const SizedBox(width: 16),
                _buildSummaryCard(
                  context,
                  'Pendientes',
                  '7',
                  Icons.pending,
                  Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildChartCard(
                        context,
                        'Distribución por Tipo',
                        PieChartWidget(
                          legend: 'Distribución por Tipo',
                          sections: [
                            PieChartSectionData(
                              value: 40,
                              title: '40%',
                              color: AppTheme.primaryLight,
                              radius: 50,
                            ),
                            PieChartSectionData(
                              value: 30,
                              title: '30%',
                              color: Colors.blue,
                              radius: 50,
                            ),
                            PieChartSectionData(
                              value: 20,
                              title: '20%',
                              color: Colors.orange,
                              radius: 50,
                            ),
                            PieChartSectionData(
                              value: 10,
                              title: '10%',
                              color: Colors.green,
                              radius: 50,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildChartCard(
                        context,
                        'Tendencia de Contrataciones',
                        LineChartWidget(
                          legend: 'Tendencia Mensual',
                          spots: [
                            const FlSpot(0, 5),
                            const FlSpot(1, 8),
                            const FlSpot(2, 6),
                            const FlSpot(3, 9),
                            const FlSpot(4, 7),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildChartCard(
                        context,
                        'Contratistas por Área',
                        BarChartWidget(
                          legend: 'Contratistas por Área',
                          xLabels: ['Área 1', 'Área 2', 'Área 3', 'Área 4'],
                          yLabel: 'Contratistas',
                          barGroups: [
                            BarChartGroupData(x: 0, barRods: [
                              BarChartRodData(toY: 12, color: AppTheme.primaryLight),
                            ]),
                            BarChartGroupData(x: 1, barRods: [
                              BarChartRodData(toY: 8, color: AppTheme.primaryLight),
                            ]),
                            BarChartGroupData(x: 2, barRods: [
                              BarChartRodData(toY: 15, color: AppTheme.primaryLight),
                            ]),
                            BarChartGroupData(x: 3, barRods: [
                              BarChartRodData(toY: 10, color: AppTheme.primaryLight),
                            ]),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildChartCard(
                        context,
                        'Distribución de Servicios',
                        StackedBarChartWidget(
                          legend: 'Servicios por Área',
                          xLabels: ['Área 1', 'Área 2', 'Área 3'],
                          barGroups: [
                            BarChartGroupData(x: 0, barRods: [
                              BarChartRodData(toY: 8, color: AppTheme.primaryLight),
                              BarChartRodData(toY: 4, color: AppTheme.accentColor),
                            ]),
                            BarChartGroupData(x: 1, barRods: [
                              BarChartRodData(toY: 6, color: AppTheme.primaryLight),
                              BarChartRodData(toY: 3, color: AppTheme.accentColor),
                            ]),
                            BarChartGroupData(x: 2, barRods: [
                              BarChartRodData(toY: 10, color: AppTheme.primaryLight),
                              BarChartRodData(toY: 5, color: AppTheme.accentColor),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textColor,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(
    BuildContext context,
    String title,
    Widget chart,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.textColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: chart,
          ),
        ],
      ),
    );
  }
} 