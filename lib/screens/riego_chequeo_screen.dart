import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChequeoRiegoScreen extends StatelessWidget {
  const ChequeoRiegoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Filtros simulados
    final filtros = [
      {'label': 'sucursal', 'value': 'Sucursal 1'},
      {'label': 'caseta', 'value': 'Caseta 1'},
      {'label': 'equipo', 'value': 'Equipo 1'},
      {'label': 'cuartel', 'value': 'Cuartel 1'},
      {'label': 'variedad', 'value': 'Variedad 1'},
      {'label': 'especie', 'value': 'Especie 1'},
    ];
    final periodos = ['Selecciona un periodo'];

    // Datos simulados para el gráfico
    final sucursales = [
      {'label': 'MAITEN GIGANTE', 'color': Colors.brown},
      {'label': 'SANTA VICTORIA', 'color': Colors.orange},
      {'label': 'HOSPITAL', 'color': Colors.yellow[700]},
      {'label': 'SANTA INES', 'color': Colors.grey},
      {'label': 'CULLIPEUMO', 'color': Colors.pink},
      {'label': 'SAN MANUEL', 'color': Colors.blue},
      {'label': 'CAMPO ITAHUE', 'color': Colors.green},
      {'label': 'CAMPO CHOCALAN', 'color': Colors.teal},
    ];
    final semanas = List.generate(25, (i) => '2024-${45 + i ~/ 2}${i % 2 == 0 ? '' : '-${46 + i ~/ 2}'}');
    // Generar datos aleatorios para cada sucursal
    final lineData = sucursales.map((suc) => List.generate(semanas.length, (i) => (i == 0 ? 0 : (20 + (i * 3 + suc['label'].hashCode % 80) % 100) % 101).toDouble())).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chequeo Caseta'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Filtros
              Wrap(
                spacing: 24,
                runSpacing: 12,
                children: [
                  ...filtros.map((f) => SizedBox(
                    width: 280,
                    child: DropdownButtonFormField<String>(
                      value: f['value'],
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: f['label'],
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: const TextStyle(fontSize: 13, overflow: TextOverflow.visible),
                      ),
                      items: [DropdownMenuItem(value: f['value'], child: Text(f['value']!))],
                      onChanged: (_) {},
                    ),
                  )),
                ],
              ),
              const SizedBox(height: 16),
              // Título
              const Center(
                child: Text('CHEQUEO CASETA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
              ),
              const SizedBox(height: 24),
              // Filtro periodo
              Row(
                children: [
                  SizedBox(
                    width: 300,
                    child: DropdownButtonFormField<String>(
                      value: periodos.first,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(fontSize: 13, overflow: TextOverflow.visible),
                      ),
                      items: periodos.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                      onChanged: (_) {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Gráfico de líneas cumplimiento
              Center(
                child: Column(
                  children: [
                    const Text(
                      'EVOLUCIÓN SEMANAL CUMPLIMIENTO Y REGISTROS POR SUCURSAL\n(MÉTRICAS OPCIONALES POR ESCALA CUMPLIMIENTO)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 260,
                      width: 900,
                      child: LineChart(
                        LineChartData(
                          minY: 0,
                          maxY: 100,
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true, interval: 25, getTitlesWidget: (v, _) => Text('${v.toInt()}%')),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true, interval: 4, getTitlesWidget: (v, _) {
                                int idx = v.toInt();
                                return idx >= 0 && idx < semanas.length
                                    ? Transform.rotate(angle: -0.7, child: Text(semanas[idx], style: const TextStyle(fontSize: 10)))
                                    : const SizedBox();
                              }),
                            ),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: FlGridData(show: true, horizontalInterval: 25),
                          lineBarsData: [
                            for (int i = 0; i < sucursales.length; i++)
                              LineChartBarData(
                                spots: [for (int j = 0; j < semanas.length; j++) FlSpot(j.toDouble(), lineData[i][j] % 101)],
                                isCurved: false,
                                color: sucursales[i]['color'] as Color?,
                                barWidth: 2,
                                dotData: FlDotData(show: false),
                              ),
                          ],
                        ),
                      ),
                    ),
                    // Leyenda
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Wrap(
                        spacing: 18,
                        children: [
                          for (final s in sucursales)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(width: 18, height: 3, color: s['color'] as Color?),
                                const SizedBox(width: 4),
                                Text(s['label'] as String, style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Segundo gráfico de líneas (calidad)
              const Center(
                child: Text('EVOLUCIÓN SEMANAL CALIDAD POR SUCURSAL', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  height: 80,
                  width: 900,
                  child: Divider(thickness: 1.5, color: Colors.black26),
                ),
              ),
              const SizedBox(height: 24),
              // Caja de criterios
              Center(
                child: Container(
                  width: 700,
                  decoration: BoxDecoration(border: Border.all(color: Colors.black54), borderRadius: BorderRadius.circular(8), color: Colors.white),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Criterios para Obtener 100% de Calidad en el Chequeo de la Caseta', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 6),
                      Text('Para asegurar el 100% de calidad en el chequeo, es necesario cumplir con todas las condiciones siguientes. Si alguna de estas condiciones no se cumple, el resultado será 0%.', style: TextStyle(fontSize: 14)),
                      SizedBox(height: 10),
                      _CriterioItem('Diferencial de Presión en el Equipo:', 'La presión de entrada menos la presión de salida del equipo debe ser menor o igual a 0.5 bar.'),
                      _CriterioItem('Filtro de Retrolavado:', 'El filtro de retrolavado debe funcionar sin fallas.'),
                      _CriterioItem('Nivel de Barro en el Decantador:', 'El nivel de barro en el decantador debe ser "CORRECTO".'),
                      _CriterioItem('Nivel de Algas en el Tranque (si aplica):', 'Si existe un tranque, el nivel de algas en el tranque debe ser "BAJO".'),
                      _CriterioItem('Estado del Filtro de Fertilizantes (si aplica):', 'Si hay un filtro de fertilizantes, este debe estar en estado correcto.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CriterioItem extends StatelessWidget {
  final String titulo;
  final String detalle;
  const _CriterioItem(this.titulo, this.detalle);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(width: 4),
          Expanded(child: Text(detalle, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
} 