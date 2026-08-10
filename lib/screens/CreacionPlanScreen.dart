import '../theme.dart';
// lib/Screens/CreacionPlanScreen.dart
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../main.dart';
import '../models/lista_chequeo.dart';
import '../models/plan_campo_borrador.dart';
import '../models/usuario_campo.dart';
import '../utils/geojson_topology_helpers.dart';
import '../utils/servicio_salida.dart';
import '../utils/servicio_lista_chequeo.dart';
import '../utils/servicio_plantillas.dart';
import '../config/crear_usuario_lambda_config.dart';
import '../utils/flujo_asignacion_plantilla.dart';
import '../utils/roles_campo.dart';
import '../utils/servicio_usuarios_campo.dart';
import '../widgets/asignacion_plantilla_sheet.dart';
import '../widgets/mapa_subarea_widget.dart';
import '../widgets/selector_topologia_sheet.dart';
import 'EditorListaChequeoScreen.dart';

class CreacionPlanScreen extends StatefulWidget {
  final SalidaCampo? salidaInicial;
  final int pasoInicial;

  const CreacionPlanScreen({
    super.key,
    this.salidaInicial,
    this.pasoInicial = 1,
  });

  @override
  State<CreacionPlanScreen> createState() => _CreacionPlanScreenState();
}

class _CreacionPlanScreenState extends State<CreacionPlanScreen> {
  final Color primaryColor = terrasachaPrimaryColor;
  final Color backgroundColor = terrasachaBackgroundColor;
  final Color cardColor = terrasachaCardColor;
  final Color accentColor = const Color(0xFFC8A97A); // dorado pasos inactivos

  int _pasoActual = 1; // 1-4, luego 5 = resumen
  final int _totalPasos = 4;

  // ── Datos del plan que se van acumulando paso a paso ──────────────────────
  final TextEditingController _nombrePlanCtrl = TextEditingController();
  String? _proyectoId;
  String? _proyectoNombre;
  String? _topologiaId;
  String? _ubicacionRuta;
  String? _poligonoPadreGeoJson;
  List<LatLng> _poligonoPadreLatLng = [];
  final List<SubAreaPlanDia> _subAreasPorDia = [];
  DateTime? _fechaInicioPlan;
  DateTime? _fechaFinPlan;
  DateTime? _fechaSubareaEditando;
  List<LatLng> _puntosSubareaActual = [];
  /// El usuario opta por dibujar subáreas; por defecto es opcional (apagado).
  bool _definirSubareas = false;

  final List<_UsuarioPlan> _usuariosSeleccionados = [];
  ListaChequeo? _listaChequeoSeleccionada;
  List<ListaChequeo> _listasChequeoDisponibles = [];
  bool _cargandoListasChequeo = false;

  List<PlantillaConFeatures> _plantillasDisponibles = [];
  bool _cargandoPlantillas = false;
  String? _errorPlantillas;
  final List<AsignacionPlantillaPlan> _asignacionesPlantillas = [];

  final List<_UsuarioPlan> _usuariosDisponibles = [
    _UsuarioPlan(nombre: 'Juan Pérez', rol: 'Operador'),
    _UsuarioPlan(nombre: 'María Rodríguez', rol: 'Jefe de cuadrilla'),
    _UsuarioPlan(nombre: 'Carlos Gómez', rol: 'Operador'),
    _UsuarioPlan(nombre: 'Ana Silva', rol: 'Operador'),
    _UsuarioPlan(nombre: 'Pedro Ramos', rol: 'Operador'),
  ];

  bool _usuariosApiCargados = false;
  final Set<String> _usuariosActualizandoRol = {};
  /// Activado por defecto: la salida exige chequeo de transporte.
  bool _requiereChequeoVehiculo = true;

  String _busquedaUsuario = '';
  String? _salidaIdEnEdicion;

