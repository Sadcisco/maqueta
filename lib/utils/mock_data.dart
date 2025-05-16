class MockData {
  static List<String> temporadas = [
    '2022-2023', '2023-2024', '2024-2025'
  ];
  static List<String> especies = [
    'Durazno', 'Nectarina', 'Ciruela', 'Uva', 'Cereza'
  ];
  static Map<String, List<String>> variedades = {
    'Durazno': ['Elegant Lady', 'Rich Lady'],
    'Nectarina': ['Snow Queen', 'August Red'],
    'Ciruela': ['Santa Rosa', 'Black Amber'],
    'Uva': ['Red Globe', 'Thompson Seedless'],
    'Cereza': ['Bing', 'Lapins'],
  };
  static List<String> labores = [
    'Poda', 'Riego', 'Cosecha', 'Fertilización', 'Control de plagas'
  ];
  static List<String> campos = [
    'Fundo Norte', 'Huerto Sur', 'Estancia Las Rosas'
  ];
  static List<Map<String, dynamic>> actividades = [
    {
      'campo': 'Fundo Norte',
      'especie': 'Durazno',
      'variedad': 'Elegant Lady',
      'labor': 'Poda',
      'temporada': '2023-2024',
      'avance': 80,
      'rendimiento': 25.4,
      'costo': 12000,
      'calidad': 92,
      'conteos': 1500,
    },
    {
      'campo': 'Huerto Sur',
      'especie': 'Uva',
      'variedad': 'Red Globe',
      'labor': 'Cosecha',
      'temporada': '2023-2024',
      'avance': 100,
      'rendimiento': 32.1,
      'costo': 18000,
      'calidad': 88,
      'conteos': 2000,
    },
    // ...más datos simulados
  ];
  static List<Map<String, dynamic>> usuarios = [
    {
      'nombre': 'Juan Pérez',
      'correo': 'juan@lhfruits.com',
      'rol': 'Administrador',
      'sucursales': ['Fundo Norte', 'Huerto Sur'],
      'permisos': {
        'Analítica de Actividades': true,
        'Rendimientos': true,
        'Costos': true,
        'Calidad': true,
        'Conteos': true,
        'Analítica Presupuestaria': true,
        'Analítica Productiva': true,
        'Administración': true,
      },
    },
    {
      'nombre': 'María López',
      'correo': 'maria@lhfruits.com',
      'rol': 'Usuario',
      'sucursales': ['Estancia Las Rosas'],
      'permisos': {
        'Analítica de Actividades': true,
        'Rendimientos': true,
        'Costos': false,
        'Calidad': true,
        'Conteos': false,
        'Analítica Presupuestaria': false,
        'Analítica Productiva': true,
        'Administración': false,
      },
    },
    // ...más usuarios
  ];
  // Puedes agregar más métodos para obtener datos filtrados por módulo
} 