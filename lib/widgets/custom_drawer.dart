import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/menu_item.dart' as menu;
import '../theme/app_theme.dart';

class CustomDrawer extends StatefulWidget {
  final bool isAdmin;
  final Function(menu.MenuItem) onItemSelected;
  final menu.MenuItem? selectedMenu;

  const CustomDrawer({
    super.key,
    required this.isAdmin,
    required this.onItemSelected,
    this.selectedMenu,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  // Guarda el estado de expansión de cada menú principal por índice
  final Map<int, bool> _expanded = {};

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppTheme.primaryDark,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    child: Image.asset(
                      'assets/images/lh_fruits_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'LH FRUITS',
                    style: TextStyle(
                      color: AppTheme.textColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: menu.MenuItems.items.length,
              itemBuilder: (context, index) {
                final item = menu.MenuItems.items[index];
                if (item.isAdminOnly && !widget.isAdmin) return const SizedBox.shrink();
                return _buildMenuItem(context, item, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, menu.MenuItem item, int index, {int depth = 0}) {
    final hasSubItems = item.subItems != null && item.subItems!.isNotEmpty;
    final isSelected = widget.selectedMenu == item;

    if (hasSubItems) {
      return Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          key: PageStorageKey('${item.title}-$depth'),
          initiallyExpanded: false,
          leading: Icon(item.icon, color: Colors.white),
          title: InkWell(
            onTap: () => widget.onItemSelected(item),
            child: Padding(
              padding: EdgeInsets.only(left: depth * 12.0),
              child: Text(
                item.title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          ),
          backgroundColor: depth == 0 ? null : AppTheme.primaryDark.withOpacity(0.92),
          collapsedBackgroundColor: null,
          children: [
            ...item.subItems!.asMap().entries.map((entry) {
              final subItem = entry.value;
              return _buildMenuItem(context, subItem, entry.key, depth: depth + 1);
            }).toList(),
          ],
          onExpansionChanged: (expanded) {
            setState(() {});
          },
        ),
      );
    }

    return Container(
      decoration: isSelected
          ? BoxDecoration(
              color: AppTheme.primaryDark,
              border: const Border(
                left: BorderSide(color: Colors.white, width: 4),
              ),
            )
          : null,
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 24.0 + depth * 12.0, right: 16.0),
        leading: Icon(item.icon, color: Colors.white),
        title: Text(
          item.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        tileColor: Colors.transparent,
        onTap: () => widget.onItemSelected(item),
      ).animate().fadeIn().slideX(begin: 0.1),
    );
  }
} 