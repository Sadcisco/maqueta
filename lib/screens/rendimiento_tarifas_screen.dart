import 'package:flutter/material.dart';

class RendimientoTarifasScreen extends StatelessWidget {
  const RendimientoTarifasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos simulados para las tablas
    final tablaResumen = [
      {
        'Centro de Costo': 'SAN C3 IC CH',
        'Cuartel': 'SAN C3 IC CH',
        'Labor': 'PODA',
        'Tipo Personal': 'PROPIOS',
        'Unidad de Control': 'PLANTA',
        'Rendimiento Acumulado': '2.395',
        'Rendimiento o Ppto': '2.388',
        'Avance Faena %': '🔄',
        'Diferencia': '7',
        'Rend p/p Real': '85',
        'Rend p/p Ppto': '80',
        'Dif Rend p/p': '5',
        'Tarifa Real Prom': ' 2380',
        'Tarifa Ppto Prom': ' 2400',
        'Dif Tarifa': ' 20',
        'Liquido p/p Prom Real': ' 32.300',
        'Liquido p/p Prom Ppto': ' 32.000',
        'Dif Liquido': ' 300',
        'Ultimo Rend registrado': '23-06-2025',
      },
      {
        'Centro de Costo': 'SAN C3 IC CH',
        'Cuartel': 'SAN C3 IC CH',
        'Labor': 'RALEO',
        'Tipo Personal': 'CONTRATISTA',
        'Unidad de Control': 'PLANTA',
        'Rendimiento Acumulado': '2.145',
        'Rendimiento o Ppto': '2.388',
        'Avance Faena %': '🔄',
        'Diferencia': '-243',
        'Rend p/p Real': '94',
        'Rend p/p Ppto': '100',
        'Dif Rend p/p': '-6',
        'Tarifa Real Prom': ' 260',
        'Tarifa Ppto Prom': ' 250',
        'Dif Tarifa': ' 10',
        'Liquido p/p Prom Real': ' 24.440',
        'Liquido p/p Prom Ppto': ' 25.000',
        'Dif Liquido': ' -560',
        'Ultimo Rend registrado': '03-11-2025',
      },
      {
        'Centro de Costo': 'SAN C3 IC CH',
        'Cuartel': 'SAN C3 IC CH',
        'Labor': 'COSECHA',
        'Tipo Personal': 'CONTRATISTA',
        'Unidad de Control': 'KG',
        'Rendimiento Acumulado': '25.894',
        'Rendimiento o Ppto': '37.941',
        'Avance Faena %': '🔄',
        'Diferencia': '-12.047',
        'Rend p/p Real': '184',
        'Rend p/p Ppto': '170',
        'Dif Rend p/p': '14',
        'Tarifa Real Prom': ' 300',
        'Tarifa Ppto Prom': ' 300',
        'Dif Tarifa': '0',
        'Liquido p/p Prom Real': ' 55.200',
        'Liquido p/p Prom Ppto': ' 51.000',
        'Dif Liquido': ' 4.200',
        'Ultimo Rend registrado': '15-12-2025',
      },
    ];
    final tablaDetalle = [
      {
        'Fecha': '20-06-2025',
        'Centro de Costo': 'SAN C3 IC CH',
        'Cuartel': 'SAN C3 IC CH',
        'Labor': 'PODA',
        'Contratista': 'PROPIOS',
        'Tipo de rendimiento': 'INDIVIDUAL',
        'Cantidad Trabajadores': '1',
        'Personal': 'JUAN PEREZ',
        'Unidad de Control': 'PLANTA',
        'Rendimiento': '73',
        'Rend p/p Real': '74',
        'Rend p/p Ppto': '80',
        'Dif Rend p/p': '-6',
        'Tarifa Real Liquida': ' 380',
        'Tarifa Ppto': ' 400',
        'Dif Tarifa': ' -20',
        'Liquido p/p Prom Real': ' 30.020',
        'Liquido p/p Prom Ppto': ' 32.000',
        'Dif Liquido': ' -1.980',
        'Porcentaje Contratista': '35%',
        'Dif a pesos': '43.740',
        'Dif a pesos 2': '',
      },
      // ... más filas simuladas ...
    ];
    final tablaAvance = [
      {
        'Centro de Costo': 'SAN C3 IC CH',
        'Cuartel': 'SAN C3 IC CH',
        'Labor': 'PODA',
        'Tipo Personal': 'PROPIOS',
        'Unidad de Control': 'PLANTA',
        'Plantas pagadas': '784',
        'Plantas por pagar': '1611',
        'Total Avance Plantas': '2.395',
        'Total Plantas Cuartel': '2.388',
        'Diferencia': '7',
        'Avance Faena %': '🔄',
        'Dif Avance': '2.631',
        'Ultimo Rend registrado': '23-06-2025',
      },
      {
        'Centro de Costo': 'SAN C3 IC CH',
        'Cuartel': 'SAN C3 IC CH',
        'Labor': 'RALEO',
        'Tipo Personal': 'CONTRATISTA',
        'Unidad de Control': 'PLANTA',
        'Plantas pagadas': '805',
        'Plantas por pagar': '1340',
        'Total Avance Plantas': '2.145',
        'Total Plantas Cuartel': '2.388',
        'Diferencia': '-243',
        'Avance Faena %': '🔄',
        'Dif Avance': '2.631',
        'Ultimo Rend registrado': '03-11-2025',
      },
    ];

