import 'package:flutter/material.dart';
import '../main.dart';
import '../theme.dart';
import '../utils/servicioAutenticacion.dart';
import '../widgets/terrasacha_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nuevaPassCtrl = TextEditingController();
  final _confirmarPassCtrl = TextEditingController();
  bool _cargando = false;
  bool _verPassword = false;
  bool _verNuevaPassword = false;
  bool _verConfirmarPassword = false;
  bool _requiereNuevaContrasena = false;
  String? _error;

  final Color primaryColor = terrasachaPrimaryColor;
  final Color backgroundColor = terrasachaBackgroundColor;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nuevaPassCtrl.dispose();
    _confirmarPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    final resultado = await servicioAutenticacion.login(
      _emailCtrl.text.trim(),
      _passCtrl.text.trim(),
    );

    if (!mounted) return;

    if (resultado['success'] == true) {
      _completarInicioSesion(resultado['rol'] as String?);
      return;
    }

    if (resultado['requiresNewPassword'] == true) {
      setState(() {
        _requiereNuevaContrasena = true;
        _cargando = false;
        _error = null;
      });
      return;
    }

    setState(() {
      _error = resultado['error'] ?? 'Error al iniciar sesión';
      _cargando = false;
    });
  }

  Future<void> _confirmarNuevaContrasena() async {
    final nueva = _nuevaPassCtrl.text.trim();
    final confirmar = _confirmarPassCtrl.text.trim();

    if (nueva.length < 8) {
      setState(() => _error = 'La contraseña debe tener al menos 8 caracteres');
      return;
    }

    if (nueva != confirmar) {
      setState(() => _error = 'Las contraseñas no coinciden');
      return;
    }

    if (nueva == _passCtrl.text.trim()) {
      setState(
        () => _error = 'La nueva contraseña debe ser diferente a la temporal',
      );
      return;
    }

    setState(() {
      _cargando = true;
      _error = null;
    });

    final resultado =
        await servicioAutenticacion.confirmarNuevaContrasena(nueva);

    if (!mounted) return;

    if (resultado['success'] == true) {
      _completarInicioSesion(resultado['rol'] as String?);
      return;
    }

    setState(() {
      _error = resultado['error'] ?? 'No se pudo cambiar la contraseña';
      _cargando = false;
    });
  }

  void _completarInicioSesion(String? rol) {
    setCurrentRole(rol);
    _navegarSegunRol(rol);
  }

  void _volverAlLogin() {
    setState(() {
      _requiereNuevaContrasena = false;
      _nuevaPassCtrl.clear();
      _confirmarPassCtrl.clear();
      _error = null;
    });
  }

  void _navegarSegunRol(String? rol) {
    switch (rol) {
      case 'lider_proyecto':
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 'lider_cuadrilla':
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 'operador':
        Navigator.pushReplacementNamed(context, '/home');
        break;
      default:
        setState(() {
          _error = 'Rol no reconocido. Contacta al administrador.';
          _cargando = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              const TerrasachaLogo.hero(),

              const SizedBox(height: 40),

              if (_requiereNuevaContrasena) ...[
                const Text(
                  'Establece tu nueva contraseña',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Tu contraseña temporal fue aceptada. Crea una nueva para continuar.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 36),
                _buildCampoContrasena(
                  label: 'Nueva contraseña',
                  controller: _nuevaPassCtrl,
                  visible: _verNuevaPassword,
                  onToggle: () =>
                      setState(() => _verNuevaPassword = !_verNuevaPassword),
                ),
                const SizedBox(height: 20),
                _buildCampoContrasena(
                  label: 'Confirmar contraseña',
                  controller: _confirmarPassCtrl,
                  visible: _verConfirmarPassword,
                  onToggle: () => setState(
                    () => _verConfirmarPassword = !_verConfirmarPassword,
                  ),
                ),
              ] else ...[
                const Text(
                  'Bienvenido',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Inicia sesión para continuar',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 36),

                // Campo email
                Text(
                  'Correo electrónico',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: terrasachaInputTextStyle,
                  decoration: InputDecoration(
                    hintText: 'ejemplo@correo.com',
                    hintStyle: terrasachaInputTextStyle.copyWith(
                      color: Colors.grey[400],
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.email_outlined, color: primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildCampoContrasena(
                  label: 'Contraseña',
                  controller: _passCtrl,
                  visible: _verPassword,
                  onToggle: () => setState(() => _verPassword = !_verPassword),
                ),
              ],

              // Error
              if (_error != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Botón principal
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _cargando
                      ? null
                      : (_requiereNuevaContrasena
                          ? _confirmarNuevaContrasena
                          : _login),
                  child: _cargando
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                      : Text(
                    _requiereNuevaContrasena
                        ? 'Guardar y continuar'
                        : 'Iniciar sesión',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              if (_requiereNuevaContrasena) ...[
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: _cargando ? null : _volverAlLogin,
                    child: Text(
                      'Volver al inicio de sesión',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 20),

                // Ir a registro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿No tienes cuenta?',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/register'),
                      child: Text(
                        'Regístrate',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCampoContrasena({
    required String label,
    required TextEditingController controller,
    required bool visible,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: !visible,
          style: terrasachaInputTextStyle,
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: terrasachaInputTextStyle.copyWith(
              color: Colors.grey[400],
            ),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(Icons.lock_outline, color: primaryColor),
            suffixIcon: IconButton(
              icon: Icon(
                visible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey[500],
              ),
              onPressed: onToggle,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
          ),
        ),
      ],
    );

  }
}