  @override
  void initState() {
    super.initState();
    _pasoActual = widget.pasoInicial.clamp(1, 6);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!hasRole('lider_proyecto')) {
        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solo el líder de proyecto puede crear planes'),
          ),
        );
        return;
      }
      if (widget.salidaInicial != null) {
        await _hidratarDesdeSalida(widget.salidaInicial!);
      } else {
        await _cargarUsuariosEquipoSiNecesario();
      }
    });
  }

  Future<void> _cargarUsuariosEquipoSiNecesario() async {
    if (!CrearUsuarioLambdaConfig.isConfigured) {
      return;
    }
    if (_usuariosApiCargados) {
      return;
    }

    final resultado = await ServicioUsuariosCampo.listarUsuarios();
    if (!mounted) return;

    if (resultado['exito'] == true) {
      final lista = <_UsuarioPlan>[];
      for (final item in resultado['usuarios'] as List<dynamic>? ?? []) {
        if (item is! Map<String, dynamic>) continue;
        final usuario = UsuarioCampo.fromApi(item);
        if (!RolesCampo.puedeRecibirPlantilla(usuario.rolCognito)) continue;
        lista.add(
          _UsuarioPlan(
            userId: usuario.id,
            nombre: usuario.nombre,
            rol: RolesCampo.etiquetaParaDropdown(usuario.rolDisplay),
          ),
        );
      }
      if (lista.isNotEmpty) {
        setState(() {
          _usuariosDisponibles
            ..clear()
            ..addAll(lista);
        });
      }
    }

    _usuariosApiCargados = true;
  }

  Future<void> _hidratarDesdeSalida(SalidaCampo salida) async {
    _salidaIdEnEdicion = salida.id;
    _nombrePlanCtrl.text = salida.nombre;
    _fechaInicioPlan = salida.fechaInicio;
    _fechaFinPlan = salida.fechaFin;
    _proyectoId = salida.proyectoId;
    _proyectoNombre = salida.proyectoNombre;
    _topologiaId = salida.topologiaId;
    _ubicacionRuta = salida.ubicacionRuta;
    _poligonoPadreGeoJson = salida.poligonoPadreGeoJson;
    _poligonoPadreLatLng = parseGeoJsonPolygonRing(salida.poligonoPadreGeoJson);
    _subAreasPorDia
      ..clear()
      ..addAll(salida.subAreasPorDia);
    _definirSubareas = salida.subAreasPorDia.isNotEmpty;
    _usuariosSeleccionados
      ..clear()
      ..addAll(
        salida.equipo.map(_usuarioPlanDesdeMiembro),
      );
    _asignacionesPlantillas
      ..clear()
      ..addAll(
        salida.asignacionesPlantillas.map(_normalizarAsignacion),
      );
    _requiereChequeoVehiculo = salida.requiereChequeoVehiculo;

    await _cargarUsuariosEquipoSiNecesario();

    if (salida.checklist != null) {
      await _cargarListasChequeoSiNecesario();
      final listaId = salida.checklist!.listaId;
      ListaChequeo? encontrada;
      for (final l in _listasChequeoDisponibles) {
        if (l.id == listaId) {
          encontrada = l;
          break;
        }
      }
      _listaChequeoSeleccionada = encontrada ??
          ListaChequeo(
            id: salida.checklist!.listaId,
            nombre: salida.checklist!.nombre,
            descripcion: '',
            origen: OrigenListaChequeo.administrador,
            creadoEn: DateTime.now(),
            actualizadoEn: DateTime.now(),
            items: salida.checklist!.items,
          );
    }

    if (_pasoActual >= 4) {
      await _cargarPlantillasSiNecesario();
    }

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _nombrePlanCtrl.dispose();
    super.dispose();
  }

  // ── Navegación entre pasos ────────────────────────────────────────────────

  void _continuar() {
    if (_pasoActual == 1) {
      if (_nombrePlanCtrl.text.trim().isEmpty) {
        _mostrarError('Por favor ingresa el nombre del plan');
        return;
      }
      if (_fechaInicioPlan == null || _fechaFinPlan == null) {
        _mostrarError('Selecciona la fecha de inicio y fin del plan');
        return;
      }
      if (_fechaFinPlan!.isBefore(_fechaInicioPlan!)) {
        _mostrarError('La fecha de fin debe ser posterior o igual a la de inicio');
        return;
      }
      if (_topologiaId == null || _ubicacionRuta == null) {
        _mostrarError('Selecciona una ubicación en la topología');
        return;
      }
      // Subáreas son opcionales: si hay dibujo a medias, se descarta al continuar.
      if (_fechaSubareaEditando != null || _puntosSubareaActual.isNotEmpty) {
        _cancelarEdicionSubarea();
      }
      final fueraDeRango = _subAreasPorDia.where(
        (s) => !_fechaEstaEnRangoPlan(s.fecha),
      );
      if (fueraDeRango.isNotEmpty) {
        _mostrarError(
          'Las subáreas deben estar entre ${_formatFecha(_fechaInicioPlan!)} y ${_formatFecha(_fechaFinPlan!)}',
        );
        return;
      }
    }
    if (_pasoActual == 2) {
      if (_usuariosSeleccionados.isEmpty) {
        _mostrarError('Selecciona al menos un miembro del equipo');
        return;
      }
      if (_responsablesPlantilla.isEmpty) {
        _mostrarError(
          'Inclúyete como jefe de cuadrilla o agrega operadores al equipo',
        );
        return;
      }
    }
    if (_pasoActual == 3) {
      if (_listaChequeoSeleccionada == null) {
        _mostrarError('Selecciona o crea una lista de chequeo');
        return;
      }
    }
    if (_pasoActual == 4) {
      if (_asignacionesPlantillas.isEmpty) {
        _mostrarError('Agrega al menos una asignación de plantilla');
        return;
      }
    }
    setState(() {
      if (_pasoActual < _totalPasos) {
        _pasoActual++;
        if (_pasoActual == 3) {
          _cargarListasChequeoSiNecesario();
        }
        if (_pasoActual == 2) {
          _cargarUsuariosEquipoSiNecesario();
        }
        if (_pasoActual == 4) {
          _cargarPlantillasSiNecesario();
        }
      } else {
        _pasoActual = 5;
      }
    });
  }

  List<_UsuarioPlan> get _operadoresSeleccionados => _usuariosSeleccionados
      .where((u) => RolesCampo.esOperador(u.rol))
      .toList();

  /// Personas a las que se puede asignar una plantilla: operadores + jefe(s) de cuadrilla.
  List<_UsuarioPlan> get _responsablesPlantilla {
    final porClave = <String, _UsuarioPlan>{};
    for (final u in _usuariosSeleccionados) {
      if (!RolesCampo.esOperador(u.rol) &&
          !RolesCampo.esLiderCuadrilla(u.rol)) {
        continue;
      }
      final clave = u.userId.isNotEmpty ? u.userId : u.nombre.toLowerCase();
      porClave[clave] = u;
    }
    return porClave.values.toList();
  }


  Future<void> _cargarListasChequeoSiNecesario() async {
    if (_cargandoListasChequeo) return;

    setState(() => _cargandoListasChequeo = true);

    try {
      final listas = await ServicioListaChequeo.cargarDisponibles();
      if (!mounted) return;
      setState(() {
        _listasChequeoDisponibles = listas;
        _cargandoListasChequeo = false;
        if (_listaChequeoSeleccionada != null) {
          final id = _listaChequeoSeleccionada!.id;
          ListaChequeo? actualizada;
          for (final l in listas) {
            if (l.id == id) {
              actualizada = l;
              break;
            }
          }
          _listaChequeoSeleccionada = actualizada;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _cargandoListasChequeo = false);
      _mostrarError('No se pudieron cargar las listas: $e');
    }
  }

  List<ListaChequeo> get _listasAdmin => _listasChequeoDisponibles
      .where((l) => l.esDelAdministrador)
      .toList();

  List<ListaChequeo> get _listasPropias => _listasChequeoDisponibles
      .where((l) => !l.esDelAdministrador)
      .toList();

  void _seleccionarListaChequeo(ListaChequeo lista) {
    setState(() => _listaChequeoSeleccionada = lista);
  }

  Future<void> _abrirCrearListaChequeo() async {
    final resultado = await Navigator.push<Object?>(
      context,
      MaterialPageRoute(
        builder: (_) => EditorListaChequeoScreen(primaryColor: primaryColor),
      ),
    );

    if (!mounted || resultado == null) return;

    if (resultado is NuevaListaChequeoDatos) {
      try {
        final creada = await ServicioListaChequeo.crear(
          nombre: resultado.nombre,
          descripcion: resultado.descripcion,
          items: resultado.items,
        );
        if (!mounted) return;
        setState(() {
          _listasChequeoDisponibles = [..._listasChequeoDisponibles, creada];
          _listaChequeoSeleccionada = creada;
        });
      } catch (e) {
        _mostrarError('No se pudo crear la lista: $e');
      }
    }
  }

  Future<void> _abrirEditarListaChequeo(ListaChequeo lista) async {
    final resultado = await Navigator.push<ListaChequeo?>(
      context,
      MaterialPageRoute(
        builder: (_) => EditorListaChequeoScreen(
          primaryColor: primaryColor,
          listaInicial: lista,
        ),
      ),
    );

    if (!mounted || resultado == null) return;

    try {
      final actualizada = await ServicioListaChequeo.actualizar(resultado);
      if (!mounted) return;
      setState(() {
        final index =
            _listasChequeoDisponibles.indexWhere((l) => l.id == actualizada.id);
        if (index >= 0) {
          _listasChequeoDisponibles[index] = actualizada;
        }
        if (_listaChequeoSeleccionada?.id == actualizada.id) {
          _listaChequeoSeleccionada = actualizada;
        }
      });
    } catch (e) {
      _mostrarError('No se pudo actualizar: $e');
    }
  }

  Future<void> _confirmarEliminarLista(ListaChequeo lista) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar lista'),
        content: Text(
          '¿Eliminar "${lista.nombre}"? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    try {
      await ServicioListaChequeo.eliminar(lista.id);
      if (!mounted) return;
      setState(() {
        _listasChequeoDisponibles
            .removeWhere((l) => l.id == lista.id);
        if (_listaChequeoSeleccionada?.id == lista.id) {
          _listaChequeoSeleccionada = null;
        }
      });
    } catch (e) {
      _mostrarError('No se pudo eliminar: $e');
    }
  }

  IconData _iconoItemChecklist(String icono) {
    switch (icono) {
      case 'casco':
        return Icons.safety_check_outlined;
      case 'sensor':
        return Icons.build_outlined;
      case 'gps':
        return Icons.location_on_outlined;
      default:
        return Icons.check_circle_outline;
    }
  }

  Future<void> _cargarPlantillasSiNecesario() async {
    if (_cargandoPlantillas || _plantillasDisponibles.isNotEmpty) return;

    setState(() {
      _cargandoPlantillas = true;
      _errorPlantillas = null;
    });

    try {
      final plantillas = await ServicioPlantillas.cargarPlantillasConFeatures();
      if (!mounted) return;
      setState(() {
        _plantillasDisponibles = plantillas;
        _cargandoPlantillas = false;
        if (plantillas.isEmpty) {
          _errorPlantillas =
              'No hay plantillas disponibles. Créalas en ModelAI (ej. PLANTILLA_MARCAR_ARBOL).';
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cargandoPlantillas = false;
        _errorPlantillas = 'No se pudieron cargar las plantillas: $e';
      });
    }
  }

  Future<void> _abrirNuevaAsignacion({int? indiceEdicion}) async {
    if (_responsablesPlantilla.isEmpty) {
      _mostrarError(
        'Agrega operadores al equipo o inclúyete como jefe de cuadrilla (paso 2)',
      );
      return;
    }
    if (_plantillasDisponibles.isEmpty) {
      await _cargarPlantillasSiNecesario();
      if (!mounted) return;
      if (_plantillasDisponibles.isEmpty) {
        _mostrarError(_errorPlantillas ?? 'Sin plantillas disponibles');
        return;
      }
    }

    final dias = ServicioSalida.diasDesdeRango(
      fechaInicio: _fechaInicioPlan,
      fechaFin: _fechaFinPlan,
    );
    final requiereDia = dias.length > 1;
    final responsables = _responsablesPlantilla
        .map(_responsableParaSheet)
        .toList();

    AsignacionPlantillaSheetDatos? iniciales;
    String? excluirAsignacionId;
    if (indiceEdicion != null) {
      final a = _normalizarAsignacion(_asignacionesPlantillas[indiceEdicion]);
      excluirAsignacionId = a.id;
      iniciales = AsignacionPlantillaSheetDatos(
        templateId: a.templateId,
        templateNombre: a.templateNombre,
        featureIds: List<String>.from(a.featureIds),
        featureNombres: List<String>.from(a.featureNombres),
        operadorNombre: a.operadorNombre,
        operadorRol: a.operadorRol,
        responsableUserId: a.responsableUserId,
        fechaSubArea: a.fechaSubArea,
      );
    }

    final resultado = await AsignacionPlantillaSheet.mostrar(
      context,
      primaryColor: primaryColor,
      plantillas: _plantillasDisponibles,
      responsables: responsables,
      diasSalida: dias,
      asignacionesExistentes: _asignacionesPlantillas,
      excluirAsignacionId: excluirAsignacionId,
      requiereDia: requiereDia,
      datosIniciales: iniciales,
    );

    if (resultado == null || !mounted) return;

    final asignacion = FlujoAsignacionPlantilla.asignacionDesdeSheet(
      resultado,
      id: indiceEdicion != null
          ? _asignacionesPlantillas[indiceEdicion].id
          : null,
    );

    try {
      ServicioSalida.validarAsignacionPlantillaPorDia(
        dias: dias,
        asignaciones: _asignacionesPlantillas,
        asignacion: asignacion,
        excluirAsignacionId: excluirAsignacionId,
      );
    } catch (e) {
      if (!mounted) return;
      _mostrarError(e.toString().replaceFirst('Bad state: ', ''));
      return;
    }

    setState(() {
      final base = indiceEdicion != null
          ? List<AsignacionPlantillaPlan>.from(_asignacionesPlantillas)
          : [..._asignacionesPlantillas, asignacion];
      if (indiceEdicion != null) {
        base[indiceEdicion] = asignacion;
      }
      _asignacionesPlantillas
        ..clear()
        ..addAll(
          ServicioSalida.reasignarFeaturesEnMemoria(
            asignaciones: base,
            destino: asignacion,
          ),
        );
    });
  }

  void _eliminarAsignacion(int index) {
    setState(() => _asignacionesPlantillas.removeAt(index));
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _abrirSelectorUbicacion() async {
    final resultado = await SelectorTopologiaSheet.mostrar(
      context,
      primaryColor: primaryColor,
    );
    if (resultado == null || !mounted) return;

    final padreLatLng =
        parseGeoJsonPolygonRing(resultado.poligonoPadreGeoJson);

    setState(() {
      _proyectoId = resultado.proyecto.id;
      _proyectoNombre = resultado.proyecto.name;
      _topologiaId = resultado.topologia.id;
      _ubicacionRuta = resultado.etiquetaRuta;
      _poligonoPadreGeoJson = resultado.poligonoPadreGeoJson;
      _poligonoPadreLatLng = padreLatLng;
      _subAreasPorDia.clear();
      _fechaSubareaEditando = null;
      _puntosSubareaActual = [];
      _definirSubareas = false;
    });

    if (padreLatLng.isEmpty && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'La topología no tiene polígono. Puedes continuar sin subáreas o defínelo en la web.',
          ),
          backgroundColor: primaryColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _elegirFechaSubarea({DateTime? fechaSugerida}) async {
    if (_fechaInicioPlan == null || _fechaFinPlan == null) {
      _mostrarError('Define primero las fechas de inicio y fin del plan');
      return;
    }

    DateTime? fecha = fechaSugerida;
    if (fecha == null) {
      fecha = await showDatePicker(
        context: context,
        initialDate: _fechaSubareaEditando ?? _fechaInicioPlan!,
        firstDate: _fechaInicioPlan!,
        lastDate: _fechaFinPlan!,
        helpText: 'Día de trabajo en campo',
      );
    }
    if (fecha == null || !mounted) return;

    final dia = _soloFecha(fecha);
    if (!_fechaEstaEnRangoPlan(dia)) {
      _mostrarError('La fecha debe estar dentro de la vigencia del plan');
      return;
    }

    _abrirDiaSubarea(dia);
  }

  void _abrirDiaSubarea(DateTime dia) {
    final idx = _indiceSubareaDelDia(dia);
    final puntos = idx >= 0
        ? parseGeoJsonPolygonRing(_subAreasPorDia[idx].subAreaGeoJson)
        : <LatLng>[];

    setState(() {
      _definirSubareas = true;
      _fechaSubareaEditando = _soloFecha(dia);
      _puntosSubareaActual = List<LatLng>.from(puntos);
    });
  }

  int _indiceSubareaDelDia(DateTime dia) {
    return _subAreasPorDia.indexWhere(
      (s) =>
          s.fecha.year == dia.year &&
          s.fecha.month == dia.month &&
          s.fecha.day == dia.day,
    );
  }

  bool get _editandoSubareaExistente {
    if (_fechaSubareaEditando == null) return false;
    return _indiceSubareaDelDia(_fechaSubareaEditando!) >= 0;
  }

  void _cancelarEdicionSubarea() {
    setState(() {
      _fechaSubareaEditando = null;
      _puntosSubareaActual = [];
    });
  }

  void _guardarSubareaDia() {
    if (_fechaSubareaEditando == null) {
      _mostrarError('Selecciona primero un día');
      return;
    }
    if (_puntosSubareaActual.length < 3) {
      _mostrarError('La subárea necesita al menos 3 puntos en el mapa');
      return;
    }
    if (_poligonoPadreLatLng.length >= 3 &&
        !isPolygonContainedInParent(
          _puntosSubareaActual,
          _poligonoPadreLatLng,
        )) {
      _mostrarError('La subárea debe estar dentro del polígono padre (azul)');
      return;
    }

    final geoJson = encodeGeoJsonPolygon(_puntosSubareaActual);
    final dia = _fechaSubareaEditando!;
    final idx = _indiceSubareaDelDia(dia);
    final actualizando = idx >= 0;

    setState(() {
      final item = SubAreaPlanDia(fecha: dia, subAreaGeoJson: geoJson);
      if (actualizando) {
        _subAreasPorDia[idx] = item;
      } else {
        _subAreasPorDia.add(item);
      }
      _subAreasPorDia.sort((a, b) => a.fecha.compareTo(b.fecha));
      _fechaSubareaEditando = null;
      _puntosSubareaActual = [];
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            actualizando ? 'Subárea actualizada' : 'Subárea guardada',
          ),
          backgroundColor: primaryColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _eliminarSubarea(int index) {
    final eliminada = _subAreasPorDia[index];
    setState(() {
      _subAreasPorDia.removeAt(index);
      if (_fechaSubareaEditando != null &&
          _fechaSubareaEditando!.year == eliminada.fecha.year &&
          _fechaSubareaEditando!.month == eliminada.fecha.month &&
          _fechaSubareaEditando!.day == eliminada.fecha.day) {
        _fechaSubareaEditando = null;
        _puntosSubareaActual = [];
      }
    });
  }

  List<DateTime> get _diasDelPlan {
    if (_fechaInicioPlan == null || _fechaFinPlan == null) return [];
    final dias = <DateTime>[];
    var d = _soloFecha(_fechaInicioPlan!);
    final fin = _soloFecha(_fechaFinPlan!);
    // Limitar chips visibles a 60 días para no saturar la UI.
    var guard = 0;
    while (!d.isAfter(fin) && guard < 60) {
      dias.add(d);
      d = d.add(const Duration(days: 1));
      guard++;
    }
    return dias;
  }

  bool _diaTieneSubarea(DateTime dia) {
    return _subAreasPorDia.any(
      (s) =>
          s.fecha.year == dia.year &&
          s.fecha.month == dia.month &&
          s.fecha.day == dia.day,
    );
  }

  String _formatFecha(DateTime fecha) {
    final d = fecha.day.toString().padLeft(2, '0');
    final m = fecha.month.toString().padLeft(2, '0');
    return '$d/$m/${fecha.year}';
  }

  DateTime _soloFecha(DateTime fecha) =>
      DateTime(fecha.year, fecha.month, fecha.day);

  bool _fechaEstaEnRangoPlan(DateTime fecha) {
    if (_fechaInicioPlan == null || _fechaFinPlan == null) return true;
    final f = _soloFecha(fecha);
    return !f.isBefore(_fechaInicioPlan!) && !f.isAfter(_fechaFinPlan!);
  }

  Future<void> _elegirFechaPlan({required bool esInicio}) async {
    final hoy = _soloFecha(DateTime.now());
    final fechaActual = esInicio ? _fechaInicioPlan : _fechaFinPlan;

    final fecha = await showDatePicker(
      context: context,
      initialDate: fechaActual ?? hoy,
      firstDate: hoy.subtract(const Duration(days: 1)),
      lastDate: hoy.add(const Duration(days: 365 * 5)),
      helpText: esInicio ? 'Fecha de inicio del plan' : 'Fecha de fin del plan',
    );
    if (fecha == null || !mounted) return;

    final normalizada = _soloFecha(fecha);

    if (!esInicio &&
        _fechaInicioPlan != null &&
        normalizada.isBefore(_fechaInicioPlan!)) {
      _mostrarError('La fecha de fin no puede ser anterior a la de inicio');
      return;
    }

    setState(() {
      if (esInicio) {
        _fechaInicioPlan = normalizada;
        if (_fechaFinPlan != null && _fechaFinPlan!.isBefore(normalizada)) {
          _fechaFinPlan = normalizada;
        }
      } else {
        _fechaFinPlan = normalizada;
      }
    });
  }

  Widget _buildSelectorFechaPlan({
    required String etiqueta,
    required DateTime? fecha,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            etiqueta,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        color: primaryColor, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        fecha != null ? _formatFecha(fecha) : 'Seleccionar',
                        style: TextStyle(
                          color: fecha != null
                              ? Colors.black87
                              : Colors.grey[400],
                          fontSize: 14,
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
    );
  }

  void _retroceder() {
    setState(() {
      if (_pasoActual > 1) _pasoActual--;
    });
  }

  // ── Encabezado unificado (título + indicador de pasos) ────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Column(
        children: [
          Text(
            'Creación de Plan de Campo',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Paso $_pasoActual de $_totalPasos',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 12),
          _buildIndicadorPasos(),
          const SizedBox(height: 8), // espacio antes del contenido
        ],
      ),
    );
  }

  // ── Indicador de pasos (círculos) ─────────────────────────────────────────

  Widget _buildIndicadorPasos() {
    const circleSize = 32.0;
    final children = <Widget>[];

    for (var i = 0; i < _totalPasos; i++) {
      final numero = i + 1;
      final completado = numero < _pasoActual;
      final activo = numero == _pasoActual;

      children.add(
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: completado || activo ? primaryColor : accentColor,
            border: Border.all(
              color: completado || activo ? primaryColor : accentColor,
              width: 2,
            ),
          ),
          child: Center(
            child: completado
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text(
                    '$numero',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
          ),
        ),
      );

      if (numero < _totalPasos) {
        children.add(
          Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              color: numero < _pasoActual ? primaryColor : accentColor,
            ),
          ),
        );
      }
    }

    return Row(children: children);
  }

  // ── Paso 1: Info básica (ahora sin título repetido) ───────────────────────

  Widget _buildPaso1() {
    final puedeDibujar = _poligonoPadreLatLng.length >= 3;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nombre del plan',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            textCapitalization: terrasachaCapitalizacionTexto,
            inputFormatters: terrasachaFormattersTexto(),
            controller: _nombrePlanCtrl,
            decoration: _inputDecoration('Ingresa el nombre del plan'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Vigencia del plan',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildSelectorFechaPlan(
                etiqueta: 'Fecha de inicio',
                fecha: _fechaInicioPlan,
                onTap: () => _elegirFechaPlan(esInicio: true),
              ),
              const SizedBox(width: 12),
              _buildSelectorFechaPlan(
                etiqueta: 'Fecha de fin',
                fecha: _fechaFinPlan,
                onTap: () => _elegirFechaPlan(esInicio: false),
              ),
            ],
          ),
          if (_fechaInicioPlan != null && _fechaFinPlan != null) ...[
            const SizedBox(height: 8),
            Text(
              'Duración: ${_fechaFinPlan!.difference(_fechaInicioPlan!).inDays + 1} día(s)',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
          const SizedBox(height: 20),
          const Text(
            'Ubicación (topología)',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _abrirSelectorUbicacion,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.account_tree_outlined, color: primaryColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _ubicacionRuta ?? 'Seleccionar ubicación en topología',
                        style: TextStyle(
                          color: _ubicacionRuta != null
                              ? Colors.black87
                              : Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.grey[400]),
                  ],
                ),
              ),
            ),
          ),
          if (_proyectoNombre != null) ...[
            const SizedBox(height: 8),
            Text(
              'Proyecto: $_proyectoNombre',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
          if (puedeDibujar) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              'Subáreas por día',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: terrasachaLightColor.withValues(alpha: 0.45),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Opcional',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _definirSubareas,
                        activeThumbColor: primaryColor,
                        onChanged: (v) {
                          setState(() {
                            _definirSubareas = v;
                            if (!v) {
                              _fechaSubareaEditando = null;
                              _puntosSubareaActual = [];
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  Text(
                    _definirSubareas
                        ? 'Elige un día y toca el mapa para dibujar el polígono dentro del área azul.'
                        : 'Puedes continuar sin delimitar subáreas. Activa el interruptor si quieres dibujar zonas por día.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  if (!_definirSubareas && _subAreasPorDia.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      '${_subAreasPorDia.length} subárea(s) guardada(s). Activa el interruptor para editarlas.',
                      style: TextStyle(
                        fontSize: 12,
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  if (_definirSubareas) ...[
                    const SizedBox(height: 14),
                    Text(
                      '1. Selecciona el día',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 42,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _diasDelPlan.length + 1,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          if (index == _diasDelPlan.length) {
                            return ActionChip(
                              avatar: Icon(Icons.calendar_month,
                                  size: 16, color: primaryColor),
                              label: const Text('Otra fecha'),
                              onPressed: () => _elegirFechaSubarea(),
                            );
                          }
                          final dia = _diasDelPlan[index];
                          final tiene = _diaTieneSubarea(dia);
                          final editando = _fechaSubareaEditando != null &&
                              _fechaSubareaEditando!.year == dia.year &&
                              _fechaSubareaEditando!.month == dia.month &&
                              _fechaSubareaEditando!.day == dia.day;

                          final bg = editando
                              ? primaryColor.withValues(alpha: 0.18)
                              : tiene
                                  ? terrasachaCardColor
                                  : Colors.white;
                          final border = editando || tiene
                              ? primaryColor
                              : Colors.grey.shade300;
                          final textColor = Colors.black87;

                          return Material(
                            color: bg,
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () => _abrirDiaSubarea(dia),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: border, width: 1.2),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _formatFecha(dia),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                    if (tiene) ...[
                                      const SizedBox(width: 6),
                                      Icon(
                                        Icons.check_circle,
                                        size: 16,
                                        color: primaryColor,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (_fechaSubareaEditando != null) ...[
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _editandoSubareaExistente
                                  ? '2. Edita la subárea · ${_formatFecha(_fechaSubareaEditando!)}'
                                  : '2. Dibuja la subárea · ${_formatFecha(_fechaSubareaEditando!)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: _cancelarEdicionSubarea,
                            child: const Text('Cancelar'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      MapaSubareaWidget(
                        key: ValueKey(
                          'mapa-subarea-${_fechaSubareaEditando!.millisecondsSinceEpoch}',
                        ),
                        poligonoPadre: _poligonoPadreLatLng,
                        puntosSubarea: _puntosSubareaActual,
                        primaryColor: primaryColor,
                        onPuntosChanged: (pts) =>
                            setState(() => _puntosSubareaActual = pts),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _cancelarEdicionSubarea,
                              child: const Text('Cancelar día'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _puntosSubareaActual.length >= 3
                                  ? _guardarSubareaDia
                                  : null,
                              icon: Icon(
                                _editandoSubareaExistente
                                    ? Icons.update
                                    : Icons.save_outlined,
                                size: 18,
                              ),
                              label: Text(
                                _puntosSubareaActual.length < 3
                                    ? 'Faltan ${_puntosSubareaActual.length}/3 puntos'
                                    : _editandoSubareaExistente
                                        ? 'Actualizar subárea'
                                        : 'Guardar subárea',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: terrasachaCardColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Toca un día para dibujar su subárea, o uno con ✓ para verla y editarla.',
                          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                        ),
                      ),
                    ],
                    if (_subAreasPorDia.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Subáreas guardadas (${_subAreasPorDia.length})',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._subAreasPorDia.asMap().entries.map((entry) {
                        final i = entry.key;
                        final sub = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Material(
                            color: terrasachaCardColor,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => _abrirDiaSubarea(sub.fecha),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: primaryColor.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.event,
                                        color: primaryColor, size: 20),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _formatFecha(sub.fecha),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            'Toca para ver / editar',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit_outlined,
                                          color: primaryColor),
                                      onPressed: () =>
                                          _abrirDiaSubarea(sub.fecha),
                                      tooltip: 'Editar subárea',
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.redAccent),
                                      onPressed: () => _eliminarSubarea(i),
                                      tooltip: 'Eliminar subárea',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ],
                ],
              ),
            ),
          ] else if (_topologiaId != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange.shade800),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Sin polígono padre en esta topología. Puedes continuar sin subáreas.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Paso 2: Equipo ────────────────────────────────────────────────────────

  Widget _buildPaso2() {
    final usuariosFiltrados = _usuariosDisponibles
        .where((u) =>
        u.nombre.toLowerCase().contains(_busquedaUsuario.toLowerCase()))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TextField(
            textCapitalization: terrasachaCapitalizacionTexto,
            inputFormatters: terrasachaFormattersTexto(),
            onChanged: (v) => setState(() => _busquedaUsuario = v),
            decoration: _inputDecoration('Buscar usuarios',
                prefixIcon: Icons.search),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Usuarios disponibles',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87)),
              Text(
                '(${_usuariosSeleccionados.length} Seleccionados)',
                style: TextStyle(color: primaryColor, fontSize: 13),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: usuariosFiltrados.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) {
              final usuario = usuariosFiltrados[i];
              final seleccionado = _usuariosSeleccionados
                  .any((u) => u.nombre == usuario.nombre);

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: primaryColor.withOpacity(0.15),
                          radius: 22,
                          child: Text(
                            usuario.nombre[0],
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            usuario.nombre,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            if (seleccionado) {
                              _usuariosSeleccionados.removeWhere(
                                      (u) => u.nombre == usuario.nombre);
                            } else {
                              _usuariosSeleccionados.add(usuario);
                            }
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: seleccionado
                                  ? primaryColor
                                  : Colors.transparent,
                              border: Border.all(
                                color: seleccionado
                                    ? primaryColor
                                    : Colors.grey[400]!,
                                width: 1.5,
                              ),
                            ),
                            child: seleccionado
                                ? const Icon(Icons.check,
                                color: Colors.white, size: 14)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildDropdownPequeno(usuario),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      RolesCampo.etiquetaParaDropdown(usuario.rol),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownPequeno(_UsuarioPlan usuario) {
    final rolDropdown = RolesCampo.etiquetaParaDropdown(usuario.rol);
    final clave = usuario.userId.isNotEmpty ? usuario.userId : usuario.nombre;
    final actualizando = _usuariosActualizandoRol.contains(clave);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: actualizando
          ? const SizedBox(
              width: 24,
              height: 24,
              child: Padding(
                padding: EdgeInsets.all(4),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: rolDropdown,
                isDense: true,
                icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                items: RolesCampo.rolesEquipoPlan
                    .map((r) => DropdownMenuItem(
                          value: r,
                          child: Text(r, style: const TextStyle(fontSize: 12)),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    _manejarCambioRolUsuario(usuario, v);
                  }
                },
              ),
            ),
    );
  }

  Future<void> _manejarCambioRolUsuario(
    _UsuarioPlan usuario,
    String nuevoRolUi,
  ) async {
    final rolNormalizado = RolesCampo.etiquetaParaDropdown(nuevoRolUi);
    final rolActual = RolesCampo.etiquetaParaDropdown(usuario.rol);
    if (rolNormalizado == rolActual) return;

    // Usuarios mock / sin id: solo afecta este plan.
    if (usuario.userId.isEmpty) {
      setState(() => usuario.rol = rolNormalizado);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Rol actualizado solo en este plan (usuario sin ID de Cognito).',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cambiar rol en Cognito'),
        content: Text(
          'Vas a cambiar el rol de ${usuario.nombre} de "$rolActual" a '
          '"$rolNormalizado".\n\n'
          'Esto actualiza su cuenta en Cognito (no solo este plan). '
          'El usuario deberá volver a iniciar sesión para ver permisos nuevos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    final clave = usuario.userId;
    setState(() => _usuariosActualizandoRol.add(clave));

    final resultado = await ServicioUsuariosCampo.actualizarRol(
      userId: usuario.userId,
      rolCognito: RolesCampo.cognitoDesdeEtiqueta(rolNormalizado),
    );

    if (!mounted) return;
    setState(() => _usuariosActualizandoRol.remove(clave));

    if (resultado['exito'] == true) {
      setState(() {
        usuario.rol = rolNormalizado;
        // Mantener sincronizado si hay otra copia en seleccionados.
        for (final u in _usuariosSeleccionados) {
          if (u.userId == usuario.userId) {
            u.rol = rolNormalizado;
          }
        }
        for (final u in _usuariosDisponibles) {
          if (u.userId == usuario.userId) {
            u.rol = rolNormalizado;
          }
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resultado['mensaje']?.toString() ??
                'Rol de ${usuario.nombre} actualizado en Cognito',
          ),
          backgroundColor: primaryColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resultado['error']?.toString() ??
                'No se pudo actualizar el rol en Cognito',
          ),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ── Paso 3: Lista de chequeo ──────────────────────────────────────────────

  Widget _buildPaso3() {
    if (_cargandoListasChequeo && _listasChequeoDisponibles.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lista de chequeo preoperacional',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Elige una de tus listas o crea una nueva con los ítems de verificación.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mis listas personalizadas',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextButton.icon(
                onPressed: _abrirCrearListaChequeo,
                icon: Icon(Icons.add, color: primaryColor, size: 20),
                label: Text(
                  'Crear nueva',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_listasPropias.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text(
                'Aún no tienes listas propias. Crea una con los ítems que tu cuadrilla debe verificar.',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            )
          else
            ..._listasPropias.map(
              (lista) => _buildTarjetaListaChequeo(lista, editable: true),
            ),
          const SizedBox(height: 24),
          const Text(
            'Listas del administrador',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          if (_listasAdmin.isEmpty)
            Text(
              'No hay listas del administrador disponibles.',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            )
          else
            ..._listasAdmin.map(
              (lista) => _buildTarjetaListaChequeo(lista, editable: false),
            ),
          if (_listaChequeoSeleccionada != null) ...[
            const SizedBox(height: 24),
            const Text(
              'Ítems seleccionados',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor.withOpacity(0.3)),
              ),
              child: Column(
                children: _listaChequeoSeleccionada!.items.asMap().entries.map(
                  (entry) {
                    final i = entry.key;
                    final item = entry.value;
                    final esUltimo =
                        i == _listaChequeoSeleccionada!.items.length - 1;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  _iconoItemChecklist(item.icono),
                                  color: primaryColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.titulo,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    if (item.descripcion.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        item.descripcion,
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!esUltimo)
                          Divider(height: 1, color: Colors.grey[100]),
                      ],
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTarjetaListaChequeo(ListaChequeo lista, {required bool editable}) {
    final seleccionada = _listaChequeoSeleccionada?.id == lista.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: seleccionada ? primaryColor : Colors.grey[200]!,
          width: seleccionada ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _seleccionarListaChequeo(lista),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                seleccionada
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: seleccionada ? primaryColor : Colors.grey[400],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lista.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    if (lista.descripcion != null &&
                        lista.descripcion!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        lista.descripcion!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            lista.origen.etiqueta,
                            style: TextStyle(fontSize: 11, color: primaryColor),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${lista.items.length} ítem(s)',
                          style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (editable)
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                  onSelected: (accion) {
                    if (accion == 'editar') {
                      _abrirEditarListaChequeo(lista);
                    } else if (accion == 'eliminar') {
                      _confirmarEliminarLista(lista);
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'editar', child: Text('Editar')),
                    PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Paso 4: Asignación de plantillas ──────────────────────────────────────

  Widget _buildPaso4() {
    final responsablesCount = _responsablesPlantilla.length;
    final operadoresCount = _operadoresSeleccionados.length;
    final jefesCount = responsablesCount - operadoresCount;
    final textoEquipo = jefesCount > 0 && operadoresCount > 0
        ? '$operadoresCount operador(es) y $jefesCount jefe(s) de cuadrilla'
        : jefesCount > 0
            ? '$jefesCount jefe(s) de cuadrilla en el equipo'
            : operadoresCount == 1
                ? '1 operador en el equipo'
                : '$operadoresCount operadores en el equipo';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Asignación de plantillas',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                'Asigna mediciones (features) de cada plantilla a ti mismo o a los operadores del equipo.',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.people_outline, color: primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        textoEquipo,
                        style: TextStyle(fontSize: 13, color: primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: SwitchListTile(
                  value: _requiereChequeoVehiculo,
                  activeThumbColor: primaryColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  onChanged: (v) =>
                      setState(() => _requiereChequeoVehiculo = v),
                  title: const Text(
                    '¿Requiere checklist de vehículo?',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    _requiereChequeoVehiculo
                        ? 'El jefe de cuadrilla deberá completar el chequeo de transporte.'
                        : 'No se pedirá ni se mostrará el chequeo de vehículo en esta salida.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_cargandoPlantillas)
          const Expanded(
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_errorPlantillas != null && _plantillasDisponibles.isEmpty)
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.description_outlined,
                        size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 12),
                    Text(
                      _errorPlantillas!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() => _plantillasDisponibles = []);
                        _cargarPlantillasSiNecesario();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          Expanded(
            child: _asignacionesPlantillas.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.assignment_outlined,
                              size: 56, color: Colors.grey[300]),
                          const SizedBox(height: 12),
                          Text(
                            'Sin asignaciones aún',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Ej: asignar PLANTILLA_MARCAR_ARBOL a un operador que cubre dos tareas.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                    itemCount: _asignacionesPlantillas.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (ctx, i) =>
                        _buildTarjetaAsignacion(i, _asignacionesPlantillas[i]),
                  ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _plantillasDisponibles.isEmpty && !_cargandoPlantillas
                  ? () {
                      setState(() => _plantillasDisponibles = []);
                      _cargarPlantillasSiNecesario().then((_) {
                        if (_plantillasDisponibles.isNotEmpty) {
                          _abrirNuevaAsignacion();
                        }
                      });
                    }
                  : _abrirNuevaAsignacion,
              icon: Icon(Icons.add, color: primaryColor),
              label: Text(
                'Nueva asignación',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTarjetaAsignacion(int index, AsignacionPlantillaPlan asignacion) {
    final tareasOperador = _asignacionesPlantillas
        .where((a) => a.operadorNombre == asignacion.operadorNombre)
        .length;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.description_outlined,
                    color: primaryColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asignacion.templateNombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.person_outline,
                            size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            asignacion.operadorNombre,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        if (tareasOperador > 1)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$tareasOperador tareas',
                              style: TextStyle(
                                fontSize: 11,
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (asignacion.fechaSubArea != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Día: ${_formatFecha(asignacion.fechaSubArea!)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                onSelected: (accion) {
                  if (accion == 'editar') {
                    _abrirNuevaAsignacion(indiceEdicion: index);
                  } else if (accion == 'eliminar') {
                    _eliminarAsignacion(index);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'editar',
                    child: Text('Editar / reasignar'),
                  ),
                  PopupMenuItem(
                    value: 'eliminar',
                    child: Text('Eliminar'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: asignacion.featureNombres.map((nombre) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Paso 5: Resumen final ─────────────────────────────────────────────────

  Widget _buildResumenFinal() {
    final equipoTexto = _usuariosSeleccionados.isEmpty
        ? 'Sin equipo asignado'
        : '${_usuariosSeleccionados.length} Usuario${_usuariosSeleccionados.length > 1 ? 's' : ''}';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Resumen del Plan',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                _buildFilaResumen(
                  icono: Icons.assignment_outlined,
                  label: 'Nombre del Plan:',
                  valor: _nombrePlanCtrl.text.isNotEmpty
                      ? _nombrePlanCtrl.text
                      : 'Sin nombre',
                ),
                if (_fechaInicioPlan != null && _fechaFinPlan != null) ...[
                  Divider(height: 1, color: Colors.grey[100]),
                  _buildFilaResumen(
                    icono: Icons.date_range_outlined,
                    label: 'Vigencia:',
                    valor:
                        '${_formatFecha(_fechaInicioPlan!)} — ${_formatFecha(_fechaFinPlan!)}',
                  ),
                ],
                Divider(height: 1, color: Colors.grey[100]),
                _buildFilaResumen(
                  icono: Icons.group_outlined,
                  label: 'Equipo:',
                  valor: equipoTexto,
                ),
                Divider(height: 1, color: Colors.grey[100]),
                _buildFilaResumen(
                  icono: Icons.checklist_outlined,
                  label: 'Lista de chequeo:',
                  valor: _listaChequeoSeleccionada != null
                      ? '${_listaChequeoSeleccionada!.nombre} (${_listaChequeoSeleccionada!.items.length} ítems)'
                      : 'Sin checklist',
                ),
                Divider(height: 1, color: Colors.grey[100]),
                _buildFilaResumen(
                  icono: Icons.location_on_outlined,
                  label: 'Ubicación (topología):',
                  valor: _ubicacionRuta ?? 'Sin ubicación',
                ),
                Divider(height: 1, color: Colors.grey[100]),
                _buildFilaResumen(
                  icono: Icons.map_outlined,
                  label: 'Subáreas por día:',
                  valor: _subAreasPorDia.isEmpty
                      ? 'Ninguna (opcional)'
                      : '${_subAreasPorDia.length} día(s)',
                ),
                if (_asignacionesPlantillas.isNotEmpty) ...[
                  Divider(height: 1, color: Colors.grey[100]),
                  _buildFilaResumen(
                    icono: Icons.assignment_outlined,
                    label: 'Asignaciones de plantillas:',
                    valor: '${_asignacionesPlantillas.length} tarea(s)',
                  ),
                ],
                Divider(height: 1, color: Colors.grey[100]),
                _buildFilaResumen(
                  icono: Icons.directions_car_outlined,
                  label: 'Checklist de vehículo:',
                  valor: _requiereChequeoVehiculo ? 'Sí' : 'No',
                ),
              ],
            ),
          ),
          if (_asignacionesPlantillas.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Detalle de asignaciones',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            ..._asignacionesPlantillas.map((a) {
              final fecha = a.fechaSubArea != null
                  ? ' · ${_formatFecha(a.fechaSubArea!)}'
                  : '';
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.templateNombre,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${a.operadorNombre}$fecha',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      a.featureNombres.join(', '),
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildFilaResumen({
    required IconData icono,
    required String label,
    required String valor,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: primaryColor, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        color: Colors.grey[500], fontSize: 12)),
                const SizedBox(height: 4),
                Text(valor,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers UI ────────────────────────────────────────────────────────────

  InputDecoration _inputDecoration(String hint, {IconData? prefixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: Colors.grey[400], size: 20)
          : null,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 1.5),
      ),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  // ── Build principal (con header y footer unificados) ──────────────────────

  @override
  Widget build(BuildContext context) {
    final esResumen = _pasoActual == 5;
    // Progreso lineal: paso 1 = 0.25, paso 2 = 0.5, paso 3 = 0.75, paso 4 = 1.0
    final double progressValue = esResumen ? 1.0 : (_pasoActual / _totalPasos);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primaryColor, size: 18),
          onPressed: () {
            if (_pasoActual > 1) {
              _retroceder();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          esResumen
              ? 'Resumen'
              : _salidaIdEnEdicion != null
                  ? 'Editar plan de campo'
                  : widget.salidaInicial?.salidaOrigenId != null
                      ? 'Revisar salida clonada'
                      : 'Crear Plan de Campo',
          style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          // Encabezado unificado (título, indicador de pasos, etc.)
          // Solo se muestra en los pasos 1-4, no en el resumen
          if (!esResumen) _buildHeader(),

          // Contenido del paso actual
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.15, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: KeyedSubtree(
                key: ValueKey(_pasoActual),
                child: _buildContenidoPaso(),
              ),
            ),
          ),

          // Pie unificado: barra de progreso + botón
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: Column(
              children: [
                // Barra de progreso lineal según el paso
                LinearProgressIndicator(
                  value: progressValue,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
                const SizedBox(height: 16),

                // Botón de acción
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    onPressed: esResumen ? _crearPlan : _continuar,
                    child: Text(
                      esResumen ? 'Crear plan' : 'Continuar',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),

                // Texto adicional solo en el resumen
                if (esResumen)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Terrasacha, 2024',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContenidoPaso() {
    switch (_pasoActual) {
      case 1:
        return _buildPaso1();
      case 2:
        return _buildPaso2();
      case 3:
        return _buildPaso3();
      case 4:
        return _buildPaso4();
      case 5:
        return _buildResumenFinal();
      default:
        return _buildPaso1();
    }
  }

  Future<void> _crearPlan() async {
    final lista = _listaChequeoSeleccionada;
    final checklistPlan = lista != null
        ? ChecklistPlanAsignado(
            listaId: lista.id,
            nombre: lista.nombre,
            origen: lista.origen.toJson(),
            items: List<ItemListaChequeo>.from(lista.items),
          )
        : null;

    final ahora = DateTime.now();
    final salida = SalidaCampo(
      id: _salidaIdEnEdicion ?? ServicioSalida.generarId(),
      nombre: _nombrePlanCtrl.text.trim(),
      estado: EstadoSalida.borrador,
      fechaInicio: _fechaInicioPlan,
      fechaFin: _fechaFinPlan,
      proyectoId: _proyectoId,
      proyectoNombre: _proyectoNombre,
      topologiaId: _topologiaId,
      ubicacionRuta: _ubicacionRuta,
      poligonoPadreGeoJson: _poligonoPadreGeoJson,
      subAreasPorDia: List<SubAreaPlanDia>.from(_subAreasPorDia),
      equipo: _usuariosSeleccionados
          .map(
            (u) => MiembroEquipoPlan(
              userId: u.userId.isNotEmpty ? u.userId : null,
              nombre: RolesCampo.normalizarNombre(u.nombre),
              rol: RolesCampo.etiquetaParaDropdown(u.rol),
            ),
          )
          .toList(),
      checklistNombre: lista?.nombre,
      checklist: checklistPlan,
      asignacionesPlantillas:
          List<AsignacionPlantillaPlan>.from(_asignacionesPlantillas),
      salidaOrigenId: widget.salidaInicial?.salidaOrigenId,
      motivoClonacion: widget.salidaInicial?.motivoClonacion,
      creadoEn: widget.salidaInicial?.creadoEn ?? ahora,
      actualizadoEn: ahora,
      requiereChequeoVehiculo: _requiereChequeoVehiculo,
    );

    try {
      await ServicioSalida.publicar(salida);
    } catch (e) {
      debugPrint('No se pudo publicar la salida: $e');
      if (!mounted) return;
      _mostrarError('No se pudo guardar la salida: $e');
      return;
    }

    if (!mounted) return;
    final esClon = widget.salidaInicial?.salidaOrigenId != null;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          esClon
              ? '¡Salida clonada y publicada correctamente!'
              : '¡Salida publicada correctamente!',
        ),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    Navigator.pop(context, true);
  }
}

// ── Modelo local ──────────────────────────────────────────────────────────────

_UsuarioPlan _usuarioPlanDesdeMiembro(MiembroEquipoPlan miembro) {
  final cognito = RolesCampo.esLiderCuadrilla(miembro.rol)
      ? 'lider_cuadrilla'
      : 'operador';
  return _UsuarioPlan(
    userId: miembro.userId ?? '',
    nombre: RolesCampo.normalizarNombre(miembro.nombre, rolCognito: cognito),
    rol: RolesCampo.etiquetaParaDropdown(miembro.rol),
  );
}

AsignacionPlantillaPlan _normalizarAsignacion(AsignacionPlantillaPlan a) {
  return a.copyWith(
    operadorNombre: RolesCampo.normalizarNombre(a.operadorNombre),
    operadorRol: RolesCampo.etiquetaParaDropdown(a.operadorRol),
  );
}

({String nombre, String rol, String? userId}) _responsableParaSheet(
  _UsuarioPlan o,
) {
  return (
    nombre: RolesCampo.normalizarNombre(o.nombre),
    rol: RolesCampo.etiquetaParaDropdown(o.rol),
    userId: o.userId.isNotEmpty ? o.userId : null,
  );
}

class _UsuarioPlan {
  final String userId;
  final String nombre;
  String rol;

  _UsuarioPlan({
    this.userId = '',
    required this.nombre,
    required this.rol,
  });
}