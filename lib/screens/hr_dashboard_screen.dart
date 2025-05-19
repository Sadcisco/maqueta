import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HRDashboardScreen extends StatelessWidget {
  const HRDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos simulados
    final dotacion = [
      {'label': 'OFICINA CENTRAL', 'value': 92},
      {'label': 'PLANTA CHOCALAN', 'value': 81},
      {'label': 'SAN MANUEL', 'value': 58},
      {'label': 'CAMPO ITAHUE', 'value': 48},
      {'label': 'SANTA INES', 'value': 33},
      {'label': 'HOSPITAL', 'value': 30},
      {'label': 'CAMPO CHOCALAN', 'value': 17},
      {'label': 'CULLIPEUMO', 'value': 14},
      {'label': 'SANTA VICTORIA', 'value': 12},
      {'label': 'MAITEN GIGANTE', 'value': 11},
    ];
    final genero = [
      {'label': 'MASCULINO', 'value': 273, 'color': Colors.blue},
      {'label': 'FEMENINO', 'value': 121, 'color': Colors.pink},
    ];
    final tipoContrato = [
      {'label': 'INDEFINIDO', 'value': 383, 'color': Colors.green},
      {'label': 'TRANSITORIO', 'value': 11, 'color': Colors.lightGreen},
    ];
    final edad = [60, 110, 68, 76, 61, 17];
    final edadLabels = ['20 a 30', '30 a 40', '40 a 50', '50 a 60', '70 a 80', '80 a 90'];
    final antiguedad = [208, 80, 76, 0, 0, 0];
    final antiguedadLabels = ['0 a 5', '5 a 10', '10 a 15', '25 a 30', '30 a 35', '40 a 45'];
    final jubilados = [10, 9, 6, 2, 2, 2, 1, 1, 1];
    final jubiladosLabels = ['SAN MANUEL', 'SANTA INES', 'CAMPO ITAHUE', 'HOSPITAL', 'PLANTA CHOCALAN', 'CAMPO CHOCALAN', 'MAITEN GIGANTE', 'OFICINA CENTRAL'];
    final afp = [158, 66, 49, 47, 38, 19, 14, 1];
    final afpLabels = ['PROVIDA', 'MODELO', 'CAPITAL', 'PLANVITAL', 'HABITAT', 'UNO', 'CUPRUM', 'IPS'];
    final salud = [359, 10, 9, 8, 7, 1];
    final saludLabels = ['FONASA', 'ISAPRE CRUZ BLANCA', 'ISAPRE CONSALUD', 'ISAPRE BANMEDICA', 'ISAPRE COLMENA', 'ISAPRE VIDA TRES'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          // KPIs
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _KpiBox(title: 'Total Colaboradores LH', value: '346'),
              _KpiBox(title: 'Total Colaboradores VS', value: '48'),
              _KpiBox(title: 'Promedio de Edad', value: '45,38', subtitle: 'Años'),
              _KpiBox(title: 'Antigüedad Promedio', value: '6,81', subtitle: 'Años'),
            ],
          ),
          const SizedBox(height: 12),
          // Primera fila de gráficos
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dotación activa pictogramas
              Expanded(
                flex: 2,
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Distribución dotación activa', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        ...dotacion.map((d) => Row(
                              children: [
                                SizedBox(width: 120, child: Text(d['label'] as String, style: const TextStyle(fontSize: 12))),
                                ...List.generate((d['value'] as int) ~/ 10, (i) => const Icon(Icons.person, color: Colors.green, size: 16)),
                                if ((d['value'] as int) % 10 > 0)
                                  Icon(Icons.person, color: Colors.green[700], size: 16),
                                const SizedBox(width: 4),
                                Text('${d['value']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Género
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const Text('Distribución por genero', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Icon(Icons.man, color: Colors.blue[700], size: 54),
                                Text('${genero[0]['value']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
                                const Text('MASCULINO', style: TextStyle(fontSize: 11)),
                              ],
                            ),
                            const SizedBox(width: 18),
                            Column(
                              children: [
                                Icon(Icons.woman, color: Colors.pink[300], size: 54),
                                Text('${genero[1]['value']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.pink)),
                                const Text('FEMENINO', style: TextStyle(fontSize: 11)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Pie tipo contrato
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const Text('Distribución por tipo de contrato', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 90,
                          child: PieChart(
                            PieChartData(
                              sections: tipoContrato
                                  .map((d) => PieChartSectionData(
                                        value: (d['value'] as int).toDouble(),
                                        color: d['color'] as Color,
                                        title: '${d['value']}\n(${((d['value'] as int) / 394 * 100).toStringAsFixed(2)}%)',
                                        titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                      ))
                                  .toList(),
                              sectionsSpace: 2,
                              centerSpaceRadius: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(width: 12, height: 8, color: Colors.green),
                            const SizedBox(width: 4),
                            const Text('INDEFINIDO', style: TextStyle(fontSize: 10)),
                            const SizedBox(width: 8),
                            Container(width: 12, height: 8, color: Colors.lightGreen),
                            const SizedBox(width: 4),
                            const Text('TRANSITORIO', style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Segunda fila de gráficos
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Distribución por edad
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const Text('Distribución por edad', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 80,
                          child: BarChart(
                            BarChartData(
                              barGroups: List.generate(edad.length, (i) => BarChartGroupData(x: i, barRods: [
                                BarChartRodData(toY: edad[i].toDouble(), color: Colors.brown[400], width: 18),
                              ])),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => v.toInt() < edadLabels.length ? Text(edadLabels[v.toInt()], style: const TextStyle(fontSize: 9)) : const SizedBox())),
                                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => Text('${v.toInt()}', style: const TextStyle(fontSize: 8)) )),
                                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              gridData: FlGridData(show: true),
                              barTouchData: BarTouchData(enabled: false),
                              alignment: BarChartAlignment.spaceBetween,
                              maxY: 120,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Distribución antigüedad
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const Text('Distribución antigüedad de colaboradores', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 80,
                          child: BarChart(
                            BarChartData(
                              barGroups: List.generate(antiguedad.length, (i) => BarChartGroupData(x: i, barRods: [
                                BarChartRodData(toY: antiguedad[i].toDouble(), color: Colors.brown[400], width: 18),
                              ])),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => v.toInt() < antiguedadLabels.length ? Text(antiguedadLabels[v.toInt()], style: const TextStyle(fontSize: 9)) : const SizedBox())),
                                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => Text('${v.toInt()}', style: const TextStyle(fontSize: 8)) )),
                                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              gridData: FlGridData(show: true),
                              barTouchData: BarTouchData(enabled: false),
                              alignment: BarChartAlignment.spaceBetween,
                              maxY: 220,
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
          const SizedBox(height: 10),
          // Tercera fila de gráficos
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dotación jubilados
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const Text('Dotación Jubilados', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 80,
                          child: BarChart(
                            BarChartData(
                              barGroups: List.generate(jubilados.length, (i) => BarChartGroupData(x: i, barRods: [
                                BarChartRodData(toY: jubilados[i].toDouble(), color: Colors.brown[200], width: 18),
                              ])),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => v.toInt() < jubiladosLabels.length ? Text(jubiladosLabels[v.toInt()], style: const TextStyle(fontSize: 9)) : const SizedBox())),
                                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => Text('${v.toInt()}', style: const TextStyle(fontSize: 8)) )),
                                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              gridData: FlGridData(show: true),
                              barTouchData: BarTouchData(enabled: false),
                              alignment: BarChartAlignment.spaceBetween,
                              maxY: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // AFP
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const Text('Distribución afiliados AFP', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 80,
                          child: BarChart(
                            BarChartData(
                              barGroups: List.generate(afp.length, (i) => BarChartGroupData(x: i, barRods: [
                                BarChartRodData(toY: afp[i].toDouble(), color: Colors.brown[700], width: 18),
                              ])),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => v.toInt() < afpLabels.length ? Text(afpLabels[v.toInt()], style: const TextStyle(fontSize: 9)) : const SizedBox())),
                                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => Text('${v.toInt()}', style: const TextStyle(fontSize: 8)) )),
                                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              gridData: FlGridData(show: true),
                              barTouchData: BarTouchData(enabled: false),
                              alignment: BarChartAlignment.spaceBetween,
                              maxY: 180,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Salud
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const Text('Distribución afiliados salud', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 80,
                          child: BarChart(
                            BarChartData(
                              barGroups: List.generate(salud.length, (i) => BarChartGroupData(x: i, barRods: [
                                BarChartRodData(toY: salud[i].toDouble(), color: Colors.brown[700], width: 18),
                              ])),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => v.toInt() < saludLabels.length ? Text(saludLabels[v.toInt()], style: const TextStyle(fontSize: 9)) : const SizedBox())),
                                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => Text('${v.toInt()}', style: const TextStyle(fontSize: 8)) )),
                                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              gridData: FlGridData(show: true),
                              barTouchData: BarTouchData(enabled: false),
                              alignment: BarChartAlignment.spaceBetween,
                              maxY: 400,
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
    );
  }
}

class _KpiBox extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  const _KpiBox({required this.title, required this.value, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 6),
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
          if (subtitle != null)
            Text(subtitle!, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }
} 