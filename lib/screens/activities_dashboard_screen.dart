import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ActivitiesDashboardScreen extends StatelessWidget {
  const ActivitiesDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos simulados para KPIs
    final kpis = [
      {'label': 'Total Faenas', 'value': '12'},
      {'label': 'Total Colaboradores', 'value': '394'},
      {'label': 'Prom. Rendimiento', 'value': '2.350'},
      {'label': 'Prom. Tarifa', 'value': ' 25.000'},
      {'label': 'Tarjas Pendientes', 'value': '88'},
    ];
    // Datos para gráficos
    final faenas = ['PODA', 'RALEO', 'COSECHA', 'MANT. EQUIPOS', 'RIEGO TECNIFICADO'];
    final rendimientos = [2395, 2145, 25894, 5, 67];
    final tarjasPendientes = [12, 18, 24, 8, 26];
    final estadoTarjas = [60, 23, 5];
    final estadoLabels = ['Pendientes', 'Revisadas', 'Finalizadas'];

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // KPIs
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 18,
              runSpacing: 12,
              children: kpis.map((k) => _KpiCard(title: k['label']!, value: k['value']!)).toList(),
            ),
            const SizedBox(height: 24),
            // Gráficos resumen
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gráfico de barras de rendimiento por faena
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const Text('Rendimiento por Faena', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 100,
                            child: BarChart(
                              BarChartData(
                                barGroups: List.generate(faenas.length, (i) => BarChartGroupData(x: i, barRods: [
                                  BarChartRodData(toY: rendimientos[i].toDouble(), color: Colors.blue[700], width: 18),
                                ])),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => v.toInt() < faenas.length ? Text(faenas[v.toInt()], style: const TextStyle(fontSize: 10)) : const SizedBox())),
                                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => Text('${v.toInt()}', style: const TextStyle(fontSize: 9)))),
                                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                gridData: FlGridData(show: true),
                                barTouchData: BarTouchData(enabled: false),
                                alignment: BarChartAlignment.spaceBetween,
                                maxY: 30000,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Gráfico de barras de tarjas pendientes por faena
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const Text('Tarjas Pendientes por Faena', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 100,
                            child: BarChart(
                              BarChartData(
                                barGroups: List.generate(faenas.length, (i) => BarChartGroupData(x: i, barRods: [
                                  BarChartRodData(toY: tarjasPendientes[i].toDouble(), color: Colors.orange[700], width: 18),
                                ])),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => v.toInt() < faenas.length ? Text(faenas[v.toInt()], style: const TextStyle(fontSize: 10)) : const SizedBox())),
                                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => Text('${v.toInt()}', style: const TextStyle(fontSize: 9)))),
                                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                gridData: FlGridData(show: true),
                                barTouchData: BarTouchData(enabled: false),
                                alignment: BarChartAlignment.spaceBetween,
                                maxY: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Pie chart de estado de tarjas
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const Text('Estado de Tarjas', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 100,
                            child: PieChart(
                              PieChartData(
                                sections: List.generate(estadoTarjas.length, (i) => PieChartSectionData(
                                  value: estadoTarjas[i].toDouble(),
                                  color: [Colors.orange, Colors.blue, Colors.green][i],
                                  title: '${estadoLabels[i]}\n${estadoTarjas[i]}',
                                  titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                )),
                                sectionsSpace: 2,
                                centerSpaceRadius: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  const _KpiCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }
} 