import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/servicioAutenticacion.dart';
import '../utils/estado_verificacion.dart';
import '../theme.dart';
import '../widgets/terrasacha_logo.dart';

class VerificacionScreen extends StatefulWidget {
  const VerificacionScreen({super.key});

  @override
  State<VerificacionScreen> createState() => _VerificacionScreenState();
}

class _VerificacionScreenState extends State<VerificacionScreen> {
  final List<TextEditingController> _ctrls =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());
  final TextEditingController _emailCtrl = TextEditingController();

  bool _cargando = false;
  bool _reenviando = false;
  String? _error;
  String? _email;

  final Color primaryColor = terrasachaPrimaryColor;
  final Color backgroundColor = terrasachaBackgroundColor;
  bool _emailCargado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_emailCargado) return;
    _emailCargado = true;
    _cargarEmail();
  }

  Future<void> _cargarEmail() async {
    final args = ModalRoute.of(context)?.settings.arguments as String?;
    final pending = await pendingVerificationEmail();
    if (!mounted) return;
    setState(() => _email = args ?? pending);
  }

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    _emailCtrl.dispose();
    super.dispose();
  }

  String get _codigoCompleto => _ctrls.map((c) => c.text).join();

  Future<void> _verificar() async {
    if (_codigoCompleto.length < 6) {
      setState(() => _error = 'Ingresa los 6 dígitos del código');
      return;
    }
    final email = _email ?? (_emailCtrl.text.trim().isNotEmpty ? _emailCtrl.text.trim() : null);
    if (email == null) {
      setState(() => _error = 'Ingresa tu correo electrónico primero.');
      return;
    }
    if (_email == null) setState(() => _email = email);

    setState(() {
      _cargando = true;
      _error = null;
    });

    final resultado = await servicioAutenticacion.verificarCodigo(email, _codigoCompleto);

    if (!mounted) return;

    if (resultado['success'] == true) {
      clearPendingVerification();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('¡Cuenta verificada! Ya puedes iniciar sesión.'),
          backgroundColor: primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      setState(() {
        _error = resultado['error'] ?? 'Código incorrecto';
        _cargando = false;
      });
    }
  }

  Future<void> _reenviarCodigo() async {
    final email = _email ?? (_emailCtrl.text.trim().isNotEmpty ? _emailCtrl.text.trim() : null);
    if (email == null) {
      if (mounted) setState(() => _error = 'Ingresa tu correo electrónico primero.');
      return;
    }
    setState(() {
      _email ??= email;
      _reenviando = true;
    });

    final resultado = await servicioAutenticacion.reenviarCodigo(email);

    if (!mounted) return;
    setState(() => _reenviando = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          resultado['success'] == true
              ? 'Código reenviado a $_email'
              : resultado['error'] ?? 'Error al reenviar',
        ),
        backgroundColor:
        resultado['success'] == true ? primaryColor : Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _onDigitChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _nodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const TerrasachaLogo.appBar(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono ilustrativo
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(Icons.mark_email_read_outlined,
                      color: primaryColor, size: 40),
                ),
              ),

              const SizedBox(height: 28),

              const Center(
                child: Text(
                  'Verifica tu correo',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  _email != null
                      ? 'Enviamos un código de 6 dígitos a\n$_email'
                      : 'Enviamos un código de 6 dígitos a tu correo',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ),
              Center(
                child: Text(
                  '(Revisa también la carpeta de spam)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                      fontStyle: FontStyle.italic),
                ),
              ),

              // Campo manual de email (solo si no se recibió por args/pending)
              if (_email == null) ...[
                const SizedBox(height: 24),
                TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    hintText: 'Ingresa el correo que registraste',
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
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Ingresa tu correo y presiona "Reenviar código"',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Cajas de dígitos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) {
                  return SizedBox(
                    width: 48,
                    height: 56,
                    child: TextField(
                      controller: _ctrls[i],
                      focusNode: _nodes[i],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.white,
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
                          borderSide:
                          BorderSide(color: primaryColor, width: 2),
                        ),
                      ),
                      onChanged: (val) => _onDigitChanged(val, i),
                    ),
                  );
                }),
              ),

              // Error
              if (_error != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.redAccent, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _error!,
                          style: const TextStyle(
                              color: Colors.redAccent, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Botón verificar
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
                  onPressed: _cargando ? null : _verificar,
                  child: _cargando
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                      : const Text(
                    'Verificar cuenta',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Reenviar código
              Center(
                child: _reenviando
                    ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      color: primaryColor, strokeWidth: 2),
                )
                    : TextButton(
                  onPressed: _reenviarCodigo,
                  child: Text(
                    '¿No recibiste el código? Reenviar',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
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
}
