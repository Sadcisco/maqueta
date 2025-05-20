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
import 'riego_general_screen.dart';
import 'riego_chequeo_screen.dart';
import 'dart:math';
import 'rendimiento_tarifas_screen.dart';

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
  bool _mostrarTablaDetalle = false;

  void _onMenuItemSelected(MenuItem item) {
    print('Seleccionado: \\${item.title}');
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
    if (_selectedMenu!.title == 'Riego') {
      return const RiegoGeneralScreen();
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

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF6FBF7), Color(0xFFE8F5E9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                  // KPIs tipo dashboard
                Wrap(
                  spacing: 18,
                  runSpacing: 12,
                    children: [
                    _KpiCard(
                      title: 'Desajuste Total Acumulado CLP',
                      value: '3 mill.!',
                      valueColor: Colors.red,
                        bgColor: const Color(0xFFFDEDED),
                        icon: Icons.trending_down,
                        borderColor: Colors.red,
                    ),
                    _KpiCard(
                      title: 'Desajuste % Total Acumulado',
                      value: '0,26 %°',
                        valueColor: Colors.yellow[800]!,
                        bgColor: const Color(0xFFFFF8E1),
                        icon: Icons.percent,
                        borderColor: Colors.yellow[800]!,
                    ),
                    _KpiCard(
                      title: 'Desajuste % Proyectado Temp',
                      value: '0,25 %°',
                        valueColor: Colors.yellow[800]!,
                        bgColor: const Color(0xFFFFF8E1),
                        icon: Icons.timeline,
                        borderColor: Colors.yellow[800]!,
                    ),
                    _KpiCard(
                      title: 'Disponibilidad Real Ppto Temp CLP',
                      value: '34 mill.!',
                        valueColor: Colors.green[700]!,
                        bgColor: const Color(0xFFE8F5E9),
                        icon: Icons.account_balance_wallet,
                        borderColor: Colors.green[700]!,
                    ),
                    _KpiCard(
                      title: 'Ppto Nominal Prox Meses CLP',
                      value: '38 mill.',
                        valueColor: Colors.green[900]!,
                        bgColor: const Color(0xFFE8F5E9),
                        icon: Icons.calendar_month,
                        borderColor: Colors.green[900]!,
                    ),
                  ],
                ),
                  const SizedBox(height: 28),
                  // Filtros con chips modernos
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.green[100]!),
                      ),
                      child: ToggleButtons(
                        borderRadius: BorderRadius.circular(16),
                      isSelected: [
                          _filtroPeriodo == 'día',
                        _filtroPeriodo == 'semana',
                        _filtroPeriodo == 'mes',
                      ],
                        onPressed: (int index) {
                        setState(() {
                            if (index == 0) _filtroPeriodo = 'día';
                            if (index == 1) _filtroPeriodo = 'semana';
                            if (index == 2) _filtroPeriodo = 'mes';
                        });
                      },
                        color: Colors.green[800],
                        selectedColor: Colors.white,
                        fillColor: AppTheme.primaryLight,
                        borderColor: Colors.transparent,
                        selectedBorderColor: Colors.green[400],
                        constraints: const BoxConstraints(minWidth: 70, minHeight: 38),
                      children: const [
                          Text('Día', style: TextStyle(fontWeight: FontWeight.w600)),
                          Text('Semana', style: TextStyle(fontWeight: FontWeight.w600)),
                          Text('Mes', style: TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
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
                        _filtroPeriodo == 'día'
                            ? toBeginningOfSentenceCase(DateFormat('EEEE, d MMMM', 'es').format(_selectedDate))!
                            : _filtroPeriodo == 'semana'
                                ? 'Semana ${_getWeekNumber(_selectedDate)}'
                                : toBeginningOfSentenceCase(DateFormat('MMMM yyyy', 'es').format(_selectedDate))!,
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
                        style: TextButton.styleFrom(foregroundColor: AppTheme.primaryDark),
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
                  const SizedBox(height: 28),
                  // Cards de actividades modernas
                ...actividadesFiltradas.asMap().entries.map((entry) {
                  final i = entry.key;
                  final l = entry.value;
                  final fecha = l['fecha'] as DateTime;
                  final String tipo = l['tipo'];
                  final bool isExpanded = _expandedActivityIndex == i;
                    final int eficiencia = tipo == 'Riego' ? 88 : 92;
                    final String calidad = tipo == 'Riego' ? 'Media calidad' : 'Alta calidad';
                    final bool alerta = eficiencia < 90;
                  var iconoData = _laborIcons[tipo.replaceAll(' Muestra', '')] ?? {'icon': Icons.task, 'color': Colors.green[900]};
                  final dynamic icono = iconoData['icon'];
                  final Color? color = iconoData['color'];
                    String detalle = tipo == 'Riego' ? '45 lts/persona' : '15 plantas/persona';
                    String cuarteles = tipo == 'Riego' ? 'Cuartel 1' : 'Cuartel 2, Cuartel 3';
                  return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: BorderSide(color: color ?? Colors.green[100]!, width: 2)),
                      margin: const EdgeInsets.only(bottom: 24),
                      color: Colors.white,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            // Info principal a la izquierda
                              Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                  children: [
                                    if (icono is IconData)
                                        Icon(icono, color: color, size: 32),
                                      if (icono is String)
                                      Text(icono, style: TextStyle(fontSize: 32, color: color)),
                                    const SizedBox(width: 10),
                                    Text(
                                        tipo,
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: color ?? Colors.green[900],
                                          ),
                                    ),
                                  ],
                                ),
                                  const SizedBox(height: 6),
                                  Text(detalle, style: const TextStyle(fontSize: 15, color: Colors.black87)),
                                  Text('Cuarteles: $cuarteles', style: const TextStyle(fontSize: 15, color: Colors.black54)),
                            ],
                          ),
                        ),
                            // Indicadores a la derecha
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Badge de eficiencia
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                    color: eficiencia >= 90 ? Colors.green[50] : Colors.red[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: eficiencia >= 90 ? Colors.green : Colors.red, width: 1),
                                  ),
                                  child: Text('$eficiencia% eficiencia', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: eficiencia >= 90 ? Colors.green[800] : Colors.red)),
                                ),
                                const SizedBox(height: 4),
                                // Badge de calidad
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: calidad == 'Alta calidad' ? Colors.green[50] : Colors.yellow[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: calidad == 'Alta calidad' ? Colors.green : Colors.yellow[800]!, width: 1),
                                  ),
                                  child: Text(calidad, style: TextStyle(fontSize: 14, color: calidad == 'Alta calidad' ? Colors.green[800] : Colors.yellow[800])),
                                ),
                                if (alerta)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 6),
                                    child: Icon(Icons.notifications_active, color: Colors.red, size: 22),
                                  ),
                                        TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _expandedActivityIndex = isExpanded ? null : i;
                                    });
                                  },
                                  style: TextButton.styleFrom(foregroundColor: AppTheme.primaryDark),
                                  child: Text(isExpanded ? 'Ocultar detalle' : 'Ir a detalle'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                    ),
                  );
                }),
                  // ... resto de la vista ...
                ],
              ),
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
    if (_selectedMenu!.title == 'Chequeo Riego') {
      return const ChequeoRiegoScreen();
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
    if (_selectedMenu!.title == 'Planificación') {
      return const PresupuestoPlanificacionScreen();
    }
    if (_selectedMenu!.title == 'Control Presupuestario') {
      // KPIs simulados
      final kpis = [
        {'label': 'Desajuste CLP Total Acumulado', 'value': '13,51 mill.!', 'color': Colors.red, 'sub': ''},
        {'label': 'Desajuste % Total Acumulado', 'value': '1,67 %°', 'color': Colors.yellow[700], 'sub': ''},
        {'label': 'Desajuste % Proyectado Temp', 'value': '1,62 %°', 'color': Colors.yellow[700], 'sub': ''},
        {'label': 'Ppto Nominal Prox Meses', 'value': '21,99 mill.', 'color': Colors.green[700], 'sub': 'Ahorro Mensual Contratistas'},
        {'label': 'Disponibilidad Real Ppto Temporada', 'value': '8,48 mill.!', 'color': Colors.green[400], 'sub': ''},
      ];
      // Datos para gráficos
      final labores = ['ADMINISTRACION', 'RALEO', 'SACAR SIERPES', 'JEFE DE CAMPO', 'COSECHA', 'AMARRAR'];
      final desajustes = [16, 16, 15, -11, -15, -19];
      final meses = ['mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre', 'enero', 'febrero', 'marzo', 'abril'];
      final controlMensual = [100, 120, 80, 110, 140, 160, 180, 200, 170, 150, 130, 110];
      final difMensual = [0, 5, 0, 0, -20, 8, 27, 18, 0, 0, 0, 0];
      final difMeses = [0, 5, 0, 0, -20, 8, 27, 18, 0, 0, 0, 0];
      // Tabla detalle mano de obra
      final tabla = [
        {'labor': 'ADMINISTRACION', 'costo': '63.921.860', 'ppto': '47.430.000', 'dif': '16.491.860', 'desajuste': '34,8%', 'costo_ha': '936', 'ppto_ha': '698', 'dif_ha': '238', 'ppto_fut': '3.570.000', 'ppto_temp': '51.000.000', 'disp': '-12.921.860'},
        {'labor': 'RALEO', 'costo': '53.887.558', 'ppto': '38.222.186', 'dif': '15.665.372', 'desajuste': '41,0%', 'costo_ha': '1.096', 'ppto_ha': '777', 'dif_ha': '319', 'ppto_fut': '0', 'ppto_temp': '38.222.186', 'disp': '-15.665.372'},
        {'labor': 'SACAR SIERPES', 'costo': '26.037.786', 'ppto': '11.099.753', 'dif': '14.938.033', 'desajuste': '134,6%', 'costo_ha': '978', 'ppto_ha': '161', 'dif_ha': '817', 'ppto_fut': '0', 'ppto_temp': '11.099.753', 'disp': '-14.938.033'},
        {'labor': 'HACER ESTRUCTURAS', 'costo': '9.687.095', 'ppto': '0', 'dif': '9.687.095', 'desajuste': '100,0%', 'costo_ha': '376', 'ppto_ha': '0', 'dif_ha': '376', 'ppto_fut': '0', 'ppto_temp': '0', 'disp': '-9.687.095'},
        {'labor': 'PODA EN VERDE', 'costo': '52.849.723', 'ppto': '43.718.385', 'dif': '9.131.338', 'desajuste': '20,9%', 'costo_ha': '768', 'ppto_ha': '350', 'dif_ha': '350', 'ppto_fut': '0', 'ppto_temp': '43.718.385', 'disp': '-9.131.338'},
        {'labor': 'RALEO DE YEMAS', 'costo': '8.224.870', 'ppto': '0', 'dif': '8.224.870', 'desajuste': '100,0%', 'costo_ha': '503', 'ppto_ha': '0', 'dif_ha': '503', 'ppto_fut': '3.240.000', 'ppto_temp': '0', 'disp': '-8.224.870'},
        // ... más filas simuladas ...
      ];
      // Filtros simulados
      final especies = ['CEREZAS', 'CIRUELAS', 'DAMASCO', 'DURAZNOS', 'NECTARINES', 'SIN ESPECIE', 'UVA'];
      final ceCoDesc = ['795 P3 MA CH', '796 P3 MA CH', 'ALLISON P 28 CHOC', 'ANGELENO 20-12 C CHOC', 'APR 1 P3 MA CH'];
      final laboresFiltro = ['ADMINISTRACION', 'AMARRA D FORM Y DESBROTA', 'AMARRA DE FORMACION', 'AMARRAR', 'APLICAR AGROQUIMICO', 'APLICAR HERBICIDA'];

      return SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Panel principal
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // KPIs
                  Wrap(
                    spacing: 18,
                    runSpacing: 12,
                    children: kpis.map((k) => _KpiCard(
                      title: k['label'] as String, 
                      value: k['value'] as String,
                      valueColor: k['color'] as Color, 
                      bgColor: Colors.grey[200]!,
                      icon: Icons.trending_up,
                      borderColor: Colors.green[700]!
                    )).toList(),
                  ),
                  const SizedBox(height: 12),
                  // Gráficos pequeños alineados horizontalmente
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gráfico de barras horizontales (más pequeño y con valores a la derecha)
                      Expanded(
                        child: Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Mayores Desajustes por Labor MO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                SizedBox(
                                  height: 80,
                                  child: Stack(
                                    children: [
                                      BarChart(
                                        BarChartData(
                                          alignment: BarChartAlignment.spaceAround,
                                          maxY: 20,
                                          minY: -20,
                                          barTouchData: BarTouchData(enabled: false),
                                          titlesData: FlTitlesData(
                                            leftTitles: AxisTitles(
                                              sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => Text('${v.toInt()} mill.', style: const TextStyle(fontSize: 8))),
                                            ),
                                            bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, meta) {
                                                int idx = v.toInt();
                                                return idx >= 0 && idx < labores.length ? Text(labores[idx], style: const TextStyle(fontSize: 8)) : const SizedBox();
                                              }),
                                            ),
                                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                          ),
                                          gridData: FlGridData(show: true),
                                          barGroups: List.generate(labores.length, (i) => BarChartGroupData(x: i, barRods: [
                                            BarChartRodData(toY: desajustes[i].toDouble(), color: desajustes[i] < 0 ? Colors.red : Colors.green, width: 8, borderRadius: BorderRadius.circular(2)),
                                          ])),
                                        ),
                                      ),
                                      // Valores a la derecha de cada barra
                                      Positioned.fill(
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Column(
                                              children: List.generate(labores.length, (i) {
                                                return Expanded(
                                                  child: Row(
                                                    children: [
                                                      const SizedBox(width: 4),
                                                      Expanded(child: Container()),
                                                      Text('${desajustes[i] > 0 ? '' : ''}${desajustes[i]} mill.', style: TextStyle(fontSize: 9, color: desajustes[i] < 0 ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),
                                                      const SizedBox(width: 2),
                                                    ],
                                                  ),
                                                );
                                              }),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Gráfico de control mensual (barras y línea superpuesta, más pequeño)
                      Expanded(
                        child: Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Control Presupuestario Mensual', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                SizedBox(
                                  height: 80,
                                  child: Stack(
                                    children: [
                                      BarChart(
                                        BarChartData(
                                          alignment: BarChartAlignment.spaceAround,
                                          maxY: 220,
                                          minY: 0,
                                          barTouchData: BarTouchData(enabled: false),
                                          titlesData: FlTitlesData(
                                            leftTitles: AxisTitles(
                                              sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => Text('${v.toInt()} mill.', style: const TextStyle(fontSize: 8))),
                                            ),
                                            bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, meta) {
                                                int idx = v.toInt();
                                                return idx >= 0 && idx < meses.length ? Text(meses[idx], style: const TextStyle(fontSize: 8)) : const SizedBox();
                                              }),
                                            ),
                                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                          ),
                                          gridData: FlGridData(show: true),
                                          barGroups: List.generate(meses.length, (i) => BarChartGroupData(x: i, barRods: [
                                            BarChartRodData(toY: controlMensual[i].toDouble(), color: Colors.green[700], width: 8, borderRadius: BorderRadius.circular(2)),
                                          ])),
                                        ),
                                      ),
                                      // Línea de diferencia superpuesta
                                      Positioned.fill(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                                          child: LineChart(
                                            LineChartData(
                                              minY: -40,
                                              maxY: 220,
                                              titlesData: FlTitlesData(show: false),
                                              gridData: FlGridData(show: false),
                                              lineBarsData: [
                                                LineChartBarData(
                                                  spots: List.generate(meses.length, (i) => FlSpot(i.toDouble(), controlMensual[i].toDouble() + difMeses[i].toDouble())),
                                                  isCurved: true,
                                                  color: Colors.orange,
                                                  barWidth: 1.5,
                                                  dotData: FlDotData(show: false),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Tablas debajo, ocupando todo el ancho, con fuente más pequeña
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Detalle Costos Mano de Obra', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowColor: MaterialStateProperty.all(Colors.green[700]),
                              headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                              dataRowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)) {
                                  return Colors.green[100];
                                }
                                return null;
                              }),
                              columns: [
                                'Labor', 'Costo Acumulado CLP', 'Ppto Acumulado CLP', 'Diferencia CLP', 'Desajuste %', 'Costo/Ha USD', 'Ppto/Ha USD', 'Dif/Ha USD', 'Ppto Futuro CLP', 'Presupuesto Temp CLP', 'Disponibilidad CLP'
                              ].map((c) => DataColumn(label: Text(c, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10)))).toList(),
                              rows: tabla.asMap().entries.map((entry) {
                                final i = entry.key;
                                final row = entry.value;
                                final isTotal = i == tabla.length - 1;
                                return DataRow(
                                  color: MaterialStateProperty.all(i % 2 == 0 ? Colors.grey[50] : Colors.white),
                                  cells: row.entries.map((e) {
                                    final isRed = e.key == 'Diferencia CLP' || e.key == 'Desajuste %';
                                    return DataCell(Container(
                                      color: isRed && double.tryParse(row['Desajuste %']?.toString() ?? '0') != null && double.parse(row['Desajuste %']?.toString() ?? '0') > 100 ? Colors.red[100] : null,
                                      child: Text(e.value.toString(), style: TextStyle(fontSize: 10, color: isRed ? Colors.red[900] : Colors.black, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
                                    ));
                                  }).toList(),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Filtros a la derecha
            const SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ESPECIES', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...especies.map((e) => CheckboxListTile(value: false, onChanged: null, title: Text(e, style: const TextStyle(fontSize: 13)))),
                  const SizedBox(height: 12),
                  const Text('Descripción CeCo', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...ceCoDesc.map((e) => CheckboxListTile(value: false, onChanged: null, title: Text(e, style: const TextStyle(fontSize: 13)))),
                  const SizedBox(height: 12),
                  const Text('Labor', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...laboresFiltro.map((e) => CheckboxListTile(value: false, onChanged: null, title: Text(e, style: const TextStyle(fontSize: 13)))),
                ],
              ),
            ),
          ],
        ),
      );
    }
    if (_selectedMenu!.title == 'Estado Tarjas' || _selectedMenu!.title == 'Estado tarja') {
      return const EstadoTarjasScreen();
    }
    if (_selectedMenu!.title == 'Rendimiento y tarifas') {
      return const RendimientoTarifasScreen();
    }
    if (_selectedMenu!.title == 'Faenas') {
      // KPIs simulados para Faenas
      final kpis = [
        {'label': 'Labores Pendientes', 'value': '24', 'color': Colors.orange[700], 'chartData': [FlSpot(0, 30), FlSpot(1, 25), FlSpot(2, 24)]} as Map<String, dynamic>,
        {'label': 'Labores en Ejecución', 'value': '12', 'color': Colors.blue[700], 'chartData': [FlSpot(0, 8), FlSpot(1, 10), FlSpot(2, 12)]} as Map<String, dynamic>,
        {'label': 'Labores Finalizadas', 'value': '156', 'color': Colors.green[700], 'chartData': [FlSpot(0, 120), FlSpot(1, 140), FlSpot(2, 156)]} as Map<String, dynamic>,
        {'label': 'Rendimiento Promedio', 'value': '92%', 'color': Colors.green[400], 'chartData': [FlSpot(0, 85), FlSpot(1, 89), FlSpot(2, 92)]} as Map<String, dynamic>,
        {'label': 'Personal en Campo', 'value': '45', 'color': Colors.purple[700], 'chartData': [FlSpot(0, 40), FlSpot(1, 42), FlSpot(2, 45)]} as Map<String, dynamic>,
      ];

      // Datos para gráficos
      final tiposLabores = ['Poda', 'Riego', 'Fertilización', 'Cosecha', 'Control Plagas', 'Mantenimiento'];
      final horasPorLabor = [120, 85, 45, 200, 60, 75];
      final eficienciaPorLabor = [95, 88, 92, 85, 90, 87];
      final meses = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
      final laboresPorMes = [45, 52, 48, 55, 60, 58, 62, 65, 70, 68, 72, 75];
      final personalPorMes = [35, 38, 40, 42, 45, 43, 45, 47, 48, 46, 45, 45];

      return DashboardScreen(
        title: 'Faenas',
        subtitle: 'Resumen de actividades y labores agrícolas',
        children: [
          // KPIs
          Wrap(
            spacing: 18,
            runSpacing: 12,
            children: kpis.map((k) => DashboardCard(
              title: k['label'] as String,
              value: k['value'] as String,
              valueColor: k['color'] as Color,
              chartData: k['chartData'] as List<FlSpot>,
            )).toList(),
          ),
          const SizedBox(height: 24),
          // Gráficos
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gráfico de horas por tipo de labor
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Horas de Trabajo por Tipo de Labor', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: 250,
                              minY: 0,
                              barTouchData: BarTouchData(enabled: false),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => Text('${v.toInt()} hrs', style: const TextStyle(fontSize: 10))),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, meta) {
                                    int idx = v.toInt();
                                    return idx >= 0 && idx < tiposLabores.length ? Text(tiposLabores[idx], style: const TextStyle(fontSize: 10)) : const SizedBox();
                                  }),
                                ),
                                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              gridData: FlGridData(show: true),
                              barGroups: List.generate(tiposLabores.length, (i) => BarChartGroupData(x: i, barRods: [
                                BarChartRodData(toY: horasPorLabor[i].toDouble(), color: Colors.blue[700], width: 16, borderRadius: BorderRadius.circular(4)),
                              ])),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Gráfico de labores y personal por mes
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Evolución de Labores y Personal por Mes', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: LineChart(
                            LineChartData(
                              minY: 0,
                              maxY: 100,
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => Text('${v.toInt()}', style: const TextStyle(fontSize: 10))),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, meta) {
                                    int idx = v.toInt();
                                    return idx >= 0 && idx < meses.length ? Text(meses[idx], style: const TextStyle(fontSize: 10)) : const SizedBox();
                                  }),
                                ),
                                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              gridData: FlGridData(show: true),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: List.generate(meses.length, (i) => FlSpot(i.toDouble(), laboresPorMes[i].toDouble())),
                                  isCurved: true,
                                  color: Colors.green[700],
                                  barWidth: 3,
                                  dotData: FlDotData(show: true),
                                ),
                                LineChartBarData(
                                  spots: List.generate(meses.length, (i) => FlSpot(i.toDouble(), personalPorMes[i].toDouble())),
                                  isCurved: true,
                                  color: Colors.blue[700],
                                  barWidth: 3,
                                  dotData: FlDotData(show: true),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(width: 16, height: 8, color: Colors.green[700]),
                            const SizedBox(width: 4),
                            const Text('Labores', style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 16),
                            Container(width: 16, height: 8, color: Colors.blue[700]),
                            const SizedBox(width: 4),
                            const Text('Personal', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Gráfico de eficiencia por labor
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rendimiento por Tipo de Labor', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 100,
                        minY: 0,
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => Text('${v.toInt()}%', style: const TextStyle(fontSize: 10))),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, meta) {
                              int idx = v.toInt();
                              return idx >= 0 && idx < tiposLabores.length ? Text(tiposLabores[idx], style: const TextStyle(fontSize: 10)) : const SizedBox();
                            }),
                          ),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: FlGridData(show: true),
                        barGroups: List.generate(tiposLabores.length, (i) => BarChartGroupData(x: i, barRods: [
                          BarChartRodData(toY: eficienciaPorLabor[i].toDouble(), color: Colors.orange[700], width: 16, borderRadius: BorderRadius.circular(4)),
                        ])),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
    if (_selectedMenu!.title == 'Estimación') {
      // Datos simulados para los filtros
      final sucursales = ['Sucursal 1', 'Sucursal 2', 'Sucursal 3'];
      final variedades = ['Nectarines', 'Uvas', 'Duraznos', 'Ciruelas', 'Cerezas'];
      final especies = ['Especie 1', 'Especie 2'];
      final cuarteles = ['Cuartel 1', 'Cuartel 2'];
      String sucursalSel = sucursales[0];
      String variedadSel = variedades[0];
      String especieSel = especies[0];
      String cuartelSel = cuarteles[0];

      // KPIs principales
      final kpisFruta = [
        {'label': 'NECTARINES', 'value': '785.068'},
        {'label': 'UVAS', 'value': '772.040'},
        {'label': 'DURAZNOS', 'value': '272.729'},
        {'label': 'CIRUELAS', 'value': '168.426'},
        {'label': 'CEREZAS', 'value': '115.620'},
      ];
      // KPIs secundarios
      final kpisSec = [
        {'label': 'CAJAS ESTIMADAS PRESUPUESTO', 'value': '2.122.676'},
        {'label': '% VARIACIÓN CAJAS PROYECTADAS', 'value': '12,25%', 'color': Colors.green},
        {'label': 'CAJAS PROYECTADAS', 'value': '2.382.786'},
        {'label': '% CUARTELES CON PROYECCIÓN', 'value': '95%', 'color': Colors.green},
      ];
      // Datos tabla detalle
      final detalle = [
        {
          'cuartel': 'ANGELENO B 2 A SF',
          'presupuesto': '6.000',
          'postraleo': '2.500',
          'proyectadas': '2.653',
          'totales': '7.190',
          'variacion': '-56%'
        },
        {
          'cuartel': 'ARTIC RED B 8 PC',
          'presupuesto': '5.000',
          'postraleo': '2.500',
          'proyectadas': '4.588',
          'totales': '25.463',
          'variacion': '-8%'
        },
      ];

      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Filtros superiores
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: sucursalSel,
                    items: sucursales.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (_) {},
                    isExpanded: true,
                    hint: const Text('Sucursal'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    value: variedadSel,
                    items: variedades.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (_) {},
                    isExpanded: true,
                    hint: const Text('Variedad'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    value: especieSel,
                    items: especies.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (_) {},
                    isExpanded: true,
                    hint: const Text('Especie'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    value: cuartelSel,
                    items: cuarteles.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (_) {},
                    isExpanded: true,
                    hint: const Text('Cuartel'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Título principal
            Center(
              child: Text(
                'CAJAS  ESTIMADAS PRESUPUESTO',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            // KPIs principales
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: kpisFruta.map((k) => Expanded(
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Column(
                      children: [
                        Text(k['label'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 6),
                        Text(k['value'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: 8),
            // KPIs secundarios
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: kpisSec.map((k) => Expanded(
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Column(
                      children: [
                        Text(k['label'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 6),
                        Text(
                          k['value'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: (k['color'] as Color?) ?? Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: 18),
            // Tabla de detalle
            Text('DETALLE ESTIMACIÓN CAJAS', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                  columns: const [
                    DataColumn(label: Text('CUARTEL')),
                    DataColumn(label: Text('CAJAS/Ha PRESUPUESTO')),
                    DataColumn(label: Text('CAJAS/Ha ESTIMADAS POSTRALEO')),
                    DataColumn(label: Text('CAJAS/Ha PROYECTADAS')),
                    DataColumn(label: Text('CAJAS TOTALES PROYECTADAS')),
                    DataColumn(label: Text('% VARIACIÓN PROYECCIÓN VS ESTIMACIÓN')),
                  ],
                  rows: detalle.map((d) => DataRow(cells: [
                    DataCell(Text(d['cuartel']!)),
                    DataCell(Text(d['presupuesto']!)),
                    DataCell(Text(d['postraleo']!)),
                    DataCell(Text(d['proyectadas']!)),
                    DataCell(Text(d['totales']!)),
                    DataCell(Text(d['variacion']!, style: TextStyle(color: d['variacion']!.contains('-') ? Colors.red : Colors.green))),
                  ])).toList(),
                ),
              ),
            ),
          ],
        ),
      );
    }
    if (_selectedMenu!.title == 'Producción') {
      // Filtros simulados
      final sucursales = ['MAITEN GIGANTE', 'CULLIPEUMO', 'HOSPITAL', 'SANTA VICTORIA'];
      final especies = ['Durazno', 'Nectarina', 'Ciruela', 'Cereza', 'Uva'];
      final variedades = ['AUTUMN CRISP', 'ALLISON', 'PRISTINE', 'CRIMSON'];
      final edades = ['1 año', '2 años', '3 años', '4 años'];
      final cuarteles = ['AUTUMN CRISP C 62 MG', 'ALLISON CULLIP', 'PRISTINE C 28 HO'];
      final estados = ['COSECHADO', 'EN PROCESO', 'PENDIENTE'];
      String sucursalSel = sucursales[0];
      String especieSel = especies[0];
      String variedadSel = variedades[0];
      String edadSel = edades[0];
      String cuartelSel = cuarteles[0];
      String estadoSel = estados[0];

      // KPIs simulados
      final kpis = [
        {'label': 'CAJAS DURAZNOS', 'value': '263.561', 'var': '-1.8%', 'color': Colors.red},
        {'label': 'CAJAS NECTARINES', 'value': '810.698', 'var': '+6.8%', 'color': Colors.green},
        {'label': 'CAJAS CIRUELAS', 'value': '157.150', 'var': '+9.3%', 'color': Colors.green},
        {'label': 'CAJAS CEREZAS', 'value': '176.180', 'var': '+41.8%', 'color': Colors.green},
        {'label': 'CAJAS UVAS', 'value': '797.120', 'var': '+4.1%', 'color': Colors.green},
        {'label': 'CAJAS TOTALES', 'value': '2.204.708', 'var': '+6.9%', 'color': Colors.green},
      ];

      // Tabla detalle diario cosechas
      final tablaCosechas = [
        {'sucursal': 'MAITEN GIGANTE', 'cuartel': 'AUTUMN CRISP C 62 MG', 'fecha': '4 abr 2025', 'lotes': '46', 'kg': '16.016', 'pesaje': '98%', 'despacho': '0%'},
        {'sucursal': 'CULLIPEUMO', 'cuartel': 'ALLISON CULLIP', 'fecha': '4 abr 2025', 'lotes': '179', 'kg': '58.435', 'pesaje': '49%', 'despacho': '0%'},
        {'sucursal': 'MAITEN GIGANTE', 'cuartel': 'AUTUMN CRISP C 62 MG', 'fecha': '3 abr 2025', 'lotes': '257', 'kg': '87.288', 'pesaje': '69%', 'despacho': '0%'},
        {'sucursal': 'HOSPITAL', 'cuartel': 'PRISTINE C 28 HO', 'fecha': '3 abr 2025', 'lotes': '70', 'kg': '21.988', 'pesaje': '100%', 'despacho': '100%'},
        {'sucursal': 'HOSPITAL', 'cuartel': 'PRISTINE C 21 HO', 'fecha': '3 abr 2025', 'lotes': '35', 'kg': '10.371', 'pesaje': '100%', 'despacho': '100%'},
        {'sucursal': 'SANTA VICTORIA', 'cuartel': 'CRIMSON C 12 A PA', 'fecha': '2 abr 2025', 'lotes': '1.850', 'kg': '100%', 'pesaje': '100%', 'despacho': '100%'},
        // ... más filas simuladas ...
      ];
      // Tabla detalle proceso de embalaje
      final tablaEmbalaje = [
        {'cuartel': 'ALLISON CULLIP', 'estado': 'COSECHADO', 'ultimo': '4 abr 2025', 'cajas_ha': '35.415', 'cajas_prod': '42.351', 'cajas_ha_prod': '5.381', 'var_est': '29%', 'emb_esp': '95%', 'emb_real': '94%', 'var_emb': '-1%'},
        {'cuartel': 'AUTUMN CRISP C 62 MG', 'estado': 'COSECHADO', 'ultimo': '4 abr 2025', 'cajas_ha': '17.000', 'cajas_prod': '21.891', 'cajas_ha_prod': '5.151', 'var_est': '29%', 'emb_esp': '95%', 'emb_real': '94%', 'var_emb': '-1%'},
        // ... más filas simuladas ...
      ];

      return SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Filtros superiores
            Row(
              children: [
                Expanded(child: DropdownButton<String>(value: sucursalSel, items: sucursales.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), onChanged: (_) {}, isExpanded: true, hint: const Text('SUCURSAL'))),
                const SizedBox(width: 8),
                Expanded(child: DropdownButton<String>(value: especieSel, items: especies.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (_) {}, isExpanded: true, hint: const Text('ESPECIE'))),
                const SizedBox(width: 8),
                Expanded(child: DropdownButton<String>(value: variedadSel, items: variedades.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(), onChanged: (_) {}, isExpanded: true, hint: const Text('VARIEDAD'))),
                const SizedBox(width: 8),
                Expanded(child: DropdownButton<String>(value: edadSel, items: edades.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (_) {}, isExpanded: true, hint: const Text('EDAD'))),
              ],
            ),
            const SizedBox(height: 8),
            // KPIs
            Center(
              child: Text('BALANCE CAJAS  CUARTELES TERMINADOS', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: kpis.map((k) => Expanded(
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Column(
                      children: [
                        Text(k['label'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(k['value'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        Text(k['var'] as String, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: k['color'] as Color)),
                      ],
                    ),
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: 8),
            // Filtros inferiores
            Row(
              children: [
                Expanded(child: DropdownButton<String>(value: cuartelSel, items: cuarteles.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), onChanged: (_) {}, isExpanded: true, hint: const Text('CUARTEL'))),
                const SizedBox(width: 8),
                Expanded(child: Card(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Text('FECHA', style: Theme.of(context).textTheme.bodyMedium)))),
              ],
            ),
            const SizedBox(height: 8),
            // Tabla detalle diario cosechas
            Text('DETALLE DIARIO COSECHAS', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            Card(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                  columns: const [
                    DataColumn(label: Text('SUCURSAL')),
                    DataColumn(label: Text('CUARTEL')),
                    DataColumn(label: Text('FECHA COSECHA')),
                    DataColumn(label: Text('LOTES CREADOS')),
                    DataColumn(label: Text('KG COSECHA')),
                    DataColumn(label: Text('% PESAJE')),
                    DataColumn(label: Text('% DESPACHO')),
                  ],
                  rows: tablaCosechas.map((d) => DataRow(cells: [
                    DataCell(Text(d['sucursal'] as String)),
                    DataCell(Text(d['cuartel'] as String)),
                    DataCell(Text(d['fecha'] as String)),
                    DataCell(Text(d['lotes'] as String)),
                    DataCell(Text(d['kg'] as String)),
                    DataCell(Text(d['pesaje'] as String)),
                    DataCell(Text(d['despacho'] as String)),
                  ])).toList(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: DropdownButton<String>(value: estadoSel, items: estados.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (_) {}, isExpanded: true, hint: const Text('ESTADO'))),
              ],
            ),
            const SizedBox(height: 8),
            // Tabla detalle proceso de embalaje
            Text('DETALLE PROCESO DE EMBALAJE', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            Card(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                  columns: const [
                    DataColumn(label: Text('CUARTEL')),
                    DataColumn(label: Text('ESTADO')),
                    DataColumn(label: Text('ULTIMO PROCESO')),
                    DataColumn(label: Text('Cajas estimadas/Ha')),
                    DataColumn(label: Text('Cajas producidas')),
                    DataColumn(label: Text('Cajas producidas/Ha')),
                    DataColumn(label: Text('% VARIACIÓN ESTIMACIÓN')),
                    DataColumn(label: Text('% Embalaje esperado')),
                    DataColumn(label: Text('% Embalaje')),
                    DataColumn(label: Text('% Variación embalaje')),
                  ],
                  rows: tablaEmbalaje.map((d) => DataRow(cells: [
                    DataCell(Text(d['cuartel'] as String)),
                    DataCell(Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: d['estado'] == 'COSECHADO' ? Colors.green[200] : Colors.orange[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(d['estado'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                    )),
                    DataCell(Text(d['ultimo'] as String)),
                    DataCell(Text(d['cajas_ha'] as String)),
                    DataCell(Text(d['cajas_prod'] as String)),
                    DataCell(Text(d['cajas_ha_prod'] as String)),
                    DataCell(Text(d['var_est'] as String)),
                    DataCell(Text(d['emb_esp'] as String)),
                    DataCell(Text(d['emb_real'] as String)),
                    DataCell(Text(d['var_emb'] as String)),
                  ])).toList(),
                ),
              ),
            ),
          ],
        ),
      );
    }
    if (_selectedMenu!.title == 'Usuarios') {
      return const AdminPermissionsScreen();
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

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;
  final Color bgColor;
  final IconData icon;
  final Color borderColor;
  const _KpiCard({required this.title, required this.value, required this.valueColor, required this.bgColor, required this.icon, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border(
          bottom: BorderSide(color: valueColor.withOpacity(0.7), width: 5),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icono con fondo circular translúcido
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: valueColor.withOpacity(0.13),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: valueColor.withOpacity(0.7), size: 28),
          ),
          const SizedBox(width: 16),
          // Texto y valor
          Expanded(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[900],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: valueColor.withOpacity(0.92),
                    letterSpacing: -1.2,
                ),
              ),
            ],
            ),
          ),
        ],
      ),
    );
  }
}

class PresupuestoPlanificacionScreen extends StatefulWidget {
  const PresupuestoPlanificacionScreen({super.key});

  @override
  State<PresupuestoPlanificacionScreen> createState() => _PresupuestoPlanificacionScreenState();
}

class _PresupuestoPlanificacionScreenState extends State<PresupuestoPlanificacionScreen> {
  bool mesesExpandido = false;

  // Columnas fijas
  final List<String> columnasFijas = [
    'Temporada', 'Tipo Centro de costo', 'Centro de Costo', 'Cuartel', 'Sector de Riego', 'Labor',
    'Unidad de Control', 'Tipo Pago', 'Tarifa / sueldo', 'Cantidad del CeCo', 'Rend x j/h', 'Cantidad de Jornadas', 'Líquido por Trabajador'
  ];
  // Meses
  final List<String> meses = [
    'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
    'Enero', 'Febrero', 'Marzo', 'Abril'
  ];
  // Columnas finales
  final List<String> columnasFinales = [
    'Cantidad Presupuestada', 'Total Presupuesto CLP', 'Ppto/Ha USD', 'OBSERVACIONES'
  ];

  // Datos simulados
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    // Generar datos de prueba
    data = List.generate(5, (i) => {
      'Temporada': 'TEMP 25-26',
      'Tipo Centro de costo': ['ADMINISTRATIVO', 'PRODUCTIVO', 'MAQUINARIA', 'SECTOR RIEGO'][i % 4],
      'Centro de Costo': ['CAMPO CHOCALAN', 'SAN C3 IC CH', 'TRACT SAME FRUTTETO 1 CH', 'SECTOR 1 CH'][i % 4],
      'Cuartel': ['SAN C3 IC CH', 'SAN C3 IC CH', '', ''][i % 4],
      'Sector de Riego': ['', '', '', 'SECTOR 1 CH'][i % 4],
      'Labor': ['ADMINISTRACION', 'PODEA', 'RALEO', 'COSECHA', 'MANT EQUIPOS/MAQUINARIA', 'RIEGO TECNIFICADO'][i % 6],
      'Unidad de Control': ['MENSUAL', 'PLANTA', 'KG', 'JORNADA', 'HORAS'][i % 5],
      'Tipo Pago': ['SUELDO MENSUAL', 'CONTRATISTA', 'TRATO PROPIOS', 'SUELDO DIARIO'][i % 4],
      'Tarifa / sueldo': Random().nextInt(25000) + 1500,
      'Cantidad del CeCo': Random().nextInt(3000) + 100,
      'Rend x j/h': (Random().nextDouble() * 10).toStringAsFixed(1),
      'Cantidad de Jornadas': Random().nextInt(100) + 1,
      'Líquido por Trabajador': Random().nextInt(2000000) + 100000,
      ...{
        for (var mes in meses)
          mes: mesesExpandido ? (Random().nextDouble() > 0.5 ? (Random().nextDouble() * 3).toStringAsFixed(1) : '') : '',
      },
      'Cantidad Presupuestada': Random().nextInt(2000) + 1,
      'Total Presupuesto CLP': Random().nextInt(20000000) + 1000000,
      'Ppto/Ha USD': (Random().nextDouble() * 10000).toStringAsFixed(1),
      'OBSERVACIONES': '',
    });
  }

  @override
  Widget build(BuildContext context) {
    // Columnas a mostrar
    final List<String> columnas = [
      ...columnasFijas,
      if (mesesExpandido) ...meses else 'Meses',
      ...columnasFinales,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planificación Presupuestaria'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar fila'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Carga masiva (CSV)'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[700]),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => setState(() => mesesExpandido = !mesesExpandido),
                  icon: Icon(mesesExpandido ? Icons.unfold_less : Icons.unfold_more),
                  label: Text(mesesExpandido ? 'Comprimir meses' : 'Expandir meses'),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Card(
                elevation: 2,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(Colors.green[700]),
                    headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    columns: columnas.map((c) => DataColumn(label: Text(c, maxLines: 2, overflow: TextOverflow.ellipsis))).toList(),
                    rows: data.map((row) {
                      return DataRow(
                        cells: columnas.map((c) => DataCell(Text(row[c]?.toString() ?? '', style: const TextStyle(fontSize: 13)))).toList(),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PresupuestoControlDashboardScreen extends StatelessWidget {
  const PresupuestoControlDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // KPIs simulados
    final kpis = [
      {'label': 'Desajuste CLP Total Acumulado', 'value': '13,51 mill.!', 'color': Colors.red} as Map<String, dynamic>,
      {'label': 'Desajuste % Acumulado', 'value': '1,67 %°', 'color': Colors.yellow[700]} as Map<String, dynamic>,
      {'label': 'Desajuste % Proyectado Temp', 'value': '1,62 %°', 'color': Colors.yellow[700]} as Map<String, dynamic>,
      {'label': 'Ppto Nominal Prox Meses', 'value': '21,99 mill.', 'color': Colors.green[700]} as Map<String, dynamic>,
      {'label': 'Disponibilidad Real Ppto Temporada', 'value': '8,48 mill.!', 'color': Colors.green[400]} as Map<String, dynamic>,
    ];
    // Datos para gráficos y tablas (simulados)
    final labores = ['ADMINISTRACION', 'RALEO', 'SACAR SIERPES', 'JEFE DE CAMPO', 'COSECHA', 'AMARRAR'];
    final desajustes = [16, 16, 15, 10, 8, -20];
    final meses = ['mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre', 'enero', 'febrero', 'marzo', 'abril'];
    final controlMensual = [100, 120, 80, 110, 140, 160, 180, 200, 170, 150, 130, 110];
    final difMensual = [0, 5, -10, 20, -22, 8, 27, 18, 0, 0, 0, 0];
    final tablaManoObra = List.generate(6, (i) => {
      'Labor': labores[i],
      'Costo Acumulado CLP': (Random().nextInt(80000000) + 10000000).toString(),
      'Ppto Acumulado CLP': (Random().nextInt(60000000) + 10000000).toString(),
      'Diferencia CLP': (Random().nextInt(20000000) - 10000000).toString(),
      'Desajuste %': (Random().nextDouble() * 100).toStringAsFixed(1),
      'Costo/Ha USD': (Random().nextInt(1000) + 100).toString(),
      'Ppto/Ha USD': (Random().nextInt(1000) + 100).toString(),
      'Dif/Ha USD': (Random().nextInt(500) - 250).toString(),
      'Ppto Futuro CLP': (Random().nextInt(5000000)).toString(),
      'Presupuesto Temp CLP': (Random().nextInt(80000000) + 10000000).toString(),
      'Disponibilidad CLP': (Random().nextInt(20000000) - 10000000).toString(),
    });
    final tablaRendimientos = List.generate(3, (i) => {
      'Descripción': ['COSECHA', 'CONTROL DE CALIDAD', 'RALEO'][i],
      'Centro de Costo': '796 P3 MA CH',
      'Tipo personal': ['Contratista', 'Contratista', 'Contratista'][i],
      'Unidad': ['BINS', 'HORAS A TRATO', 'BINS'][i],
      'Mes': '1',
      'Cant trabajadores': '160',
      'Rend p/p prom': '1,8',
      'Líquido prom': '28.542',
      'Tarifa Ppto prom': '25.000',
      'Tarifa Real prom': '25.000',
      'Rend Total': '274,0',
      'Rend Total Ppto': '274,0',
      'Dif Tarifa': '0',
      'Dif Rendimiento': '0',
    });
    final especies = ['CEREZAS', 'CIRUELAS', 'DAMASCO', 'DURAZNOS', 'NECTARINES', 'SIN ESPECIE', 'UVA'];
    final laboresFiltro = ['ADMINISTRACION', 'AMARRA D FORM Y DESBROTA', 'AMARRA DE FORMACION', 'AMARRAR', 'APLICAR AGROQUIMICO', 'APLICAR HERBICIDA'];
    final ceCoDesc = ['795 P3 MA CH', '796 P3 MA CH', 'ALLISON P 28 CHOC', 'ANGELENO 20-12 C CHOC', 'APR 1 P3 MA CH'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Control Presupuestario'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Panel principal
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // KPIs
                    Wrap(
                      spacing: 18,
                      runSpacing: 12,
                      children: kpis.map((k) => _KpiCard(
                        title: k['label'] as String, 
                        value: k['value'] as String,
                        valueColor: k['color'] as Color, 
                        bgColor: Colors.grey[200]!,
                        icon: Icons.trending_up,
                        borderColor: Colors.green[700]!
                      )).toList(),
                    ),
                    const SizedBox(height: 12),
                    // Gráficos pequeños alineados horizontalmente
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gráfico de barras horizontales (más pequeño y con valores a la derecha)
                        Expanded(
                          child: Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Mayores Desajustes por Labor MO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                  SizedBox(
                                    height: 80,
                                    child: Stack(
                                      children: [
                                        BarChart(
                                          BarChartData(
                                            alignment: BarChartAlignment.spaceAround,
                                            maxY: 20,
                                            minY: -20,
                                            barTouchData: BarTouchData(enabled: false),
                                            titlesData: FlTitlesData(
                                              leftTitles: AxisTitles(
                                                sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => Text('${v.toInt()} mill.', style: const TextStyle(fontSize: 8))),
                                              ),
                                              bottomTitles: AxisTitles(
                                                sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, meta) {
                                                  int idx = v.toInt();
                                                  return idx >= 0 && idx < labores.length ? Text(labores[idx], style: const TextStyle(fontSize: 8)) : const SizedBox();
                                                }),
                                              ),
                                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                            ),
                                            gridData: FlGridData(show: true),
                                            barGroups: List.generate(labores.length, (i) => BarChartGroupData(x: i, barRods: [
                                              BarChartRodData(toY: desajustes[i].toDouble(), color: desajustes[i] < 0 ? Colors.red : Colors.green, width: 8, borderRadius: BorderRadius.circular(2)),
                                            ])),
                                          ),
                                        ),
                                        // Valores a la derecha de cada barra
                                        Positioned.fill(
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              return Column(
                                                children: List.generate(labores.length, (i) {
                                                  return Expanded(
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(width: 4),
                                                        Expanded(child: Container()),
                                                        Text('${desajustes[i] > 0 ? '' : ''}${desajustes[i]} mill.', style: TextStyle(fontSize: 9, color: desajustes[i] < 0 ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),
                                                        const SizedBox(width: 2),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Gráfico de control mensual (barras y línea superpuesta, más pequeño)
                        Expanded(
                          child: Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Control Presupuestario Mensual', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                  SizedBox(
                                    height: 80,
                                    child: Stack(
                                      children: [
                                        BarChart(
                                          BarChartData(
                                            alignment: BarChartAlignment.spaceAround,
                                            maxY: 220,
                                            minY: 0,
                                            barTouchData: BarTouchData(enabled: false),
                                            titlesData: FlTitlesData(
                                              leftTitles: AxisTitles(
                                                sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => Text('${v.toInt()} mill.', style: const TextStyle(fontSize: 8))),
                                              ),
                                              bottomTitles: AxisTitles(
                                                sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, meta) {
                                                  int idx = v.toInt();
                                                  return idx >= 0 && idx < meses.length ? Text(meses[idx], style: const TextStyle(fontSize: 8)) : const SizedBox();
                                                }),
                                              ),
                                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                            ),
                                            gridData: FlGridData(show: true),
                                            barGroups: List.generate(meses.length, (i) => BarChartGroupData(x: i, barRods: [
                                              BarChartRodData(toY: controlMensual[i].toDouble(), color: Colors.green[700], width: 8, borderRadius: BorderRadius.circular(2)),
                                            ])),
                                          ),
                                        ),
                                        // Línea de diferencia superpuesta
                                        Positioned.fill(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                                            child: LineChart(
                                              LineChartData(
                                                minY: -40,
                                                maxY: 220,
                                                titlesData: FlTitlesData(show: false),
                                                gridData: FlGridData(show: false),
                                                lineBarsData: [
                                                  LineChartBarData(
                                                    spots: List.generate(meses.length, (i) => FlSpot(i.toDouble(), controlMensual[i].toDouble() + difMensual[i].toDouble())),
                                                    isCurved: true,
                                                    color: Colors.orange,
                                                    barWidth: 1.5,
                                                    dotData: FlDotData(show: false),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Tablas debajo, ocupando todo el ancho, con fuente más pequeña
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Detalle Costos Mano de Obra', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.all(Colors.green[700]),
                                headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                                dataRowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Colors.green[100];
                                  }
                                  return null;
                                }),
                                columns: [
                                  'Labor', 'Costo Acumulado CLP', 'Ppto Acumulado CLP', 'Diferencia CLP', 'Desajuste %', 'Costo/Ha USD', 'Ppto/Ha USD', 'Dif/Ha USD', 'Ppto Futuro CLP', 'Presupuesto Temp CLP', 'Disponibilidad CLP'
                                ].map((c) => DataColumn(label: Text(c, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10)))).toList(),
                                rows: tablaManoObra.asMap().entries.map((entry) {
                                  final i = entry.key;
                                  final row = entry.value;
                                  final isTotal = i == tablaManoObra.length - 1;
                                  return DataRow(
                                    color: MaterialStateProperty.all(i % 2 == 0 ? Colors.grey[50] : Colors.white),
                                    cells: row.entries.map((e) {
                                      final isRed = e.key == 'Diferencia CLP' || e.key == 'Desajuste %';
                                      return DataCell(Container(
                                        color: isRed && double.tryParse(row['Desajuste %']?.toString() ?? '0') != null && double.parse(row['Desajuste %']?.toString() ?? '0') > 100 ? Colors.red[100] : null,
                                        child: Text(e.value.toString(), style: TextStyle(fontSize: 10, color: isRed ? Colors.red[900] : Colors.black, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
                                      ));
                                    }).toList(),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Filtros a la derecha
            const SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ESPECIES', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...especies.map((e) => CheckboxListTile(value: false, onChanged: null, title: Text(e, style: const TextStyle(fontSize: 13)))),
                  const SizedBox(height: 12),
                  const Text('Descripción CeCo', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...ceCoDesc.map((e) => CheckboxListTile(value: false, onChanged: null, title: Text(e, style: const TextStyle(fontSize: 13)))),
                  const SizedBox(height: 12),
                  const Text('Labor', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...laboresFiltro.map((e) => CheckboxListTile(value: false, onChanged: null, title: Text(e, style: const TextStyle(fontSize: 13)))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EstadoTarjasScreen extends StatelessWidget {
  const EstadoTarjasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos simulados
    final fundos = ['SANTA VICTORIA', 'SANTA INES', 'SAN MANUEL', 'MAITEN GIGANTE', 'HOSPITAL', 'CULLIPEUMO', 'CAMPO CHOCALAN', 'CAMPO ITAHUE'];
    final tarjasPropio = [6, 6, 40, 18, 19, 18, 24, 42];
    final tarjasPropioRevisada = [6, 78, 40, 18, 4, 18, 24, 24];
    final tarjasContratista = [0, 0, 18, 0, 24, 2, 2, 0];
    final tarjasContratistaRevisada = [0, 0, 18, 0, 34, 2, 2, 0];
    final semanas = ['abril 16', 'abril 17', 'mayo', 'mayo 18'];
    final pendientesContratista = [71, 55, 10, 16];
    final semanasPropio = [1, 23, 2, 54];
    final semanasContratista = [0, 0, 243, 0];
    final fundosBar = ['SANTA VICTORIA', 'SAN MANUEL', 'MAITEN GIGANTE', 'CAMPO CHOCALAN'];
    final pendientesFinalizacion = [71, 55, 10, 16];
    final lineFundos = ['CAMPO ITAHUE', 'CAMPO CHOCALAN', 'SAN MANUEL', 'HOSPITAL', 'SANTA VICTORIA', 'CULLIPEUMO', 'MAITEN GIGANTE', 'SANTA INES'];
    final promRevision = [7.8, 7.2, 4.9, 4.8, 3.5, 1.5, 1.8, 1.6];
    final promAprobacion = [5.4, 6.5, 2.8, 2.5, 2.2, 0.4, 0.8, 0.2];
    final promCreacion = [2.4, 0.6, 2.1, 2.3, 1.3, 0.4, 1.0, 1.6];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado Tarjas'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // Primera fila: 2 gráficos de barras horizontales apiladas
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tarjas Pendientes Aprobacion Personal Propio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 4),
                          SizedBox(
                            height: 120,
                            child: BarChart(
                              BarChartData(
                                barGroups: List.generate(fundos.length, (i) => BarChartGroupData(x: i, barRods: [
                                  BarChartRodData(toY: tarjasPropio[i].toDouble(), color: Colors.grey[600], width: 12),
                                  BarChartRodData(toY: tarjasPropioRevisada[i].toDouble(), color: Colors.orange[300], width: 12),
                                ])),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => v.toInt() < fundos.length ? Text(fundos[v.toInt()], style: const TextStyle(fontSize: 9)) : const SizedBox())),
                                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                gridData: FlGridData(show: true),
                                barTouchData: BarTouchData(enabled: false),
                                alignment: BarChartAlignment.spaceBetween,
                                maxY: 80,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(width: 16, height: 8, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              const Text('creada', style: TextStyle(fontSize: 10)),
                              const SizedBox(width: 12),
                              Container(width: 16, height: 8, color: Colors.orange[300]),
                              const SizedBox(width: 4),
                              const Text('revisada', style: TextStyle(fontSize: 10)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tarjas Pendientes Aprobacion Contratistas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 4),
                          SizedBox(
                            height: 120,
                            child: BarChart(
                              BarChartData(
                                barGroups: List.generate(fundos.length, (i) => BarChartGroupData(x: i, barRods: [
                                  BarChartRodData(toY: tarjasContratista[i].toDouble(), color: Colors.grey[600], width: 12),
                                  BarChartRodData(toY: tarjasContratistaRevisada[i].toDouble(), color: Colors.orange[300], width: 12),
                                ])),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => v.toInt() < fundos.length ? Text(fundos[v.toInt()], style: const TextStyle(fontSize: 9)) : const SizedBox())),
                                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                gridData: FlGridData(show: true),
                                barTouchData: BarTouchData(enabled: false),
                                alignment: BarChartAlignment.spaceBetween,
                                maxY: 60,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(width: 16, height: 8, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              const Text('creada', style: TextStyle(fontSize: 10)),
                              const SizedBox(width: 12),
                              Container(width: 16, height: 8, color: Colors.orange[300]),
                              const SizedBox(width: 4),
                              const Text('revisada', style: TextStyle(fontSize: 10)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Segunda fila: 2 gráficos de barras verticales
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tarjas Pendientes por Semana/Mes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 4),
                          SizedBox(
                            height: 100,
                            child: BarChart(
                              BarChartData(
                                barGroups: List.generate(semanas.length, (i) => BarChartGroupData(x: i, barRods: [
                                  BarChartRodData(toY: semanasPropio[i].toDouble(), color: Colors.blue[900], width: 12),
                                  BarChartRodData(toY: semanasContratista[i].toDouble(), color: Colors.green[800], width: 12),
                                ])),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => v.toInt() < semanas.length ? Text(semanas[v.toInt()], style: const TextStyle(fontSize: 9)) : const SizedBox())),
                                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => Text('${v.toInt()}', style: const TextStyle(fontSize: 8)))),
                                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                gridData: FlGridData(show: true),
                                barTouchData: BarTouchData(enabled: false),
                                alignment: BarChartAlignment.spaceBetween,
                                maxY: 250,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(width: 16, height: 8, color: Colors.blue[900]),
                              const SizedBox(width: 4),
                              const Text('Contratista', style: TextStyle(fontSize: 10)),
                              const SizedBox(width: 12),
                              Container(width: 16, height: 8, color: Colors.green),
                              const SizedBox(width: 4),
                              const Text('Propio', style: TextStyle(fontSize: 10)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tarjas de Contratista Pendientes de Finalizacion', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 4),
                          SizedBox(
                            height: 100,
                            child: BarChart(
                              BarChartData(
                                barGroups: List.generate(fundosBar.length, (i) => BarChartGroupData(x: i, barRods: [
                                  BarChartRodData(toY: pendientesFinalizacion[i].toDouble(), color: Colors.green[800], width: 18),
                                ])),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => v.toInt() < fundosBar.length ? Text(fundosBar[v.toInt()], style: const TextStyle(fontSize: 9)) : const SizedBox())),
                                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => Text('${v.toInt()}', style: const TextStyle(fontSize: 8)))),
                                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                gridData: FlGridData(show: true),
                                barTouchData: BarTouchData(enabled: false),
                                alignment: BarChartAlignment.spaceBetween,
                                maxY: 80,
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
            const SizedBox(height: 12),
            // Tercera fila: gráfico de líneas
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tiempos de Revision y Aprobacion por Fundo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 120,
                      child: LineChart(
                        LineChartData(
                          minY: 0,
                          maxY: 10,
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => v.toInt() < lineFundos.length ? Text(lineFundos[v.toInt()], style: const TextStyle(fontSize: 9)) : const SizedBox())),
                            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => Text('${v.toInt()}', style: const TextStyle(fontSize: 8)))),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: FlGridData(show: true),
                          lineBarsData: [
                            LineChartBarData(
                              spots: List.generate(lineFundos.length, (i) => FlSpot(i.toDouble(), promRevision[i])),
                              isCurved: true,
                              color: Colors.orange,
                              barWidth: 2,
                              dotData: FlDotData(show: true),
                            ),
                            LineChartBarData(
                              spots: List.generate(lineFundos.length, (i) => FlSpot(i.toDouble(), promAprobacion[i])),
                              isCurved: true,
                              color: Colors.blue,
                              barWidth: 2,
                              dotData: FlDotData(show: true),
                            ),
                            LineChartBarData(
                              spots: List.generate(lineFundos.length, (i) => FlSpot(i.toDouble(), promCreacion[i])),
                              isCurved: true,
                              color: Colors.green,
                              barWidth: 2,
                              dotData: FlDotData(show: true),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(width: 16, height: 8, color: Colors.orange),
                        const SizedBox(width: 4),
                        const Text('Promedio días revision', style: TextStyle(fontSize: 10)),
                        const SizedBox(width: 12),
                        Container(width: 16, height: 8, color: Colors.blue),
                        const SizedBox(width: 4),
                        const Text('Promedio días aprobacion', style: TextStyle(fontSize: 10)),
                        const SizedBox(width: 12),
                        Container(width: 16, height: 8, color: Colors.green),
                        const SizedBox(width: 4),
                        const Text('Promedio días desde creacion', style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 