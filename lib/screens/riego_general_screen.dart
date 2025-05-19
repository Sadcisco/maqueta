import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RiegoGeneralScreen extends StatelessWidget {
  const RiegoGeneralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos simulados para las tarjetas de resumen
    final resumen = [
      {'label': 'Vol. Original (Kc) (M3)', 'value': '6,1 M'},
      {'label': 'Kc', 'value': '0,7'},
      {'label': 'Lámina según Kc', 'value': '13,3'},
      {'label': 'Lámina según programa', 'value': '10,1'},
      {'label': 'Lámina real regada (mm)', 'value': '9,8', 'sub': '-2.5%', 'subColor': Colors.red},
    ];
    final indicadores = [
      {'label': 'CUMPLIMIENTO PROGRAMA', 'value': '94,1 %'},
      {'label': 'CUMPLIMIENTO VOL', 'value': '97,5 %'},
      {'label': 'TIEMPO RIEGO (Horas)', 'value': '58,5 mil'},
      {'label': 'VOLUMEN PROGRAMADO (m3)', 'value': '4,7 M'},
      {'label': 'VOLUMEN REGADO (m3)', 'value': '4,6 M'},
    ];
    final semanas = ['2024-05'];
    final detalle = [
      ['2024-05', 'SEPTEMBER BRIGHT P 2 SI', '231,31', '230,48', '-0,36 %', '100 %'],
      ['2024-05', 'RUSSEL PRIDE H 1 SI', '140,8', '147,09', '4,46 %', '100 %'],
      ['2024-05', 'NE 20 P 1 SI', '121', '125,29', '3,5 %', '100 %'],
      ['2024-05', 'SWEET GLOBE CULLIP', '110,4', '110,4', '0 %', '100 %'],
      ['2024-05', 'ASF 976 F 2 SI', '104,5', '107,25', '2,63 %', '100 %'],
      ['2024-05', 'PRISTINE C 28 HO', '97,78', '114,34', '87,5 %', '100 %'],
      ['2024-05', 'ALLISON CULLIP', '96', '115,42', '83,33 %', '100 %'],
      ['2024-05', 'BLACK KAT C 8 PA', '93,87', '91,57', '-2,46 %', '100 %'],
      ['2024-05', 'ANGELENO B 2 A SF', '91,43', '91,43', '0 %', '100 %'],
      ['2024-05', 'MELODY H 2 SI', '90,51', '88', '-2,78 %', '100 %'],
      ['2024-05', 'TIMCO H 3 SI', '80,46', '77,94', '-3,13 %', '100 %'],
      ['2024-05', 'BLACK SPLENDOR P2 MAN', '76', '72,38', '-4,76 %', '100 %'],
    ];
    final columns = ['SEMANA', 'CUARTEL', 'Lámina sema...', 'Lámina real r...', 'Variación Lá...', 'CUMPLIMIEN...'];
    final pieData = [
      {'label': 'NECTARINES', 'value': 34.5, 'color': Colors.teal[400]},
      {'label': 'UVA', 'value': 27.1, 'color': Colors.teal[700]},
      {'label': 'CEREZAS', 'value': 14.6, 'color': Colors.blue[200]},
      {'label': 'DURAZNOS', 'value': 12.6, 'color': Colors.blue[400]},
      {'label': 'CIRUELAS', 'value': 6.4, 'color': Colors.blue[800]},
      {'label': '#N/A', 'value': 4.8, 'color': Colors.green[200]},
      {'label': 'DAMASCO', 'value': 0, 'color': Colors.green[800]},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riego General'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tarjetas de resumen
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: resumen.map((item) => _ResumenCard(item: item)).toList(),
              ),
              const SizedBox(height: 16),
              // Filtros
              Row(
                children: [
                  DropdownButton<String>(
                    value: 'SEMANA RIEGO',
                    items: const [DropdownMenuItem(value: 'SEMANA RIEGO', child: Text('SEMANA RIEGO'))],
                    onChanged: (_) {},
                  ),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                    value: 'CASETA',
                    items: const [DropdownMenuItem(value: 'CASETA', child: Text('CASETA'))],
                    onChanged: (_) {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Indicadores
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: indicadores.map((item) => _IndicadorCard(item: item)).toList(),
              ),
              const SizedBox(height: 24),
              // Detalle semanal y gráfico
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tabla
                  Expanded(
                    flex: 2,
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('DETALLE SEMANAL LÁMINAS DE RIEGO', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: columns.map((c) => DataColumn(label: Text(c, style: const TextStyle(fontWeight: FontWeight.bold)))).toList(),
                                rows: detalle.map((r) => DataRow(cells: r.map((v) => DataCell(Text(v))).toList())).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Pie chart
                  Expanded(
                    flex: 1,
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text('Especie', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 200,
                              child: PieChart(
                                PieChartData(
                                  sections: pieData.map((d) => PieChartSectionData(
                                    value: d['value'] as double,
                                    color: d['color'] as Color?,
                                    title: d['label'] as String,
                                    radius: 60,
                                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                                  )).toList(),
                                  sectionsSpace: 2,
                                  centerSpaceRadius: 0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Leyenda
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: pieData.map((d) => Row(
                                children: [
                                  Container(width: 12, height: 12, color: d['color'] as Color?),
                                  const SizedBox(width: 6),
                                  Text(d['label'] as String, style: const TextStyle(fontSize: 12)),
                                ],
                              )).toList(),
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
      ),
    );
  }
}

class _ResumenCard extends StatelessWidget {
  final Map item;
  const _ResumenCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item['label'], style: const TextStyle(fontSize: 13, color: Colors.black54)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(item['value'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  if (item['sub'] != null) ...[
                    const SizedBox(width: 8),
                    Text(item['sub'], style: TextStyle(fontSize: 14, color: item['subColor'] ?? Colors.black54)),
                  ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IndicadorCard extends StatelessWidget {
  final Map item;
  const _IndicadorCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item['label'], style: const TextStyle(fontSize: 13, color: Colors.black54)),
              const SizedBox(height: 8),
              Text(item['value'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
} 