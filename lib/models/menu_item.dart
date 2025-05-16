import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final List<MenuItem>? subItems;
  final bool isAdminOnly;

  const MenuItem({
    required this.title,
    required this.icon,
    this.subItems,
    this.isAdminOnly = false,
  });
}

class MenuItems {
  static const List<MenuItem> items = [
    MenuItem(
      title: 'Home',
      icon: Icons.home,
    ),
    MenuItem(
      title: 'Faenas',
      icon: Icons.work,
      subItems: [
        MenuItem(title: 'Rendimiento y tarifas', icon: Icons.bar_chart),
        MenuItem(title: 'Estado tarja', icon: Icons.assignment),
      ],
    ),
    MenuItem(
      title: 'Control Presupuestario',
      icon: Icons.analytics,
      subItems: [
        MenuItem(title: 'Planificación', icon: Icons.event_note),
        MenuItem(title: 'Control', icon: Icons.check_circle),
      ],
    ),
    MenuItem(
      title: 'Producción',
      icon: Icons.agriculture,
      subItems: [
        MenuItem(title: 'Estimación', icon: Icons.timeline),
        MenuItem(
          title: 'Labores',
          icon: Icons.list,
          subItems: [
            MenuItem(title: 'Carozo', icon: Icons.local_florist),
            MenuItem(title: 'Cereza', icon: Icons.local_florist),
            MenuItem(title: 'Ciruela', icon: Icons.local_florist),
            MenuItem(title: 'Uva', icon: Icons.local_florist),
          ],
        ),
      ],
    ),
    MenuItem(
      title: 'Riego',
      icon: Icons.water,
      subItems: [
        MenuItem(title: 'Chequeo Riego', icon: Icons.check_circle_outline),
      ],
    ),
    MenuItem(title: 'RRHH', icon: Icons.people),
    MenuItem(title: 'Contratistas', icon: Icons.group),
    MenuItem(
      title: 'Módulo Administración',
      icon: Icons.admin_panel_settings,
      isAdminOnly: true,
      subItems: [
        MenuItem(
          title: 'Parámetros Generales',
          icon: Icons.settings,
          subItems: [
            MenuItem(title: 'Centro de costos', icon: Icons.account_balance),
            MenuItem(title: 'Variedad', icon: Icons.grass),
            MenuItem(title: 'Cuarteles', icon: Icons.map),
            MenuItem(title: 'Temporada', icon: Icons.date_range),
            MenuItem(title: 'Labores', icon: Icons.list),
            MenuItem(title: 'Tipo de Planta', icon: Icons.eco),
          ],
        ),
        MenuItem(title: 'Usuarios', icon: Icons.person),
      ],
    ),
    MenuItem(
      title: 'Mis cuarteles',
      icon: Icons.map,
    ),
  ];
} 