import 'package:flutter/material.dart';

import '../models/plan_campo_borrador.dart';
import '../utils/servicio_accidentes.dart';
import '../utils/servicioAutenticacion.dart';
import '../utils/servicio_salida.dart';
import 'RegistroIncidenciaScreen.dart';
import '../theme.dart';

/// Lista las salidas del usuario para acceder a incidencias por salida.
class IncidenciasSalidasScreen extends StatefulWidget {
  const IncidenciasSalidasScreen({super.key});

  @override
  State<IncidenciasSalidasScreen> createState() => _IncidenciasSalidasScreenState();
}

class _IncidenciasSalidasScreenState extends State<IncidenciasSalidasScreen> {
  final Color primaryColor = terrasachaPrimaryColor;
  final Color backgroundColor = terrasachaBackgroundColor;
  final ServicioAccidentes _servicioAccidentes = ServicioAccidentes();

  bool _cargando = true;
  final Map<String, int> _conteoIncidencias = {};

  List<SalidaCampo> _salidas = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);

    final usuario = await servicioAutenticacion.getUsuarioActual();
    if (usuario == null) {
      if (mounted) setState(() => _cargando = false);
      return;
    }

    final salidas = await ServicioSalida.listarSalidasParaUsuario(usuario);
    final conteos = <String, int>{};
    for (final salida in salidas) {
      final reportes = await _servicioAccidentes.listarPorSalida(salida.id);
      conteos[salida.id] = reportes.length;
    }

    if (!mounted) return;
    setState(() {
      _salidas = salidas;
      _conteoIncidencias
        ..clear()
        ..addAll(conteos);
      _cargando = false;
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
          'Incidencias por salida',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: _cargando
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : _salidas.isEmpty
              ? Center(
                  child: Text(
                    'No tienes salidas activas para reportar incidencias.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600], fontSize: 15),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _cargar,
                  color: primaryColor,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _salidas.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final salida = _salidas[index];
                      final conteo = _conteoIncidencias[salida.id] ?? 0;
                      return ListTile(
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: primaryColor.withValues(alpha: 0.1),
                          child: Icon(Icons.warning_amber_outlined, color: primaryColor),
                        ),
                        title: Text(
                          salida.nombre,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          conteo == 0
                              ? 'Sin incidencias registradas'
                              : '$conteo incidencia${conteo == 1 ? '' : 's'}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RegistroIncidenciaScreen(
                                salidaId: salida.id,
                                salidaNombre: salida.nombre,
                              ),
                            ),
                          ).then((_) => _cargar());
                        },
                      );
                    },
                  ),
                ),
    );

  }
}
