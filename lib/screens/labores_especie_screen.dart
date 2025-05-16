import 'package:flutter/material.dart';
import '../widgets/dashboard_card.dart';
import '../theme/app_theme.dart';

class LaboresEspecieScreen extends StatefulWidget {
  final String especie;
  const LaboresEspecieScreen({super.key, required this.especie});

  @override
  State<LaboresEspecieScreen> createState() => _LaboresEspecieScreenState();
}

class _LaboresEspecieScreenState extends State<LaboresEspecieScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedSucursal = 'SAN MANUEL';
  String _selectedVariedad = 'Todas';
  String _selectedEdad = 'Todas';
  String _selectedCuartel = 'Todos';
  String _selectedPeriodo = 'Últimos 30 días';

  final List<String> _sucursales = [
    'SAN MANUEL', 'SANTA VICTORIA', 'CULLIPEUMO', 'CAMPO CHOCALAN', 'SANTA INES', 'MAITEN GIGANTE', 'HOSPITAL'
  ];
  final List<String> _variedades = ['Todas', 'Variedad 1', 'Variedad 2'];
  final List<String> _edades = ['Todas', '1 año', '2 años', '3 años'];
  final List<String> _cuarteles = ['Todos', 'Cuartel 1', 'Cuartel 2', 'Cuartel 3'];
  final List<String> _periodos = ['Últimos 30 días', 'Temporada actual', 'Año anterior'];
  final List<String> _labores = ['Todas', 'Poda', 'Raleo', 'Cosecha', 'Fertilización'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Labores ${widget.especie}'),
        backgroundColor: AppTheme.primaryDark,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Conteo'),
            Tab(text: 'Calidad'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Filtros
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildDropdown('SUCURSAL', _selectedSucursal, _sucursales, (v) => setState(() => _selectedSucursal = v)),
                _buildDropdown('VARIEDAD', _selectedVariedad, _variedades, (v) => setState(() => _selectedVariedad = v)),
                _buildDropdown('EDAD', _selectedEdad, _edades, (v) => setState(() => _selectedEdad = v)),
                _buildDropdown('CUARTEL', _selectedCuartel, _cuarteles, (v) => setState(() => _selectedCuartel = v)),
                _buildDropdown('LABOR', _labores.first, _labores, (v) => setState(() {})),
                _buildDropdown('PERIODO', _selectedPeriodo, _periodos, (v) => setState(() => _selectedPeriodo = v)),
              ],
            ),
            const SizedBox(height: 18),
            // Tarjetas de resumen
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: Colors.green[400],
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: SizedBox(
                    width: 110,
                    height: 60,
                    child: Center(
                      child: Text('CONTEOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Card(
                  color: Colors.green[400],
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: SizedBox(
                    width: 110,
                    height: 60,
                    child: Center(
                      child: Text('% CONTEOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Card(
                  color: Colors.green[400],
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: SizedBox(
                    width: 110,
                    height: 60,
                    child: Center(
                      child: Text('MUESTRAS\n181', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[400],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {},
                    child: const Text('DESCARGAR INFORME', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Tabla de resumen
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTablaConteo(),
                  _buildTablaCalidad(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> options, ValueChanged<String> onChanged) {
    return SizedBox(
      width: 180,
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        items: options.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
        onChanged: (v) => onChanged(v!),
      ),
    );
  }

  Widget _buildTablaConteo() {
    // Simula datos de ejemplo
    final rows = [
      ['ARTIC FIRE B 13 A SM', '16 may 2025', '2.500', '113', '158', '145', '136', '-', '-', '-', '-', '-', '-'],
      ['CAKE BELLA B 10 B SM', '15 may 2025', '500', '18', '21', '80', '23', '-', '-', '-', '-', '-', '-'],
      ['CAKE BELLA BC 1 SM', '15 may 2025', '800', '34', '30', '82', '42', '-', '-', '-', '-', '-', '-'],
    ];
    final columns = [
      'CUARTEL', 'ÚLTIMO REGISTRO', 'CAJAS/Ha ESTIMADAS', 'RAMILLAS ESPERADAS', 'RAMILLAS TEMPORADA ANTERIOR',
      'RAMILLAS MUESTRA', 'PAUTA ACTIVA', 'RAMILLAS CONTEO', '% DIFERENCIA CONTEO VS PAUTA', 'BAJO PAUTA', 'CUMPLE PAUTA', 'SOBRE PAUTA'
    ];
    return _buildTable(columns, rows);
  }

  Widget _buildTablaCalidad() {
    // Simula datos de ejemplo para calidad
    final rows = [
      ['ARTIC FIRE B 13 A SM', '16 may 2025', 'Alta', '95%', 'Buena'],
      ['CAKE BELLA B 10 B SM', '15 may 2025', 'Media', '88%', 'Regular'],
    ];
    final columns = [
      'CUARTEL', 'ÚLTIMO REGISTRO', 'CALIDAD', '% CALIDAD', 'OBSERVACIÓN'
    ];
    return _buildTable(columns, rows);
  }

  Widget _buildTable(List<String> columns, List<List<String>> rows) {
    return Card(
      elevation: 2,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: columns.map((c) => DataColumn(label: Text(c, style: const TextStyle(fontWeight: FontWeight.bold)))).toList(),
          rows: rows.map((r) => DataRow(cells: r.map((v) => DataCell(Text(v))).toList())).toList(),
        ),
      ),
    );
  }
} 