import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String selectedBranch;
  final String selectedSpecies;
  final List<String> branches;
  final List<String> species;
  final Function(String) onBranchChanged;
  final Function(String) onSpeciesChanged;
  final VoidCallback onProfileTap;
  final VoidCallback onLogoutTap;

  const CustomHeader({
    super.key,
    required this.userName,
    required this.selectedBranch,
    required this.selectedSpecies,
    required this.branches,
    required this.species,
    required this.onBranchChanged,
    required this.onSpeciesChanged,
    required this.onProfileTap,
    required this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                _buildDropdown(
                  value: selectedBranch,
                  items: branches,
                  onChanged: onBranchChanged,
                  hint: 'Seleccionar Sucursal',
                ),
                const SizedBox(width: 16),
                _buildDropdown(
                  value: selectedSpecies,
                  items: species,
                  onChanged: onSpeciesChanged,
                  hint: 'Seleccionar Especie',
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.person),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    const Icon(Icons.person_outline),
                    const SizedBox(width: 8),
                    Text(userName),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Cerrar sesión'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'profile') {
                onProfileTap();
              } else if (value == 'logout') {
                onLogoutTap();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String) onChanged,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.primaryLight),
      ),
      child: DropdownButton<String>(
        value: value,
        hint: Text(hint),
        underline: const SizedBox(),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 