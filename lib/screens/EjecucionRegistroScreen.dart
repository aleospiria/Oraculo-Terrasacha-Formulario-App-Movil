// lib/screens/EjecucionRegistroScreen.dart
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/coordenada_actual.dart';
import '../utils/roles_campo.dart';
import '../utils/servicio_salida.dart';
import '../utils/servicio_ubicacion_actual.dart';
import '../widgets/coordenada_actual_panel.dart';
import '../utils/servicio_audios.dart';
import 'package:capturador_datos_offline/screens/FinalizarTareaScreen.dart';

class EjecucionRegistroScreen extends StatefulWidget {
  final String? salidaId;
  final String? asignacionId;
  final String tituloTarea;
  final String? ubicacionRuta;
  final List<String> featureNombres;

  const EjecucionRegistroScreen({
    super.key,
    this.salidaId,
    this.asignacionId,
    this.tituloTarea = 'Ejecución de registro',
    this.ubicacionRuta,
    this.featureNombres = const [],
  });

  @override
  State<EjecucionRegistroScreen> createState() =>
      _EjecucionRegistroScreenState();
}

class _EjecucionRegistroScreenState extends State<EjecucionRegistroScreen> {
  static const Color primaryColor = Color(0xFF4A5C24);
  static const Color backgroundColor = Color(0xFFF7F8F6);

  String? _rutaAudio;
  final TextEditingController _observacionesCtrl = TextEditingController();
  bool _tareaFinalizada = false;
  bool _guardando = false;
  CoordenadaActual? _coordenadaActual;

  bool get _registraMedicionEnCampo =>
      hasRole('operador') ||
      hasRole('lider_cuadrilla') ||
      RolesCampo.capturaCoordenadasEnRegistro(currentUserRole);

  bool get _requiereCoordenadas =>
      _registraMedicionEnCampo ||
      plantillaRequiereCoordenadasGps(widget.featureNombres);

  bool get _mostrarCoordenadas => _requiereCoordenadas;

  bool get _tieneContextoSalida =>
      widget.salidaId != null && widget.asignacionId != null;

  @override
  void initState() {
    super.initState();
    _marcarEnCursoSiAplica();
    if (_mostrarCoordenadas) {
      ServicioUbicacionActual.solicitarPermiso();
    }
  }

  Future<void> _marcarEnCursoSiAplica() async {
    if (!_tieneContextoSalida) return;
    await ServicioSalida.marcarAsignacionEnCurso(
      salidaId: widget.salidaId!,
      asignacionId: widget.asignacionId!,
    );
  }

  @override
  void dispose() {
    _observacionesCtrl.dispose();
    super.dispose();
  }

  Future<void> _finalizarTarea(BuildContext context) async {
    if (_rutaAudio == null && _observacionesCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agrega al menos un audio o una observación'),
        ),
      );
      return;
    }

    var coordenada = await ServicioUbicacionActual.obtenerUnaVez();
    coordenada ??= _coordenadaActual;

    if (_requiereCoordenadas && coordenada == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Se requiere señal GPS para finalizar. Activa la ubicación e intenta de nuevo.',
          ),
        ),
      );
      return;
    }

    setState(() => _guardando = true);

    if (_tieneContextoSalida) {
      await ServicioSalida.guardarRegistroAsignacion(
        salidaId: widget.salidaId!,
        asignacionId: widget.asignacionId!,
        coordenada: coordenada,
        observaciones: _observacionesCtrl.text.trim().isEmpty
            ? null
            : _observacionesCtrl.text.trim(),
        rutaAudio: _rutaAudio,
      );
    }

    if (!context.mounted) return;
    setState(() {
      _guardando = false;
      _tareaFinalizada = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registro guardado exitosamente'),
        backgroundColor: primaryColor,
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FinalizarTareaScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ejecución de Registro',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              radius: 18,
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoTarea(),
            const SizedBox(height: 20),
            if (widget.ubicacionRuta != null) ...[
              _buildZonaAsignada(),
              const SizedBox(height: 20),
            ],
            if (_mostrarCoordenadas) ...[
              CoordenadaActualPanel(
                soloLectura: true,
                titulo: 'Coordenadas del registro',
                primaryColor: primaryColor,
                onCoordenadaChanged: (coord) {
                  setState(() => _coordenadaActual = coord);
                },
              ),
              const SizedBox(height: 24),
            ],
            grabadorAudio(
              onGrabacionCompleta: (path) {
                setState(() => _rutaAudio = path);
              },
            ),
            const SizedBox(height: 24),
            _buildObservaciones(),
            const SizedBox(height: 32),
            SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _tareaFinalizada || _guardando ? Colors.grey : primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                ),
                onPressed: _tareaFinalizada || _guardando
                    ? null
                    : () => _finalizarTarea(context),
                icon: _guardando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(_tareaFinalizada ? Icons.check : Icons.save),
                label: Text(
                  _guardando
                      ? 'Guardando…'
                      : _tareaFinalizada
                          ? 'Registro Guardado'
                          : 'Finalizar y Guardar',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTarea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.assignment, color: primaryColor, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.tituloTarea,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (_requiereCoordenadas) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Las coordenadas GPS se capturan del celular al finalizar. No se pueden editar manualmente.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'En ejecución',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZonaAsignada() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.map_outlined, color: primaryColor, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Zona asignada (solo lectura)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.ubicacionRuta!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObservaciones() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.edit_note, color: primaryColor, size: 22),
              SizedBox(width: 8),
              Text(
                'Observaciones',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _observacionesCtrl,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Escribe tus observaciones aquí...',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: primaryColor, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
