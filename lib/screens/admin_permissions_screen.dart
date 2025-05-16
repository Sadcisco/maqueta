import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/mock_data.dart';

class AdminPermissionsScreen extends StatefulWidget {
  const AdminPermissionsScreen({super.key});

  @override
  State<AdminPermissionsScreen> createState() => _AdminPermissionsScreenState();
}

class _AdminPermissionsScreenState extends State<AdminPermissionsScreen> {
  List<Map<String, dynamic>> usuarios = List.from(MockData.usuarios);

  void _editarPermisos(int idx) async {
    final usuario = usuarios[idx];
    final result = await showDialog(
      context: context,
      builder: (context) => _PermisosDialog(usuario: usuario),
    );
    if (result != null) {
      setState(() {
        usuarios[idx] = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = usuarios.length;
    final admins = usuarios.where((u) => u['rol'] == 'Administrador').length;
    final activos = usuarios.length; // Simulación
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Administración de Usuarios y Permisos', style: Theme.of(context).textTheme.displayLarge?.copyWith(color: AppTheme.primaryDark)),
          const SizedBox(height: 16),
          Row(
            children: [
              _ResumenCard(title: 'Total usuarios', value: '$total'),
              _ResumenCard(title: 'Administradores', value: '$admins'),
              _ResumenCard(title: 'Activos', value: '$activos'),
            ],
          ),
          const SizedBox(height: 24),
          Text('Usuarios', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppTheme.primaryDark)),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: usuarios.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final u = usuarios[i];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person, color: AppTheme.primaryDark),
                          const SizedBox(width: 8),
                          Text(u['nombre'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: u['rol'] == 'Administrador' ? AppTheme.primaryDark : AppTheme.primaryLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(u['rol'], style: TextStyle(color: u['rol'] == 'Administrador' ? AppTheme.textColor : AppTheme.primaryDark, fontWeight: FontWeight.bold)),
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryDark,
                              foregroundColor: AppTheme.textColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: const Icon(Icons.edit),
                            label: const Text('Editar permisos'),
                            onPressed: () => _editarPermisos(i),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.email, size: 18, color: Colors.black54),
                          const SizedBox(width: 4),
                          Text(u['correo'], style: const TextStyle(color: Colors.black87)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.business, size: 18, color: Colors.black54),
                          const SizedBox(width: 4),
                          const Text('Sucursales:', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Wrap(
                              spacing: 6,
                              children: (u['sucursales'] as List).map<Widget>((suc) => Chip(
                                label: Text(suc, style: const TextStyle(color: Colors.white)),
                                backgroundColor: AppTheme.primaryDark,
                                padding: EdgeInsets.zero,
                              )).toList(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.lock, size: 18, color: Colors.black54),
                          const SizedBox(width: 4),
                          const Text('Permisos:', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Wrap(
                              spacing: 6,
                              children: (u['permisos'] as Map).entries.where((e) => e.value).map<Widget>((e) => Chip(
                                label: Text(e.key, style: const TextStyle(color: Colors.white)),
                                backgroundColor: AppTheme.accentColor,
                                padding: EdgeInsets.zero,
                              )).toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ResumenCard extends StatelessWidget {
  final String title;
  final String value;
  const _ResumenCard({required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.primaryDark,
      margin: const EdgeInsets.only(right: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Text(value, style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppTheme.textColor)),
            Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textColor)),
          ],
        ),
      ),
    );
  }
}

class _PermisosDialog extends StatefulWidget {
  final Map<String, dynamic> usuario;
  const _PermisosDialog({required this.usuario});
  @override
  State<_PermisosDialog> createState() => _PermisosDialogState();
}

class _PermisosDialogState extends State<_PermisosDialog> {
  late Map<String, dynamic> usuario;
  late Map permisos;
  late List sucursales;

  @override
  void initState() {
    super.initState();
    usuario = Map<String, dynamic>.from(widget.usuario);
    permisos = Map<String, bool>.from(usuario['permisos']);
    sucursales = List<String>.from(usuario['sucursales']);
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      title: Text('Permisos de ${usuario['nombre']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
      content: SingleChildScrollView(
        child: isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sucursales
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sucursales', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.primaryDark, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: MockData.campos.map((suc) => FilterChip(
                                label: Text(suc, style: TextStyle(color: sucursales.contains(suc) ? Colors.white : AppTheme.primaryDark)),
                                selected: sucursales.contains(suc),
                                selectedColor: AppTheme.primaryDark,
                                backgroundColor: AppTheme.primaryLight,
                                onSelected: (v) {
                                  setState(() {
                                    if (v) {
                                      sucursales.add(suc);
                                    } else {
                                      sucursales.remove(suc);
                                    }
                                  });
                                },
                              )).toList(),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(width: 32, thickness: 1),
                  // Permisos módulos
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Permisos de módulos', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.primaryDark, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ...permisos.keys.map((mod) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  Expanded(child: Text(mod, style: const TextStyle(color: Colors.black87, fontSize: 16))),
                                  Switch(
                                    value: permisos[mod],
                                    activeColor: AppTheme.primaryDark,
                                    onChanged: (v) {
                                      setState(() {
                                        permisos[mod] = v;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sucursales', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.primaryDark, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: MockData.campos.map((suc) => FilterChip(
                          label: Text(suc, style: TextStyle(color: sucursales.contains(suc) ? Colors.white : AppTheme.primaryDark)),
                          selected: sucursales.contains(suc),
                          selectedColor: AppTheme.primaryDark,
                          backgroundColor: AppTheme.primaryLight,
                          onSelected: (v) {
                            setState(() {
                              if (v) {
                                sucursales.add(suc);
                              } else {
                                sucursales.remove(suc);
                              }
                            });
                          },
                        )).toList(),
                  ),
                  const Divider(height: 32),
                  Text('Permisos de módulos', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.primaryDark, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...permisos.keys.map((mod) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Expanded(child: Text(mod, style: const TextStyle(color: Colors.black87, fontSize: 16))),
                            Switch(
                              value: permisos[mod],
                              activeColor: AppTheme.primaryDark,
                              onChanged: (v) {
                                setState(() {
                                  permisos[mod] = v;
                                });
                              },
                            ),
                          ],
                        ),
                      )),
                ],
              ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        TextButton(
          child: const Text('Cancelar', style: TextStyle(color: AppTheme.primaryDark)),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryLight,
            foregroundColor: AppTheme.primaryDark,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('Guardar', style: TextStyle(fontWeight: FontWeight.bold)),
          onPressed: () {
            usuario['permisos'] = permisos;
            usuario['sucursales'] = sucursales;
            Navigator.pop(context, usuario);
          },
        ),
      ],
    );
  }
} 