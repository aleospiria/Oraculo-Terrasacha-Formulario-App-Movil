/// Evidencia fotográfica del checklist de salida de una persona del equipo.
class EvidenciaChecklistSalida {
  final String id;
  final String rutaLocal;
  final String? descripcion;
  final DateTime capturadaEn;

  const EvidenciaChecklistSalida({
    required this.id,
    required this.rutaLocal,
    this.descripcion,
    required this.capturadaEn,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'rutaLocal': rutaLocal,
        if (descripcion != null) 'descripcion': descripcion,
        'capturadaEn': capturadaEn.toIso8601String(),
      };

  factory EvidenciaChecklistSalida.fromJson(Map<String, dynamic> json) {
    return EvidenciaChecklistSalida(
      id: json['id'] as String? ?? '',
      rutaLocal: json['rutaLocal'] as String? ?? '',
      descripcion: json['descripcion'] as String?,
      capturadaEn: DateTime.tryParse(json['capturadaEn'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