    Widget buildTable(List<Map<String, String>> data, List<String> columns, {String? title}) {
      return Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.green[700]),
                  headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  dataRowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.green[100];
                    }
                    return null;
                  }),
                  columns: columns.map((c) => DataColumn(label: Text(c, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11)))).toList(),
                  rows: data.map((row) {
                    return DataRow(
                      color: MaterialStateProperty.all(Colors.white),
                      cells: columns.map((c) {
                        final value = row[c] ?? '';
                        Color? cellColor;
                        if (c.toLowerCase().contains('diferencia') || c.toLowerCase().contains('dif')) {
                          if (value.startsWith('-')) {
                            cellColor = Colors.green[100];
                          } else if (value.isNotEmpty && value != '0') {
                            cellColor = Colors.red[100];
                          }
                        }
                        return DataCell(Container(
                          color: cellColor,
                          child: Text(value, style: TextStyle(fontSize: 11, color: cellColor == null ? Colors.black : Colors.red[900])),
                        ));
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildTable(tablaResumen, [
            'Centro de Costo', 'Cuartel', 'Labor', 'Tipo Personal', 'Unidad de Control',
            'Rendimiento Acumulado', 'Rendimiento o Ppto', 'Avance Faena %', 'Diferencia',
            'Rend p/p Real', 'Rend p/p Ppto', 'Dif Rend p/p',
            'Tarifa Real Prom', 'Tarifa Ppto Prom', 'Dif Tarifa',
            'Liquido p/p Prom Real', 'Liquido p/p Prom Ppto', 'Dif Liquido',
            'Ultimo Rend registrado',
          ], title: 'Rendimiento y Tarifas'),
          buildTable(tablaDetalle, [
            'Fecha', 'Centro de Costo', 'Cuartel', 'Labor', 'Contratista', 'Tipo de rendimiento',
            'Cantidad Trabajadores', 'Personal', 'Unidad de Control', 'Rendimiento', 'Rend p/p Real', 'Rend p/p Ppto', 'Dif Rend p/p',
            'Tarifa Real Liquida', 'Tarifa Ppto', 'Dif Tarifa',
            'Liquido p/p Prom Real', 'Liquido p/p Prom Ppto', 'Dif Liquido',
            'Porcentaje Contratista', 'Dif a pesos', 'Dif a pesos 2',
          ], title: 'Detalle Rendimiento y Tarifas'),
          buildTable(tablaAvance, [
            'Centro de Costo', 'Cuartel', 'Labor', 'Tipo Personal', 'Unidad de Control',
            'Plantas pagadas', 'Plantas por pagar', 'Total Avance Plantas', 'Total Plantas Cuartel',
            'Diferencia', 'Avance Faena %', 'Dif Avance', 'Ultimo Rend registrado',
          ], title: 'Avance Plantas'),
        ],
      ),
    );
  }
} 