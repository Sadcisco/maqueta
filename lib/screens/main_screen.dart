import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_header.dart';
import '../theme/app_theme.dart';
import '../screens/dashboard_screen.dart';
import '../screens/activities_dashboard_screen.dart';
import '../screens/hr_dashboard_screen.dart';
import '../screens/contractors_dashboard_screen.dart';
import '../widgets/dashboard_card.dart';
import '../utils/mock_data.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/bar_chart_widget.dart';
import '../widgets/pie_chart_widget.dart';
import 'admin_permissions_screen.dart';
import 'package:intl/intl.dart';
import 'labores_especie_screen.dart';
import 'parametros_generales_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedBranch = 'Fundo Norte';
  String _selectedSpecies = 'Durazno';
  bool _isAdmin = true; // For testing purposes

  MenuItem? _selectedMenu = MenuItems.items.first;

  final List<String> _branches = [
    'Fundo Norte',
    'Huerto Sur',
    'Estancia Las Rosas',
    'SAN MANUEL',
    'SANTA VICTORIA',
    'CULLIPEUMO',
    'CAMPO CHOCALAN',
    'SANTA INES',
    'MAITEN GIGANTE',
    'HOSPITAL',
  ];

  final List<String> _species = [
    'Durazno',
    'Nectarina',
    'Ciruela',
    'Uva',
    'Cereza',
  ];

  DateTime _selectedDate = DateTime.now();

  // Diccionario de labores actualizado con emojis y colores de fruta
  final Map<String, dynamic> _laborIcons = {
    'Riego': {'icon': Icons.water_drop, 'color': Colors.blue[700]},
    'Conteo Poda Carozos': {'icon': '🍑', 'color': Colors.orange[700]},
    'Conteo Poda Ciruela': {'icon': '🟣', 'color': Colors.deepPurple},
    'Conteo Poda Cerezas': {'icon': '🍒', 'color': Colors.redAccent},
    'Conteo Poda Uvas': {'icon': '🍇', 'color': Colors.purple},
  };

  // Diccionario de labores SOLO con Material Icons
  final Map<String, IconData> _laborMaterialIcons = {
    'Riego': Icons.water_drop,
    'Conteo Poda Carozos': Icons.local_florist,
    'Conteo Poda Ciruela': Icons.spa,
    'Conteo Poda Cerezas': Icons.emoji_food_beverage,
    'Conteo Poda Uvas': Icons.grass,
    'Conteo Poda Muestra Carozos': Icons.local_florist,
    'Conteo Poda Muestra Ciruela': Icons.spa,
    'Conteo Poda Muestra Cerezas': Icons.emoji_food_beverage,
    'Conteo Poda Muestra Uvas': Icons.grass,
  };

  // Generar actividades simuladas para el mes anterior, actual y siguiente
  List<Map<String, dynamic>> get _labores {
    final now = DateTime.now();
    final months = [now.month - 1, now.month, now.month + 1];
    final year = now.year;
    List<Map<String, dynamic>> acts = [];
    for (final m in months) {
      acts.addAll([
        // Riego
        {'fecha': DateTime(year, m, 3, 8, 0), 'tipo': 'Riego', 'desc': 'Riego por goteo en Cuartel 1'},
        {'fecha': DateTime(year, m, 10, 7, 30), 'tipo': 'Riego', 'desc': 'Riego por aspersión en Cuartel 2'},
        // Carozos
        {'fecha': DateTime(year, m, 5, 9, 0), 'tipo': 'Conteo Poda Carozos', 'desc': 'Conteo y poda en Carozos'},
        {'fecha': DateTime(year, m, 7, 9, 0), 'tipo': 'Conteo Poda Muestra Carozos', 'desc': 'Muestra de conteo y poda en Carozos'},
        // Ciruela
        {'fecha': DateTime(year, m, 12, 10, 0), 'tipo': 'Conteo Poda Ciruela', 'desc': 'Conteo y poda en Ciruela'},
        {'fecha': DateTime(year, m, 14, 10, 0), 'tipo': 'Conteo Poda Muestra Ciruela', 'desc': 'Muestra de conteo y poda en Ciruela'},
        // Cerezas
        {'fecha': DateTime(year, m, 15, 11, 0), 'tipo': 'Conteo Poda Cerezas', 'desc': 'Conteo y poda en Cerezas'},
        {'fecha': DateTime(year, m, 17, 11, 0), 'tipo': 'Conteo Poda Muestra Cerezas', 'desc': 'Muestra de conteo y poda en Cerezas'},
        // Uvas
        {'fecha': DateTime(year, m, 20, 8, 30), 'tipo': 'Conteo Poda Uvas', 'desc': 'Conteo y poda en Uvas'},
        {'fecha': DateTime(year, m, 22, 8, 30), 'tipo': 'Conteo Poda Muestra Uvas', 'desc': 'Muestra de conteo y poda en Uvas'},
      ]);
    }
    return acts;
  }

  bool _showFullMonth = false;
  String _filtroPeriodo = 'día'; // 'día', 'semana', 'mes'
  int? _expandedActivityIndex;

  void _onMenuItemSelected(MenuItem item) {
    setState(() {
      _selectedMenu = item;
    });
    Navigator.of(context).pop();
  }

  Widget _buildDashboard() {
    if (_selectedMenu == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 120,
              child: Image.asset(
                'assets/images/lh_fruits_logo.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Bienvenido a LH Fruits',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              'Seleccione una opción del menú para comenzar',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black87),
            ),
          ],
        ),
      );
    }

    // Handle main menu items
    if (_selectedMenu!.title == 'Actividades') {
      return const ActivitiesDashboardScreen();
    }
    if (_selectedMenu!.title == 'RRHH') {
      return const HRDashboardScreen();
    }
    if (_selectedMenu!.title == 'Contratistas') {
      return const ContractorsDashboardScreen();
    }

    // Handle submenu items
    if (_selectedMenu!.title == 'Rendimientos') {
      // Datos simulados
      final especies = ['Durazno', 'Uva', 'Cereza'];
      final temporadas = ['2022-2023', '2023-2024', '2024-2025'];
      final dataPorEspecie = [25.4, 32.1, 18.7];
      final dataPorTemporada = [28.0, 30.5, 27.2];
      final variedades = ['Elegant Lady', 'Rich Lady', 'Red Globe', 'Bing'];
      final dataVariedades = [40, 30, 20, 10];
      return DashboardScreen(
        title: 'Rendimientos',
        subtitle: 'Comparativo de rendimientos por especie, temporada y variedad',
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              DashboardCard(
                title: 'Promedio general',
                value: '28.7 t/ha',
                chartData: [
                  FlSpot(0, 25.4),
                  FlSpot(1, 32.1),
                  FlSpot(2, 18.7),
                ],
              ),
              DashboardCard(
                title: 'Máximo',
                value: '32.1 t/ha',
                chartData: [
                  FlSpot(0, 28),
                  FlSpot(1, 32.1),
                ],
              ),
              DashboardCard(
                title: 'Mínimo',
                value: '18.7 t/ha',
                chartData: [
                  FlSpot(0, 18.7),
                  FlSpot(1, 25.4),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          BarChartWidget(
            barGroups: List.generate(
              especies.length,
              (i) => BarChartGroupData(x: i, barRods: [
                BarChartRodData(toY: dataPorEspecie[i], color: AppTheme.primaryLight, width: 18),
              ]),
            ),
            xLabels: especies,
            yLabel: 'Toneladas por hectárea',
            legend: 'Rendimiento por especie',
          ),
          const SizedBox(height: 16),
          BarChartWidget(
            barGroups: List.generate(
              temporadas.length,
              (i) => BarChartGroupData(x: i, barRods: [
                BarChartRodData(toY: dataPorTemporada[i], color: AppTheme.accentColor, width: 18),
              ]),
            ),
            xLabels: temporadas,
            yLabel: 'Toneladas por hectárea',
            legend: 'Rendimiento por temporada',
          ),
          const SizedBox(height: 16),
          PieChartWidget(
            legend: 'Distribución por variedad',
            sections: List.generate(variedades.length, (i) =>
              PieChartSectionData(
                value: dataVariedades[i].toDouble(),
                color: [AppTheme.primaryLight, AppTheme.accentColor, AppTheme.primaryDark, AppTheme.backgroundColor][i % 4],
                title: '${variedades[i]}\n${dataVariedades[i]}%',
                radius: 48,
                titleStyle: const TextStyle(fontSize: 12, color: AppTheme.primaryDark, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      );
    }
    if (_selectedMenu!.title == 'Costos') {
      return DashboardScreen(
        title: 'Costos',
        subtitle: 'Costos por campo y labor',
        children: [
          Wrap(
            children: [
              DashboardCard(
                title: 'Fundo Norte',
                value: ' 20,000',
                chartData: [
                  FlSpot(0, 8000),
                  FlSpot(1, 12000),
                  FlSpot(2, 20000),
                ],
              ),
              DashboardCard(
                title: 'Huerto Sur',
                value: ' 18,000',
                chartData: [
                  FlSpot(0, 9000),
                  FlSpot(1, 15000),
                  FlSpot(2, 18000),
                ],
              ),
            ],
          ),
        ],
      );
    }
    if (_selectedMenu!.title == 'Calidad') {
      return DashboardScreen(
        title: 'Calidad',
        subtitle: 'Índice de calidad por especie y variedad',
        children: [
          Wrap(
            children: [
              DashboardCard(
                title: 'Durazno - Elegant Lady',
                value: '92%',
                chartData: [
                  FlSpot(0, 80),
                  FlSpot(1, 85),
                  FlSpot(2, 90),
                  FlSpot(3, 92),
                ],
              ),
              DashboardCard(
                title: 'Uva - Red Globe',
                value: '88%',
                chartData: [
                  FlSpot(0, 70),
                  FlSpot(1, 80),
                  FlSpot(2, 85),
                  FlSpot(3, 88),
                ],
              ),
            ],
          ),
        ],
      );
    }
    if (_selectedMenu!.title == 'Conteos') {
      return DashboardScreen(
        title: 'Conteos',
        subtitle: 'Conteos de fruta por campo y especie',
        children: [
          Wrap(
            children: [
              DashboardCard(
                title: 'Fundo Norte - Durazno',
                value: '1,500',
                chartData: [
                  FlSpot(0, 500),
                  FlSpot(1, 1000),
                  FlSpot(2, 1500),
                ],
              ),
              DashboardCard(
                title: 'Huerto Sur - Uva',
                value: '2,000',
                chartData: [
                  FlSpot(0, 800),
                  FlSpot(1, 1500),
                  FlSpot(2, 2000),
                ],
              ),
            ],
          ),
        ],
      );
    }
    if (_selectedMenu!.title == 'Administración') {
      return const AdminPermissionsScreen();
    }
    if (_selectedMenu!.title == 'Gestión de sucursales') {
      return DashboardScreen(
        title: 'Gestión de sucursales',
        subtitle: 'Administra las sucursales de la empresa',
        children: [
          const SizedBox(height: 32),
          Center(child: Text('Vista de gestión de sucursales (en construcción)', style: Theme.of(context).textTheme.bodyLarge)),
        ],
      );
    }
    if (_selectedMenu!.title == 'Gestión de módulos') {
      return DashboardScreen(
        title: 'Gestión de módulos',
        subtitle: 'Administra los módulos y permisos del sistema',
        children: [
          const SizedBox(height: 32),
          Center(child: Text('Vista de gestión de módulos (en construcción)', style: Theme.of(context).textTheme.bodyLarge)),
        ],
      );
    }
    if (_selectedMenu!.title == 'Home') {
      try {
        // Filtrar actividades según el periodo seleccionado
        DateTime start, end;
        if (_filtroPeriodo == 'día') {
          start = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
          end = start;
        } else if (_filtroPeriodo == 'semana') {
          int weekday = _selectedDate.weekday == 7 ? 0 : _selectedDate.weekday;
          start = _selectedDate.subtract(Duration(days: weekday - 1));
          end = start.add(const Duration(days: 6));
        } else {
          start = DateTime(_selectedDate.year, _selectedDate.month, 1);
          end = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
        }
        final actividadesFiltradas = _labores.where((l) {
          final fecha = l['fecha'] as DateTime;
          return !fecha.isBefore(start) && !fecha.isAfter(end);
        }).toList();

        String fechaTexto;
        if (_filtroPeriodo == 'día') {
          fechaTexto = toBeginningOfSentenceCase(DateFormat('EEEE, d MMMM', 'es').format(_selectedDate))!;
        } else if (_filtroPeriodo == 'semana') {
          fechaTexto = 'Semana ${_getWeekNumber(_selectedDate)}';
        } else {
          fechaTexto = toBeginningOfSentenceCase(DateFormat('MMMM yyyy', 'es').format(_selectedDate))!;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header/filtro alineado a la derecha
                Row(
                  children: [
                    Expanded(child: Container()),
                    ToggleButtons(
                      isSelected: [
                        _filtroPeriodo == 'semana',
                        _filtroPeriodo == 'mes',
                        _filtroPeriodo == 'día',
                      ],
                      onPressed: (i) {
                        setState(() {
                          _filtroPeriodo = ['semana', 'mes', 'día'][i];
                        });
                      },
                      children: const [
                        Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('semana')),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('mes')),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('día')),
                      ],
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        setState(() {
                          if (_filtroPeriodo == 'día') {
                            _selectedDate = _selectedDate.subtract(const Duration(days: 1));
                          } else if (_filtroPeriodo == 'semana') {
                            _selectedDate = _selectedDate.subtract(const Duration(days: 7));
                          } else {
                            _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, _selectedDate.day);
                          }
                        });
                      },
                    ),
                    Text(
                      fechaTexto,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        setState(() {
                          if (_filtroPeriodo == 'día') {
                            _selectedDate = _selectedDate.add(const Duration(days: 1));
                          } else if (_filtroPeriodo == 'semana') {
                            _selectedDate = _selectedDate.add(const Duration(days: 7));
                          } else {
                            _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, _selectedDate.day);
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      icon: const Icon(Icons.calendar_month),
                      label: const Text('Calendario'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              child: SizedBox(
                                width: 420,
                                height: 480,
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Seleccionar fecha', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () => Navigator.of(context).pop(),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        height: 360,
                                        child: _buildCleanCalendar(context),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Cards de actividades
                ...actividadesFiltradas.asMap().entries.map((entry) {
                  final i = entry.key;
                  final l = entry.value;
                  final fecha = l['fecha'] as DateTime;
                  final String tipo = l['tipo'];
                  final bool isExpanded = _expandedActivityIndex == i;
                  // Detalles y tablas por tipo
                  List<String> columnas = [];
                  List<List<String>> datos = [];
                  String titulo = tipo;
                  var iconoData = _laborIcons[tipo.replaceAll(' Muestra', '')] ?? {'icon': Icons.task, 'color': Colors.green[900]};
                  final dynamic icono = iconoData['icon'];
                  final Color? color = iconoData['color'];
                  final Color safeColor = (color ?? Colors.green[100]) ?? Colors.green;
                  if (tipo == 'Riego') {
                    columnas = ['Fecha', 'Sucursal', 'Cuartel', 'Equipo'];
                    datos = [
                      ['7 may 2025, 16:29:45', 'MAITEN GIGANTE', 'AUTUMN CRISP C 6...', 'Equipo 3'],
                      ['7 may 2025, 16:28:55', 'MAITEN GIGANTE', 'AUTUMN CRISP C 6...', 'Equipo 3'],
                      ['7 may 2025, 16:26:35', 'MAITEN GIGANTE', 'SWEET GLOBE C 2...', 'Equipo 2'],
                    ];
                  } else if (tipo == 'Conteo Poda Carozos') {
                    columnas = ['Conteo Planta', 'Ramillas', 'variación/pauta %', 'calidad %', 'Cajas / HA proyectadas'];
                    datos = [
                      ['120', '35', '5%', '98%', '250'],
                      ['110', '30', '3%', '95%', '230'],
                    ];
                  } else if (tipo == 'Conteo Poda Muestra Carozos') {
                    columnas = ['Conteo Planta', 'Ramillas'];
                    datos = [
                      ['60', '18'],
                      ['55', '15'],
                    ];
                  } else if (tipo == 'Conteo Poda Ciruela') {
                    columnas = ['Conteo Planta', 'Cm Lineal', 'variación/pauta %', 'calidad %', 'Cajas / HA proyectadas'];
                    datos = [
                      ['90', '120', '2%', '97%', '180'],
                      ['85', '110', '1%', '96%', '170'],
                    ];
                  } else if (tipo == 'Conteo Poda Muestra Ciruela') {
                    columnas = ['Conteo Planta', 'Cm Lineal'];
                    datos = [
                      ['45', '60'],
                      ['50', '65'],
                    ];
                  } else if (tipo == 'Conteo Poda Cerezas') {
                    columnas = ['Conteo Planta', 'Centros frutales', 'variación/pauta %', 'calidad %', 'Cajas / HA proyectadas'];
                    datos = [
                      ['60', '15', '4%', '92%', '90'],
                      ['65', '18', '5%', '93%', '95'],
                    ];
                  } else if (tipo == 'Conteo Poda Muestra Cerezas') {
                    columnas = ['Conteo Planta', 'Centros frutales'];
                    datos = [
                      ['30', '7'],
                      ['32', '8'],
                    ];
                  } else if (tipo == 'Conteo Poda Uvas') {
                    columnas = ['Conteo Planta', 'Promedio cargadores/planta', 'variación/pauta %', 'calidad %', 'Cajas / HA proyectadas'];
                    datos = [
                      ['200', '2.5', '3%', '99%', '400'],
                      ['210', '2.7', '2%', '98%', '420'],
                    ];
                  } else if (tipo == 'Conteo Poda Muestra Uvas') {
                    columnas = ['Conteo Planta', 'Promedio cargadores/planta'];
                    datos = [
                      ['100', '1.2'],
                      ['110', '1.3'],
                    ];
                  }
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: safeColor, width: 2)),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    if (icono is IconData)
                                      Icon(icono, color: color, size: 32)
                                    else if (icono is String)
                                      Text(icono, style: TextStyle(fontSize: 32, color: color)),
                                    const SizedBox(width: 10),
                                    Text(
                                      titulo,
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: color ?? Colors.green[900],
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: Colors.grey[600]),
                                onPressed: () {
                                  setState(() {
                                    _expandedActivityIndex = isExpanded ? null : i;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        if (isExpanded)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: safeColor.withOpacity(0.07),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: safeColor, width: 1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Detalle', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: safeColor)),
                                    const SizedBox(height: 12),
                                    Table(
                                      columnWidths: {
                                        for (int i = 0; i < columnas.length; i++) i: const FlexColumnWidth(2),
                                      },
                                      border: TableBorder(horizontalInside: BorderSide(color: safeColor.withOpacity(0.5))),
                                      children: [
                                        TableRow(
                                          decoration: BoxDecoration(color: safeColor.withOpacity(0.25)),
                                          children: [
                                            for (final col in columnas)
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                                child: Text(col, style: TextStyle(fontWeight: FontWeight.bold, color: safeColor)),
                                              ),
                                          ],
                                        ),
                                        ...datos.map((fila) => TableRow(
                                              decoration: BoxDecoration(color: Colors.white),
                                              children: [
                                                for (final celda in fila)
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                                    child: Text(celda, style: const TextStyle(color: Colors.black87)),
                                                  ),
                                              ],
                                            )),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {},
                                          child: const Text('Ver Detalle'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
                if (actividadesFiltradas.isEmpty)
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text('No hay actividades para el periodo seleccionado.', style: Theme.of(context).textTheme.bodyLarge),
                    ),
                  ),
              ],
            ),
          ),
        );
      } catch (e, st) {
        print('Error en Home: $e\n$st');
        return Center(
          child: Text(
            'Ocurrió un error al mostrar el Home:\n$e',
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        );
      }
    }
    // Handle submenús de Labores
    if (_selectedMenu!.title == 'Carozo' || _selectedMenu!.title == 'Cereza' || _selectedMenu!.title == 'Ciruela' || _selectedMenu!.title == 'Uva') {
      return LaboresEspecieScreen(especie: _selectedMenu!.title);
    }
    // Handle sub-submenús de Parámetros Generales
    const parametros = [
      'Centro de costos', 'Variedad', 'Cuarteles', 'Temporada', 'Labores', 'Tipo de Planta'
    ];
    if (parametros.contains(_selectedMenu!.title)) {
      return ParametrosGeneralesScreen(parametro: _selectedMenu!.title);
    }
    // Default case
    return Center(
      child: Text(
        'Módulo en desarrollo: ${_selectedMenu!.title}',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.black87),
      ),
    );
  }

  int _getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysOffset = firstDayOfYear.weekday - 1;
    final firstMonday = firstDayOfYear.subtract(Duration(days: daysOffset));
    final diff = date.difference(firstMonday).inDays;
    return (diff / 7).ceil() + 1;
  }

  Widget _buildCleanCalendar(BuildContext context) {
    final DateTime firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final DateTime lastDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    final int daysInMonth = lastDayOfMonth.day;
    final int startWeekday = firstDayOfMonth.weekday % 7; // 0=Domingo, 1=Lunes...
    final today = DateTime.now();

    // Mapear días a labores
    Map<int, List<String>> laboresPorDia = {};
    for (var l in _labores) {
      if (l['fecha'].year == _selectedDate.year && l['fecha'].month == _selectedDate.month) {
        laboresPorDia.putIfAbsent(l['fecha'].day, () => []).add(l['tipo']);
      }
    }

    List<Widget> dayWidgets = [];
    // Días de la semana
    const weekDays = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    for (final d in weekDays) {
      dayWidgets.add(Center(child: Text(d, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))));
    }
    // Celdas vacías antes del primer día
    for (int i = 0; i < startWeekday; i++) {
      dayWidgets.add(Container());
    }
    // Días del mes
    for (int day = 1; day <= daysInMonth; day++) {
      final thisDay = DateTime(_selectedDate.year, _selectedDate.month, day);
      final bool isSelected = thisDay.year == _selectedDate.year && thisDay.month == _selectedDate.month && thisDay.day == _selectedDate.day;
      final bool isToday = thisDay.year == today.year && thisDay.month == today.month && thisDay.day == today.day;
      final labores = laboresPorDia[day] ?? [];
      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() => _selectedDate = thisDay);
            Navigator.of(context).pop();
          },
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryLight
                  : isToday
                      ? AppTheme.primaryLight.withOpacity(0.2)
                      : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: isSelected
                  ? Border.all(color: AppTheme.primaryDark, width: 2)
                  : Border.all(color: Colors.grey[300]!, width: 1),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : isToday
                            ? AppTheme.primaryDark
                            : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
                if (labores.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final tipo in labores.take(2))
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            child: Icon(
                              _laborMaterialIcons[tipo] ?? Icons.task,
                              size: 14,
                              color: AppTheme.primaryLight,
                            ),
                          ),
                        if (labores.length > 2)
                          const Padding(
                            padding: EdgeInsets.only(left: 2),
                            child: Text('+', style: TextStyle(fontSize: 10, color: Colors.grey)),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }
    // Completa la última fila si es necesario
    while (dayWidgets.length % 7 != 0) {
      dayWidgets.add(Container());
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                setState(() {
                  if (_selectedDate.month == 1) {
                    _selectedDate = DateTime(_selectedDate.year - 1, 12, 1);
                  } else {
                    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
                  }
                });
              },
            ),
            Row(
              children: [
                DropdownButton<int>(
                  value: _selectedDate.month,
                  underline: const SizedBox(),
                  onChanged: (int? newMonth) {
                    if (newMonth != null) {
                      setState(() {
                        _selectedDate = DateTime(_selectedDate.year, newMonth, 1);
                      });
                    }
                  },
                  items: List.generate(12, (i) => i + 1)
                      .map((month) => DropdownMenuItem(
                            value: month,
                            child: Text(
                              toBeginningOfSentenceCase(DateFormat('MMMM', 'es').format(DateTime(2000, month)))!,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: _selectedDate.year,
                  underline: const SizedBox(),
                  onChanged: (int? newYear) {
                    if (newYear != null) {
                      setState(() {
                        _selectedDate = DateTime(newYear, _selectedDate.month, 1);
                      });
                    }
                  },
                  items: List.generate(11, (i) => _selectedDate.year - 5 + i)
                      .map((year) => DropdownMenuItem(
                            value: year,
                            child: Text('$year', style: Theme.of(context).textTheme.titleLarge),
                          ))
                      .toList(),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                setState(() {
                  if (_selectedDate.month == 12) {
                    _selectedDate = DateTime(_selectedDate.year + 1, 1, 1);
                  } else {
                    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
                  }
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: GridView.builder(
            clipBehavior: Clip.hardEdge,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.1,
            ),
            itemCount: dayWidgets.length,
            itemBuilder: (context, index) => dayWidgets[index],
            physics: const AlwaysScrollableScrollPhysics(),
            primary: false,
            shrinkWrap: false,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomHeader(
        userName: 'Usuario Demo',
        selectedBranch: _selectedBranch,
        selectedSpecies: _selectedSpecies,
        branches: _branches,
        species: _species,
        onBranchChanged: (value) => setState(() => _selectedBranch = value),
        onSpeciesChanged: (value) => setState(() => _selectedSpecies = value),
        onProfileTap: () {
          // TODO: Implement profile view
        },
        onLogoutTap: () {
          // TODO: Implement logout
        },
      ),
      drawer: CustomDrawer(
        isAdmin: _isAdmin,
        onItemSelected: _onMenuItemSelected,
        selectedMenu: _selectedMenu,
      ),
      body: _buildDashboard(),
    );
  }
} 