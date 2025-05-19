import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ParametrosGeneralesScreen extends StatefulWidget {
  final String parametro;
  const ParametrosGeneralesScreen({super.key, required this.parametro});

  @override
  State<ParametrosGeneralesScreen> createState() => _ParametrosGeneralesScreenState();
}

class _ParametrosGeneralesScreenState extends State<ParametrosGeneralesScreen> {
  List<Map<String, String>> _data = [];

  @override
  void initState() {
    super.initState();
    // Simula datos de ejemplo
    _data = List.generate(5, (i) => {
      'ID': '${i + 1}',
      'Nombre': '${widget.parametro} ${i + 1}',
      'Descripción': 'Descripción de ${widget.parametro.toLowerCase()} ${i + 1}',
    });
  }

  void _addRegistro() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _RegistroDialog(parametro: widget.parametro),
    );
    if (result != null) {
      setState(() => _data.add(result));
    }
  }

  void _editRegistro(int index) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _RegistroDialog(parametro: widget.parametro, initial: _data[index]),
    );
    if (result != null) {
      setState(() => _data[index] = result);
    }
  }

  void _deleteRegistro(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar registro'),
        content: const Text('¿Estás seguro de que deseas eliminar este registro?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => _data.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Definir columnas y datos simulados según el parámetro
    List<String> columns;
    List<Map<String, String>> data;
    switch (widget.parametro) {
      case 'Centro de costos':
        columns = ['ID', 'Nombre', 'Descripción', 'Código', 'Estado', 'Acciones'];
        data = List.generate(5, (i) => {
          'ID': '${i + 1}',
          'Nombre': 'Centro ${i + 1}',
          'Descripción': 'Centro de costos ${i + 1}',
          'Código': 'CC${100 + i}',
          'Estado': i % 2 == 0 ? 'Activo' : 'Inactivo',
        });
        break;
      case 'Variedad':
        columns = ['ID', 'Nombre', 'Especie', 'Ciclo', 'Estado', 'Acciones'];
        data = List.generate(5, (i) => {
          'ID': '${i + 1}',
          'Nombre': 'Variedad ${i + 1}',
          'Especie': ['Carozo', 'Cereza', 'Ciruela', 'Uva'][i % 4],
          'Ciclo': i % 2 == 0 ? 'Temprano' : 'Tardío',
          'Estado': i % 2 == 0 ? 'Activo' : 'Inactivo',
        });
        break;
      case 'Cuarteles':
        columns = ['ID', 'Nombre', 'Superficie', 'Sucursal', 'Estado', 'Acciones'];
        data = List.generate(5, (i) => {
          'ID': '${i + 1}',
          'Nombre': 'Cuartel ${i + 1}',
          'Superficie': '${10 + i} ha',
          'Sucursal': ['SAN MANUEL', 'CULLIPEUMO', 'HOSPITAL'][i % 3],
          'Estado': i % 2 == 0 ? 'Activo' : 'Inactivo',
        });
        break;
      case 'Temporada':
        columns = ['ID', 'Nombre', 'Fecha inicio', 'Fecha fin', 'Estado', 'Acciones'];
        data = List.generate(5, (i) => {
          'ID': '${i + 1}',
          'Nombre': 'Temporada ${2020 + i}',
          'Fecha inicio': '01/0${i + 1}/202${i}',
          'Fecha fin': '31/12/202${i}',
          'Estado': i % 2 == 0 ? 'Abierta' : 'Cerrada',
        });
        break;
      case 'Labores':
        columns = ['ID', 'Nombre', 'Tipo', 'Unidad', 'Estado', 'Acciones'];
        data = List.generate(5, (i) => {
          'ID': '${i + 1}',
          'Nombre': 'Labor ${i + 1}',
          'Tipo': ['Poda', 'Raleo', 'Cosecha'][i % 3],
          'Unidad': i % 2 == 0 ? 'ha' : 'jornal',
          'Estado': i % 2 == 0 ? 'Activo' : 'Inactivo',
        });
        break;
      case 'Tipo de Planta':
        columns = ['ID', 'Nombre', 'Descripción', 'Estado', 'Acciones'];
        data = List.generate(5, (i) => {
          'ID': '${i + 1}',
          'Nombre': 'Tipo ${i + 1}',
          'Descripción': 'Tipo de planta ${i + 1}',
          'Estado': i % 2 == 0 ? 'Activo' : 'Inactivo',
        });
        break;
      default:
        columns = ['ID', 'Nombre', 'Descripción', 'Acciones'];
        data = _data;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.parametro),
        backgroundColor: AppTheme.primaryDark,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[400],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _addRegistro,
              icon: const Icon(Icons.add),
              label: const Text('Añadir'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          elevation: 2,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: columns.map((c) => DataColumn(label: Text(c, style: const TextStyle(fontWeight: FontWeight.bold)))).toList(),
              rows: data.asMap().entries.map((entry) {
                final i = entry.key;
                final row = entry.value;
                return DataRow(cells: [
                  ...columns.where((c) => c != 'Acciones').map((c) => DataCell(Text(row[c] ?? ''))),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editRegistro(i),
                        tooltip: 'Editar',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteRegistro(i),
                        tooltip: 'Eliminar',
                      ),
                    ],
                  )),
                ]);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegistroDialog extends StatefulWidget {
  final String parametro;
  final Map<String, String>? initial;
  const _RegistroDialog({required this.parametro, this.initial});

  @override
  State<_RegistroDialog> createState() => _RegistroDialogState();
}

class _RegistroDialogState extends State<_RegistroDialog> {
  late TextEditingController _nombreController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.initial?['Nombre'] ?? '');
    _descController = TextEditingController(text: widget.initial?['Descripción'] ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initial == null ? 'Añadir ${widget.parametro}' : 'Editar ${widget.parametro}'),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green[400]),
          onPressed: () {
            Navigator.pop(context, {
              'ID': widget.initial?['ID'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
              'Nombre': _nombreController.text,
              'Descripción': _descController.text,
            });
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
} 