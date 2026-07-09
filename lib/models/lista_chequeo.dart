/// Origen de una lista de chequeo en el catálogo local.
enum OrigenListaChequeo {
  administrador,
  liderProyecto;

  String get etiqueta {
    switch (this) {
      case OrigenListaChequeo.administrador:
        return 'Administrador';
      case OrigenListaChequeo.liderProyecto:
        return 'Líder de proyecto';
    }
  }

  static OrigenListaChequeo fromString(String value) {
    if (value == 'lider_proyecto' || value == 'liderProyecto') {
      return OrigenListaChequeo.liderProyecto;
    }
    return OrigenListaChequeo.administrador;
  }

  String toJson() {
    switch (this) {
      case OrigenListaChequeo.administrador:
        return 'administrador';
      case OrigenListaChequeo.liderProyecto:
        return 'lider_proyecto';
    }
  }
}

class ItemListaChequeo {
  final String id;
  final String titulo;
  final String descripcion;
  final String icono;

  const ItemListaChequeo({
    required this.id,
    required this.titulo,
    this.descripcion = '',
    this.icono = 'check',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'titulo': titulo,
        'descripcion': descripcion,
        'icono': icono,
      };

  factory ItemListaChequeo.fromJson(Map<String, dynamic> json) {
    return ItemListaChequeo(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String? ?? '',
      icono: json['icono'] as String? ?? 'check',
    );
  }

  ItemListaChequeo copyWith({
    String? titulo,
    String? descripcion,
    String? icono,
  }) {
    return ItemListaChequeo(
      id: id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      icono: icono ?? this.icono,
    );
  }
}

class ListaChequeo {
  final String id;
  final String nombre;
  final String? descripcion;
  final List<ItemListaChequeo> items;
  final OrigenListaChequeo origen;
  final String? creadoPorEmail;
  final DateTime creadoEn;
  final DateTime actualizadoEn;

  const ListaChequeo({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.items = const [],
    required this.origen,
    this.creadoPorEmail,
    required this.creadoEn,
    required this.actualizadoEn,
  });

  bool get esDelAdministrador => origen == OrigenListaChequeo.administrador;

  bool puedeEditarPor(String? emailUsuario) {
    if (esDelAdministrador) return false;
    if (emailUsuario == null || emailUsuario.isEmpty) return false;
    return creadoPorEmail == emailUsuario;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'descripcion': descripcion,
        'items': items.map((i) => i.toJson()).toList(),
        'origen': origen.toJson(),
        'creadoPorEmail': creadoPorEmail,
        'creadoEn': creadoEn.toIso8601String(),
        'actualizadoEn': actualizadoEn.toIso8601String(),
      };

  factory ListaChequeo.fromJson(Map<String, dynamic> json) {
    return ListaChequeo(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => ItemListaChequeo.fromJson(e as Map<String, dynamic>))
          .toList(),
      origen: OrigenListaChequeo.fromString(json['origen'] as String? ?? ''),
      creadoPorEmail: json['creadoPorEmail'] as String?,
      creadoEn: DateTime.parse(json['creadoEn'] as String),
      actualizadoEn: DateTime.parse(json['actualizadoEn'] as String),
    );
  }

  ListaChequeo copyWith({
    String? nombre,
    String? descripcion,
    List<ItemListaChequeo>? items,
    DateTime? actualizadoEn,
  }) {
    return ListaChequeo(
      id: id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      items: items ?? this.items,
      origen: origen,
      creadoPorEmail: creadoPorEmail,
      creadoEn: creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }
}
