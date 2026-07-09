// lib/Screens/GestionUsuariosScreen.dart
import 'package:flutter/material.dart';

import '../utils/servicio_usuarios_campo.dart';

// ── Modelos locales ───────────────────────────────────────────────────────────

enum RolUsuario { liderProyecto, jefeCampo, operador }

enum EstadoUsuario { activo, inactivo }

class Usuario {
  final String id;
  final String nombre;
  final String? email;
  final RolUsuario rol;
  EstadoUsuario estado;
  final int proyectosActivos;
  final int tareasRecientes;
  final String ultimaConexion;
  final List<String> medicionesAsignadas;
  bool expandido;

  Usuario({
    required this.id,
    required this.nombre,
    this.email,
    required this.rol,
    this.estado = EstadoUsuario.activo,
    this.proyectosActivos = 0,
    this.tareasRecientes = 0,
    this.ultimaConexion = 'Sin conexión',
    this.medicionesAsignadas = const [],
    this.expandido = false,
  });
}

// ── Screen ────────────────────────────────────────────────────────────────────

class GestionUsuariosScreen extends StatefulWidget {
  const GestionUsuariosScreen({super.key});

  @override
  State<GestionUsuariosScreen> createState() => _GestionUsuariosScreenState();
}

class _GestionUsuariosScreenState extends State<GestionUsuariosScreen> {
  final Color primaryColor = const Color(0xFF4A5C24);
  final Color backgroundColor = const Color(0xFFF7F8F6);
  final Color cardColor = const Color(0xFFEEF2E6);

  final List<String> _todasLasMediciones = [
    'Humedad del suelo',
    'Nivel de agua',
    'Temperatura',
    'pH',
    'Conductividad',
    'Luminosidad',
    'CO₂',
  ];

  final List<Usuario> _usuarios = [];
  bool _cargando = true;
  String? _errorCarga;

  static const List<RolUsuario> _rolesCreacion = [
    RolUsuario.jefeCampo,
    RolUsuario.operador,
  ];

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  Future<void> _cargarUsuarios() async {
    setState(() {
      _cargando = true;
      _errorCarga = null;
    });

    final resultado = await ServicioUsuariosCampo.listarUsuarios();

    if (!mounted) return;

    if (resultado['exito'] != true) {
      setState(() {
        _cargando = false;
        _errorCarga = resultado['error'] as String? ?? 'Error al cargar usuarios';
      });
      return;
    }

    final lista = (resultado['usuarios'] as List<dynamic>? ?? [])
        .map((item) => _usuarioDesdeApi(item as Map<String, dynamic>))
        .whereType<Usuario>()
        .toList();

    setState(() {
      _usuarios
        ..clear()
        ..addAll(lista);
      _cargando = false;
    });
  }

  Usuario? _usuarioDesdeApi(Map<String, dynamic> item) {
    final rol = _rolDesdeCognito(item['rol'] as String?);
    if (rol == null) return null;

    return Usuario(
      id: item['id'] as String? ?? '',
      nombre: item['nombre'] as String? ?? 'Sin nombre',
      email: item['email'] as String?,
      rol: rol,
      estado: (item['activo'] as bool? ?? true)
          ? EstadoUsuario.activo
          : EstadoUsuario.inactivo,
      medicionesAsignadas: (item['mediciones'] as List<dynamic>? ?? [])
          .map((m) => m.toString())
          .toList(),
    );
  }

  RolUsuario? _rolDesdeCognito(String? rol) {
    switch (rol) {
      case 'lider_cuadrilla':
        return RolUsuario.jefeCampo;
      case 'operador':
        return RolUsuario.operador;
      case 'lider_proyecto':
        return RolUsuario.liderProyecto;
      default:
        return null;
    }
  }

  String _rolACognito(RolUsuario rol) {
    switch (rol) {
      case RolUsuario.jefeCampo:
        return 'lider_cuadrilla';
      case RolUsuario.operador:
        return 'operador';
      case RolUsuario.liderProyecto:
        return 'lider_proyecto';
    }
  }

