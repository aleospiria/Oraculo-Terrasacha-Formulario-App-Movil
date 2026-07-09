// Modelo del chequeo de transporte (vehículo) asociado a una salida de campo.
//
// El chequeo es ejecutado por el líder de cuadrilla antes/durante una salida.
// Permite clonar el último chequeo, validar la licencia del conductor,
// adjuntar evidencia multimedia y firmar. Se persiste como parte de
// EjecucionSalida y también en un historial global para poder clonarlo.

/// Respuesta de cada ítem del chequeo de transporte.
enum RespuestaItemTransporte { si, no, noAplica }

extension RespuestaItemTransporteX on RespuestaItemTransporte {
  String get etiqueta {
    switch (this) {
      case RespuestaItemTransporte.si:
        return 'Sí';
      case RespuestaItemTransporte.no:
        return 'No';
      case RespuestaItemTransporte.noAplica:
        return 'N/A';
    }
  }

  static RespuestaItemTransporte? fromName(String? value) {
    if (value == null) return null;
    for (final r in RespuestaItemTransporte.values) {
      if (r.name == value) return r;
    }
    return null;
  }
}

/// Tipo de evidencia multimedia adjunta al chequeo.
enum TipoEvidenciaVehiculo { foto, video }

extension TipoEvidenciaVehiculoX on TipoEvidenciaVehiculo {
  static TipoEvidenciaVehiculo fromName(String? value) {
    for (final t in TipoEvidenciaVehiculo.values) {
      if (t.name == value) return t;
    }
    return TipoEvidenciaVehiculo.foto;
  }
}

/// Datos del conductor y su licencia de conducción.
class ConductorVehiculo {
  final String nombre;
  final String numeroLicencia;
  final String categoriaLicencia;
  final DateTime? vencimientoLicencia;

  const ConductorVehiculo({
    this.nombre = '',
    this.numeroLicencia = '',
    this.categoriaLicencia = '',
    this.vencimientoLicencia,
  });

  bool get licenciaVencida {
    final v = vencimientoLicencia;
    if (v == null) return true;
    final hoy = DateTime.now();
    final soloFecha = DateTime(v.year, v.month, v.day);
    final hoyFecha = DateTime(hoy.year, hoy.month, hoy.day);
    return soloFecha.isBefore(hoyFecha);
  }

  bool get datosCompletos =>
      nombre.trim().isNotEmpty &&
      numeroLicencia.trim().isNotEmpty &&
      categoriaLicencia.trim().isNotEmpty &&
      vencimientoLicencia != null;

  ConductorVehiculo copyWith({
    String? nombre,
    String? numeroLicencia,
    String? categoriaLicencia,
    DateTime? vencimientoLicencia,
  }) {
    return ConductorVehiculo(
      nombre: nombre ?? this.nombre,
      numeroLicencia: numeroLicencia ?? this.numeroLicencia,
      categoriaLicencia: categoriaLicencia ?? this.categoriaLicencia,
      vencimientoLicencia: vencimientoLicencia ?? this.vencimientoLicencia,
    );
  }

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'numeroLicencia': numeroLicencia,
        'categoriaLicencia': categoriaLicencia,
        if (vencimientoLicencia != null)
          'vencimientoLicencia': vencimientoLicencia!.toIso8601String(),
      };

  factory ConductorVehiculo.fromJson(Map<String, dynamic> json) {
    return ConductorVehiculo(
      nombre: json['nombre'] as String? ?? '',
      numeroLicencia: json['numeroLicencia'] as String? ?? '',
      categoriaLicencia: json['categoriaLicencia'] as String? ?? '',
      vencimientoLicencia: json['vencimientoLicencia'] != null
          ? DateTime.tryParse(json['vencimientoLicencia'] as String)
          : null,
    );
  }
}

/// Ítem individual del chequeo de transporte (ej. "Frenos", "Extintor vigente").
class ItemChequeoTransporte {
  final String id;
  final String titulo;
  final RespuestaItemTransporte? respuesta;

