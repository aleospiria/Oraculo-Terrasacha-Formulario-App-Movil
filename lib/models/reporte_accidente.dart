class ReporteAccidente {
  // Metadata
  final String id;
  DateTime fechaCreacion;
  DateTime fechaModificacion;

  // 1. Información del empleador
  String razonSocial;
  String nit;
  String direccion;
  String telefono;
  String arl;
  String actividadEconomica;

  // 2. Información del trabajador / contratista
  String trabajadorNombre;
  String trabajadorTipoId;
  String trabajadorNumeroId;
  String trabajadorCargo;
  String trabajadorTipoContrato;
  String trabajadorAntiguedad;
  String trabajadorTelefono;

  // 3. Información de la visita de campo
  String predioNombre;
  String predioMunicipio;
  String predioDepartamento;
  String visitaTipoActividad;

  // 4. Información del accidente
  DateTime accidenteFecha;
  String accidenteMes; // auto
  String accidenteHora;
  String accidenteLugarCoordenadas;
  String accidenteTipo;
  String? accidenteTipoOtro;
  String accidenteDescripcion;
  String accidenteParteCuerpo;
  String accidenteTipoLesion;
  bool accidenteAtencionMedica;
  String accidenteCentroAsistencial;
  bool accidenteIncapacidad;
  int? accidenteDiasIncapacidad;
  bool accidenteChequeoPreop;
  String? accidenteResultadoChequeo;
  String accidenteCausaPrincipal;

  // 5. Condiciones del entorno
  String entornoClima;
  String entornoTerreno;
  bool entornoUsoEPP;
  String entornoTipoRiesgo;

  // 6. Testigos
  String? testigoNombre;
  String? testigoContacto;

  // 7. Datos del reporte
  String reporteNombre;
  String reporteCargo;
  DateTime reporteFecha;
  String reporteFirma;

  ReporteAccidente({
    required this.id,
    DateTime? fechaCreacion,
    DateTime? fechaModificacion,
    this.razonSocial = '',
    this.nit = '',
    this.direccion = '',
    this.telefono = '',
    this.arl = '',
    this.actividadEconomica = '',
    this.trabajadorNombre = '',
    this.trabajadorTipoId = 'CC',
    this.trabajadorNumeroId = '',
    this.trabajadorCargo = '',
    this.trabajadorTipoContrato = '',
    this.trabajadorAntiguedad = '',
    this.trabajadorTelefono = '',
    this.predioNombre = '',
    this.predioMunicipio = '',
    this.predioDepartamento = '',
    this.visitaTipoActividad = '',
    DateTime? accidenteFecha,
    this.accidenteMes = '',
    this.accidenteHora = '',
    this.accidenteLugarCoordenadas = '',
    this.accidenteTipo = '',
    this.accidenteTipoOtro,
    this.accidenteDescripcion = '',
    this.accidenteParteCuerpo = '',
    this.accidenteTipoLesion = '',
    this.accidenteAtencionMedica = false,
    this.accidenteCentroAsistencial = '',
    this.accidenteIncapacidad = false,
    this.accidenteDiasIncapacidad,
    this.accidenteChequeoPreop = false,
    this.accidenteResultadoChequeo,
    this.accidenteCausaPrincipal = '',
    this.entornoClima = '',
    this.entornoTerreno = '',
    this.entornoUsoEPP = false,
    this.entornoTipoRiesgo = '',
    this.testigoNombre,
    this.testigoContacto,
    this.reporteNombre = '',
    this.reporteCargo = '',
    DateTime? reporteFecha,
    this.reporteFirma = '',
  })  : fechaCreacion = fechaCreacion ?? DateTime.now(),
        fechaModificacion = fechaModificacion ?? DateTime.now(),
        accidenteFecha = accidenteFecha ?? DateTime.now(),
        reporteFecha = reporteFecha ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'fechaCreacion': fechaCreacion.toIso8601String(),
    'fechaModificacion': fechaModificacion.toIso8601String(),
    'razonSocial': razonSocial,
    'nit': nit,
    'direccion': direccion,
    'telefono': telefono,
    'arl': arl,
    'actividadEconomica': actividadEconomica,
    'trabajadorNombre': trabajadorNombre,
    'trabajadorTipoId': trabajadorTipoId,
    'trabajadorNumeroId': trabajadorNumeroId,
    'trabajadorCargo': trabajadorCargo,
    'trabajadorTipoContrato': trabajadorTipoContrato,
    'trabajadorAntiguedad': trabajadorAntiguedad,
    'trabajadorTelefono': trabajadorTelefono,
    'predioNombre': predioNombre,
    'predioMunicipio': predioMunicipio,
    'predioDepartamento': predioDepartamento,
    'visitaTipoActividad': visitaTipoActividad,
    'accidenteFecha': accidenteFecha.toIso8601String(),
    'accidenteMes': accidenteMes,
    'accidenteHora': accidenteHora,
    'accidenteLugarCoordenadas': accidenteLugarCoordenadas,
    'accidenteTipo': accidenteTipo,
    'accidenteTipoOtro': accidenteTipoOtro,
    'accidenteDescripcion': accidenteDescripcion,
    'accidenteParteCuerpo': accidenteParteCuerpo,
    'accidenteTipoLesion': accidenteTipoLesion,
    'accidenteAtencionMedica': accidenteAtencionMedica,
    'accidenteCentroAsistencial': accidenteCentroAsistencial,
    'accidenteIncapacidad': accidenteIncapacidad,
    'accidenteDiasIncapacidad': accidenteDiasIncapacidad,
    'accidenteChequeoPreop': accidenteChequeoPreop,
    'accidenteResultadoChequeo': accidenteResultadoChequeo,
    'accidenteCausaPrincipal': accidenteCausaPrincipal,
    'entornoClima': entornoClima,
    'entornoTerreno': entornoTerreno,
    'entornoUsoEPP': entornoUsoEPP,
    'entornoTipoRiesgo': entornoTipoRiesgo,
    'testigoNombre': testigoNombre,
    'testigoContacto': testigoContacto,
    'reporteNombre': reporteNombre,
    'reporteCargo': reporteCargo,
    'reporteFecha': reporteFecha.toIso8601String(),
    'reporteFirma': reporteFirma,
  };

  factory ReporteAccidente.fromJson(Map<String, dynamic> json) => ReporteAccidente(
    id: json['id'] as String,
    fechaCreacion: DateTime.parse(json['fechaCreacion'] as String),
    fechaModificacion: DateTime.parse(json['fechaModificacion'] as String),
    razonSocial: json['razonSocial'] as String? ?? '',
    nit: json['nit'] as String? ?? '',
    direccion: json['direccion'] as String? ?? '',
    telefono: json['telefono'] as String? ?? '',
    arl: json['arl'] as String? ?? '',
    actividadEconomica: json['actividadEconomica'] as String? ?? '',
    trabajadorNombre: json['trabajadorNombre'] as String? ?? '',
    trabajadorTipoId: json['trabajadorTipoId'] as String? ?? 'CC',
    trabajadorNumeroId: json['trabajadorNumeroId'] as String? ?? '',
    trabajadorCargo: json['trabajadorCargo'] as String? ?? '',
    trabajadorTipoContrato: json['trabajadorTipoContrato'] as String? ?? '',
    trabajadorAntiguedad: json['trabajadorAntiguedad'] as String? ?? '',
    trabajadorTelefono: json['trabajadorTelefono'] as String? ?? '',
    predioNombre: json['predioNombre'] as String? ?? '',
    predioMunicipio: json['predioMunicipio'] as String? ?? '',
    predioDepartamento: json['predioDepartamento'] as String? ?? '',
    visitaTipoActividad: json['visitaTipoActividad'] as String? ?? '',
    accidenteFecha: json['accidenteFecha'] != null ? DateTime.parse(json['accidenteFecha'] as String) : DateTime.now(),
    accidenteMes: json['accidenteMes'] as String? ?? '',
    accidenteHora: json['accidenteHora'] as String? ?? '',
    accidenteLugarCoordenadas: json['accidenteLugarCoordenadas'] as String? ?? '',
    accidenteTipo: json['accidenteTipo'] as String? ?? '',
    accidenteTipoOtro: json['accidenteTipoOtro'] as String?,
    accidenteDescripcion: json['accidenteDescripcion'] as String? ?? '',
    accidenteParteCuerpo: json['accidenteParteCuerpo'] as String? ?? '',
    accidenteTipoLesion: json['accidenteTipoLesion'] as String? ?? '',
    accidenteAtencionMedica: json['accidenteAtencionMedica'] as bool? ?? false,
    accidenteCentroAsistencial: json['accidenteCentroAsistencial'] as String? ?? '',
    accidenteIncapacidad: json['accidenteIncapacidad'] as bool? ?? false,
    accidenteDiasIncapacidad: json['accidenteDiasIncapacidad'] as int?,
    accidenteChequeoPreop: json['accidenteChequeoPreop'] as bool? ?? false,
    accidenteResultadoChequeo: json['accidenteResultadoChequeo'] as String?,
    accidenteCausaPrincipal: json['accidenteCausaPrincipal'] as String? ?? '',
    entornoClima: json['entornoClima'] as String? ?? '',
    entornoTerreno: json['entornoTerreno'] as String? ?? '',
    entornoUsoEPP: json['entornoUsoEPP'] as bool? ?? false,
    entornoTipoRiesgo: json['entornoTipoRiesgo'] as String? ?? '',
    testigoNombre: json['testigoNombre'] as String?,
    testigoContacto: json['testigoContacto'] as String?,
    reporteNombre: json['reporteNombre'] as String? ?? '',
    reporteCargo: json['reporteCargo'] as String? ?? '',
    reporteFecha: json['reporteFecha'] != null ? DateTime.parse(json['reporteFecha'] as String) : DateTime.now(),
    reporteFirma: json['reporteFirma'] as String? ?? '',
  );

  ReporteAccidente copyWith({String? id}) => ReporteAccidente(
    id: id ?? this.id,
    fechaCreacion: fechaCreacion,
    fechaModificacion: DateTime.now(),
    razonSocial: razonSocial,
    nit: nit,
    direccion: direccion,
    telefono: telefono,
    arl: arl,
    actividadEconomica: actividadEconomica,
    trabajadorNombre: trabajadorNombre,
    trabajadorTipoId: trabajadorTipoId,
    trabajadorNumeroId: trabajadorNumeroId,
    trabajadorCargo: trabajadorCargo,
    trabajadorTipoContrato: trabajadorTipoContrato,
    trabajadorAntiguedad: trabajadorAntiguedad,
    trabajadorTelefono: trabajadorTelefono,
    predioNombre: predioNombre,
    predioMunicipio: predioMunicipio,
    predioDepartamento: predioDepartamento,
    visitaTipoActividad: visitaTipoActividad,
    accidenteFecha: accidenteFecha,
    accidenteMes: accidenteMes,
    accidenteHora: accidenteHora,
    accidenteLugarCoordenadas: accidenteLugarCoordenadas,
    accidenteTipo: accidenteTipo,
    accidenteTipoOtro: accidenteTipoOtro,
    accidenteDescripcion: accidenteDescripcion,
    accidenteParteCuerpo: accidenteParteCuerpo,
    accidenteTipoLesion: accidenteTipoLesion,
    accidenteAtencionMedica: accidenteAtencionMedica,
    accidenteCentroAsistencial: accidenteCentroAsistencial,
    accidenteIncapacidad: accidenteIncapacidad,
    accidenteDiasIncapacidad: accidenteDiasIncapacidad,
    accidenteChequeoPreop: accidenteChequeoPreop,
    accidenteResultadoChequeo: accidenteResultadoChequeo,
    accidenteCausaPrincipal: accidenteCausaPrincipal,
    entornoClima: entornoClima,
    entornoTerreno: entornoTerreno,
    entornoUsoEPP: entornoUsoEPP,
    entornoTipoRiesgo: entornoTipoRiesgo,
    testigoNombre: testigoNombre,
    testigoContacto: testigoContacto,
    reporteNombre: reporteNombre,
    reporteCargo: reporteCargo,
    reporteFecha: reporteFecha,
    reporteFirma: reporteFirma,
  );

  static const List<String> tiposIdentificacion = ['CC', 'CE', 'Pasaporte', 'NIT'];
  static const List<String> tiposActividad = [
    'Inventario forestal', 'Siembra', 'Mantenimiento',
    'Aprovechamiento', 'Monitoreo IoT', 'Supervisión', 'Otra',
  ];
  static const List<String> tiposAccidente = [
    'Caída al mismo nivel', 'Caída a diferente nivel',
    'Accidente con herramienta o equipo', 'Mordedura / picadura de animal',
    'Accidente de tránsito', 'Exposición a condiciones climáticas extremas', 'Otro',
  ];
  static const List<String> partesCuerpo = [
    'Cabeza', 'Ojo', 'Cuello', 'Hombro', 'Brazo', 'Codo',
    'Antebrazo', 'Muñeca', 'Mano', 'Dedo', 'Tórax', 'Espalda',
    'Abdomen', 'Cadera', 'Pierna', 'Rodilla', 'Tobillo', 'Pie',
  ];
  static const List<String> tiposLesion = [
    'Esguince', 'Fractura', 'Cortadura', 'Contusión', 'Luxación',
    'Quemadura', 'Intoxicación', 'Picadura', 'Laceración', 'Abrasión', 'Otra',
  ];
  static const List<String> causasPrincipales = [
    'Terreno', 'Herramienta', 'EPP', 'Factor humano', 'Clima', 'Otra',
  ];
  static const List<String> climas = [
    'Soleado', 'Nublado', 'Lluvia', 'Alta humedad', 'Viento fuerte', 'Niebla',
  ];
  static const List<String> terrenos = [
    'Irregular', 'Fangoso', 'Pendiente', 'Plano', 'Rocoso', 'Resbaloso',
  ];
  static const List<String> tiposRiesgo = [
    'Biológico', 'Físico', 'Químico', 'Ergonómico', 'Mecánico', 'Psicosocial', 'Otro',
  ];
  static const List<String> resultadosChequeo = ['Apto', 'No Apto'];
  static const List<String> meses = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
  ];

  static String mesFromDate(DateTime date) => meses[date.month - 1];
  static String horaFromDate(DateTime date) =>
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}