  void _mostrarSnackBar(String mensaje, {bool esError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: esError ? Colors.red[700] : primaryColor,
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _labelRol(RolUsuario rol) {
    switch (rol) {
      case RolUsuario.liderProyecto:
        return 'Líder de Proyecto';
      case RolUsuario.jefeCampo:
        return 'Jefe de Campo';
      case RolUsuario.operador:
        return 'Operador';
    }
  }

  String _iniciales(String nombre) {
    final partes = nombre.trim().split(' ');
    if (partes.length >= 2) {
      return '${partes[0][0]}${partes[1][0]}'.toUpperCase();
    }
    return nombre[0].toUpperCase();
  }

  Color _colorEstado(EstadoUsuario estado) =>
      estado == EstadoUsuario.activo
          ? const Color(0xFF4A5C24)
          : Colors.grey[500]!;

  String _labelEstado(EstadoUsuario estado) =>
      estado == EstadoUsuario.activo ? 'Activo' : 'Inactivo';

  // ── Modal crear/editar usuario ─────────────────────────────────────────────

  Future<void> _mostrarModalUsuario({Usuario? usuarioEditar}) async {
    final nombreCtrl =
        TextEditingController(text: usuarioEditar?.nombre ?? '');
    final correoCtrl =
        TextEditingController(text: usuarioEditar?.email ?? '');
    RolUsuario rolSeleccionado =
        usuarioEditar?.rol ?? RolUsuario.operador;
    final List<String> medicionesSeleccionadas =
        List.from(usuarioEditar?.medicionesAsignadas ?? []);
    var guardando = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Container(
          height: MediaQuery.of(ctx).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle + cabecera
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        usuarioEditar != null
                            ? 'Editar usuario'
                            : 'Crear usuario',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black54),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 20,
                    bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Información básica ─────────────────────────────
                      Text(
                        'Información básica',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildCampoTexto(
                        ctrl: nombreCtrl,
                        hint: 'Nombre',
                      ),
                      const SizedBox(height: 10),
                      _buildCampoTexto(
                        ctrl: correoCtrl,
                        hint: 'Correo',
                        tipo: TextInputType.emailAddress,
                        habilitado: usuarioEditar == null,
                      ),
                      const SizedBox(height: 16),

                      // Rol
                      Text(
                        'Rol',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5EE),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<RolUsuario>(
                            isExpanded: true,
                            value: rolSeleccionado,
                            icon: Icon(Icons.keyboard_arrow_down,
                                color: Colors.grey[400]),
                            items: (usuarioEditar != null
                                    ? RolUsuario.values
                                    : _rolesCreacion)
                                .map((r) => DropdownMenuItem(
                                      value: r,
                                      child: Text(_labelRol(r)),
                                    ))
                                .toList(),
                            onChanged: usuarioEditar != null
                                ? null
                                : (v) {
                                    if (v != null) {
                                      setModal(() => rolSeleccionado = v);
                                    }
                                  },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Asignar mediciones ─────────────────────────────
                      Text(
                        'Asignar mediciones',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _todasLasMediciones.map((m) {
                          final seleccionado =
                          medicionesSeleccionadas.contains(m);
                          return GestureDetector(
                            onTap: () => setModal(() {
                              if (seleccionado) {
                                medicionesSeleccionadas.remove(m);
                              } else {
                                medicionesSeleccionadas.add(m);
                              }
                            }),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: seleccionado
                                    ? primaryColor
                                    : const Color(0xFFF5F5EE),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                m,
                                style: TextStyle(
                                  color: seleccionado
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: seleccionado
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // Botón guardar
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    onPressed: guardando
                        ? null
                        : () async {
                            final nombre = nombreCtrl.text.trim();
                            final correo = correoCtrl.text.trim();

                            if (nombre.isEmpty) {
                              _mostrarSnackBar('Ingresa el nombre', esError: true);
                              return;
                            }

                            if (usuarioEditar != null) {
                              Navigator.pop(ctx);
                              _mostrarSnackBar(
                                'La edición de usuarios estará disponible próximamente',
                              );
                              return;
                            }

                            if (correo.isEmpty || !correo.contains('@')) {
                              _mostrarSnackBar(
                                'Ingresa un correo válido',
                                esError: true,
                              );
                              return;
                            }

                            setModal(() => guardando = true);

                            final resultado =
                                await ServicioUsuariosCampo.crearUsuario(
                              nombre: nombre,
                              email: correo,
                              rolCognito: _rolACognito(rolSeleccionado),
                              mediciones: medicionesSeleccionadas,
                            );

                            if (!ctx.mounted) return;

                            if (resultado['exito'] != true) {
                              setModal(() => guardando = false);
                              _mostrarSnackBar(
                                resultado['error'] as String? ??
                                    'No se pudo crear el usuario',
                                esError: true,
                              );
                              return;
                            }

                            Navigator.pop(ctx);
                            _mostrarSnackBar(
                              resultado['mensaje'] as String? ??
                                  'Usuario creado correctamente',
                            );
                            await _cargarUsuarios();
                          },
                    child: guardando
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            usuarioEditar != null
                                ? 'Guardar cambios'
                                : 'Crear usuario',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCampoTexto({
    required TextEditingController ctrl,
    required String hint,
    TextInputType tipo = TextInputType.text,
    bool habilitado = true,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: tipo,
      enabled: habilitado,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF5F5EE),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, color: primaryColor, size: 16),
              ],
            ),
          ),
        ),
        title: const Text(
          'Gestionar usuarios',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: primaryColor.withOpacity(0.1),
              radius: 18,
              child:
              Icon(Icons.person_outline, color: primaryColor, size: 20),
            ),
          ),
        ],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _errorCarga != null
              ? _buildEstadoError()
              : _usuarios.isEmpty
                  ? _buildEstadoVacio()
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _usuarios.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (ctx, i) => _buildUsuarioCard(_usuarios[i]),
                    ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => _mostrarModalUsuario(),
        child: const Icon(Icons.person_add_outlined,
            color: Colors.white, size: 26),
      ),
    );
  }

  Widget _buildUsuarioCard(Usuario usuario) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Cabecera del usuario
          GestureDetector(
            onTap: () =>
                setState(() => usuario.expandido = !usuario.expandido),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // Avatar con iniciales
                  CircleAvatar(
                    backgroundColor: primaryColor.withOpacity(0.15),
                    radius: 22,
                    child: Text(
                      _iniciales(usuario.nombre),
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          usuario.nombre,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _labelRol(usuario.rol),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                        if (usuario.email != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            usuario.email!,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Badge estado
                  GestureDetector(
                    onTap: () => setState(() {
                      usuario.estado =
                      usuario.estado == EstadoUsuario.activo
                          ? EstadoUsuario.inactivo
                          : EstadoUsuario.activo;
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color:
                        _colorEstado(usuario.estado).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _labelEstado(usuario.estado),
                        style: TextStyle(
                          color: _colorEstado(usuario.estado),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    usuario.expandido
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),

          // Detalle expandido
          if (usuario.expandido) ...[
            Divider(height: 1, color: Colors.grey[100]),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resumen actividad
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resumen de actividad',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildFilaResumen(
                          label: 'Proyectos:',
                          valor:
                          '${usuario.proyectosActivos} Activos',
                        ),
                        const SizedBox(height: 6),
                        _buildFilaResumen(
                          label: 'Tareas recientes:',
                          valor: '${usuario.tareasRecientes}',
                        ),
                        const SizedBox(height: 6),
                        _buildFilaResumen(
                          label: 'Última conexión:',
                          valor: usuario.ultimaConexion,
                        ),
                      ],
                    ),
                  ),

                  // Mediciones asignadas
                  if (usuario.medicionesAsignadas.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Mediciones asignadas',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: usuario.medicionesAsignadas
                          .map((m) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          m,
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ))
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: 14),

                  // Botón editar
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding:
                        const EdgeInsets.symmetric(vertical: 11),
                        side: BorderSide(color: primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: Icon(Icons.edit_outlined,
                          color: primaryColor, size: 16),
                      label: Text(
                        'Editar usuario',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () =>
                          _mostrarModalUsuario(usuarioEditar: usuario),
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

  Widget _buildEstadoError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red[400], size: 48),
            const SizedBox(height: 16),
            Text(
              _errorCarga!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _cargarUsuarios,
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadoVacio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, color: primaryColor.withOpacity(0.5), size: 56),
            const SizedBox(height: 16),
            const Text(
              'No hay usuarios de campo registrados',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Usa el botón + para crear un líder de cuadrilla u operador',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilaResumen(
      {required String label, required String valor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        Text(
          valor,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}