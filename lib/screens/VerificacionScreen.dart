import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/servicioAutenticacion.dart';

class VerificacionScreen extends StatefulWidget {
  const VerificacionScreen({super.key});

  @override
  State<VerificacionScreen> createState() => _VerificacionScreenState();
}

class _VerificacionScreenState extends State<VerificacionScreen> {
  final List<TextEditingController> _ctrls =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());

  bool _cargando = false;
  bool _reenviando = false;
  String? _error;
  String? _email;

  final Color primaryColor = const Color(0xFF4A5C24);
  final Color backgroundColor = const Color(0xFFF7F8F6);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _email = ModalRoute.of(context)?.settings.arguments as String?;
  }

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  String get _codigoCompleto => _ctrls.map((c) => c.text).join();

  Future<void> _verificar() async {
    if (_codigoCompleto.length < 6) {
      setState(() => _error = 'Ingresa los 6 dígitos del código');
      return;
    }
    if (_email == null) {
      setState(() => _error = 'No se encontró el correo. Vuelve a registrarte.');
      return;
    }

    setState(() {
      _cargando = true;
      _error = null;
    });

    final resultado = await servicioAutenticacion.verificarCodigo(_email!, _codigoCompleto);

    if (!mounted) return;

    if (resultado['success'] == true) {
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
    if (_email == null) return;
    setState(() => _reenviando = true);

    final resultado = await servicioAutenticacion.reenviarCodigo(_email!);

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
        title: Row(
          children: const [
            Icon(Icons.park, color: Colors.white, size: 28),
            SizedBox(width: 8),
            Text(
              'Terrasacha',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
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
                    color: primaryColor.withOpacity(0.1),
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

              const SizedBox(height: 40),

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