  const ItemChequeoTransporte({
    required this.id,
    required this.titulo,
    this.respuesta,
  });

  ItemChequeoTransporte copyWith({RespuestaItemTransporte? respuesta}) {
    return ItemChequeoTransporte(
      id: id,
      titulo: titulo,
      respuesta: respuesta ?? this.respuesta,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'titulo': titulo,
        if (respuesta != null) 'respuesta': respuesta!.name,
      };

  factory ItemChequeoTransporte.fromJson(Map<String, dynamic> json) {
    return ItemChequeoTransporte(
      id: json['id'] as String,
      titulo: json['titulo'] as String? ?? '',
      respuesta:
          RespuestaItemTransporteX.fromName(json['respuesta'] as String?),
    );
  }
}

/// Evidencia multimedia (foto/video) almacenada como ruta local.
class EvidenciaChequeoVehiculo {
  final String id;
  final String rutaLocal;
  final TipoEvidenciaVehiculo tipo;
  final String? descripcion;
  final DateTime capturadaEn;

  const EvidenciaChequeoVehiculo({
    required this.id,
    required this.rutaLocal,
    this.tipo = TipoEvidenciaVehiculo.foto,
    this.descripcion,
    required this.capturadaEn,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'rutaLocal': rutaLocal,
        'tipo': tipo.name,
        if (descripcion != null) 'descripcion': descripcion,
        'capturadaEn': capturadaEn.toIso8601String(),
      };

  factory EvidenciaChequeoVehiculo.fromJson(Map<String, dynamic> json) {
    return EvidenciaChequeoVehiculo(
      id: json['id'] as String,
      rutaLocal: json['rutaLocal'] as String? ?? '',
      tipo: TipoEvidenciaVehiculoX.fromName(json['tipo'] as String?),
      descripcion: json['descripcion'] as String?,
      capturadaEn: DateTime.tryParse(json['capturadaEn'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

/// Firma del responsable que cierra el chequeo (ruta a imagen PNG local).
class FirmaChequeoVehiculo {
  final String rutaImagenLocal;
  final String firmadoPorNombre;
  final String? firmadoPorUserId;
  final DateTime firmadoEn;

  const FirmaChequeoVehiculo({
    required this.rutaImagenLocal,
    required this.firmadoPorNombre,
    this.firmadoPorUserId,
    required this.firmadoEn,
  });

  Map<String, dynamic> toJson() => {
        'rutaImagenLocal': rutaImagenLocal,
        'firmadoPorNombre': firmadoPorNombre,
        if (firmadoPorUserId != null) 'firmadoPorUserId': firmadoPorUserId,
        'firmadoEn': firmadoEn.toIso8601String(),
      };

  factory FirmaChequeoVehiculo.fromJson(Map<String, dynamic> json) {
    return FirmaChequeoVehiculo(
      rutaImagenLocal: json['rutaImagenLocal'] as String? ?? '',
      firmadoPorNombre: json['firmadoPorNombre'] as String? ?? '',
      firmadoPorUserId: json['firmadoPorUserId'] as String?,
      firmadoEn:
          DateTime.tryParse(json['firmadoEn'] as String? ?? '') ??
              DateTime.now(),
    );
  }
}

/// Chequeo de transporte completo asociado a una salida.
class ChequeoVehiculoSalida {
  final String id;
  final String salidaId;
  final bool aplicaTransporte;
  final String placa;
  final String? marcaModelo;
  final ConductorVehiculo conductor;
  final List<ItemChequeoTransporte> items;
  final String observaciones;
  final List<EvidenciaChequeoVehiculo> evidencias;
  final FirmaChequeoVehiculo? firma;
  final String? clonadoDesdeId;
  final bool completado;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  final DateTime? completadoEn;

  const ChequeoVehiculoSalida({
    required this.id,
    required this.salidaId,
    this.aplicaTransporte = true,
    this.placa = '',
    this.marcaModelo,
    this.conductor = const ConductorVehiculo(),
    this.items = const [],
    this.observaciones = '',
    this.evidencias = const [],
    this.firma,
    this.clonadoDesdeId,
    this.completado = false,
    required this.creadoEn,
    required this.actualizadoEn,
    this.completadoEn,
  });

  bool get itemsRespondidos =>
      items.every((i) => i.respuesta != null);

  ChequeoVehiculoSalida copyWith({
    bool? aplicaTransporte,
    String? placa,
    String? marcaModelo,
    ConductorVehiculo? conductor,
    List<ItemChequeoTransporte>? items,
    String? observaciones,
    List<EvidenciaChequeoVehiculo>? evidencias,
    FirmaChequeoVehiculo? firma,
    String? clonadoDesdeId,
    bool? completado,
    DateTime? actualizadoEn,
    DateTime? completadoEn,
  }) {
    return ChequeoVehiculoSalida(
      id: id,
      salidaId: salidaId,
      aplicaTransporte: aplicaTransporte ?? this.aplicaTransporte,
      placa: placa ?? this.placa,
      marcaModelo: marcaModelo ?? this.marcaModelo,
      conductor: conductor ?? this.conductor,
      items: items ?? this.items,
      observaciones: observaciones ?? this.observaciones,
      evidencias: evidencias ?? this.evidencias,
      firma: firma ?? this.firma,
      clonadoDesdeId: clonadoDesdeId ?? this.clonadoDesdeId,
      completado: completado ?? this.completado,
      creadoEn: creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      completadoEn: completadoEn ?? this.completadoEn,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'salidaId': salidaId,
        'aplicaTransporte': aplicaTransporte,
        'placa': placa,
        if (marcaModelo != null) 'marcaModelo': marcaModelo,
        'conductor': conductor.toJson(),
        'items': items.map((i) => i.toJson()).toList(),
        'observaciones': observaciones,
        'evidencias': evidencias.map((e) => e.toJson()).toList(),
        if (firma != null) 'firma': firma!.toJson(),
        if (clonadoDesdeId != null) 'clonadoDesdeId': clonadoDesdeId,
        'completado': completado,
        'creadoEn': creadoEn.toIso8601String(),
        'actualizadoEn': actualizadoEn.toIso8601String(),
        if (completadoEn != null) 'completadoEn': completadoEn!.toIso8601String(),
      };

  factory ChequeoVehiculoSalida.fromJson(Map<String, dynamic> json) {
    return ChequeoVehiculoSalida(
      id: json['id'] as String,
      salidaId: json['salidaId'] as String? ?? '',
      aplicaTransporte: json['aplicaTransporte'] as bool? ?? true,
      placa: json['placa'] as String? ?? '',
      marcaModelo: json['marcaModelo'] as String?,
      conductor: json['conductor'] != null
          ? ConductorVehiculo.fromJson(
              json['conductor'] as Map<String, dynamic>,
            )
          : const ConductorVehiculo(),
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) =>
              ItemChequeoTransporte.fromJson(e as Map<String, dynamic>))
          .toList(),
      observaciones: json['observaciones'] as String? ?? '',
      evidencias: (json['evidencias'] as List<dynamic>? ?? [])
          .map((e) =>
              EvidenciaChequeoVehiculo.fromJson(e as Map<String, dynamic>))
          .toList(),
      firma: json['firma'] != null
          ? FirmaChequeoVehiculo.fromJson(json['firma'] as Map<String, dynamic>)
          : null,
      clonadoDesdeId: json['clonadoDesdeId'] as String?,
      completado: json['completado'] as bool? ?? false,
      creadoEn: DateTime.tryParse(json['creadoEn'] as String? ?? '') ??
          DateTime.now(),
      actualizadoEn:
          DateTime.tryParse(json['actualizadoEn'] as String? ?? '') ??
              DateTime.now(),
      completadoEn: json['completadoEn'] != null
          ? DateTime.tryParse(json['completadoEn'] as String)
          : null,
    );
  }
}
