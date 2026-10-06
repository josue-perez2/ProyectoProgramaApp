import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../datos/api_cliente.dart';
import '../datos/sesion_actual.dart';
import '../rutas.dart';
import '../widgets/campo_formulario.dart';
import '../widgets/encabezado_logo.dart';
import '../widgets/fondo_decorativo.dart';

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final GlobalKey<FormState> _formularioKey = GlobalKey<FormState>();
  final TextEditingController _correoCtrl = TextEditingController();
  final TextEditingController _claveCtrl = TextEditingController();
  bool _enviando = false;

  @override
  void dispose() {
    _correoCtrl.dispose();
    _claveCtrl.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (!(_formularioKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    setState(() => _enviando = true);

    try {
      final String correo = _correoCtrl.text.trim();
      final Sesion sesion = await ApiCliente.iniciarSesion(
        correo: correo,
        password: _claveCtrl.text,
      );

      if (!mounted) return;
      SesionActual.iniciar(sesion, correo: correo);
      Navigator.of(context).pushReplacementNamed(Rutas.inicio, arguments: sesion);
    } on ApiException catch (e) {
      if (mounted) _mostrarAviso(e.mensaje);
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  Future<void> _irARegistro() async {
    final String? correo = await Navigator.of(context).pushNamed<String>(
      Rutas.registro,
    );

    if (correo == null || !mounted) return;

    _correoCtrl.text = correo;
    _claveCtrl.clear();
    _mostrarAviso('Cuenta registrada. Ya puedes iniciar sesion.');
  }

  void _mostrarAviso(String mensaje) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FondoDecorativo(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 52,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formularioKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const EncabezadoLogo(
                          titulo: 'Bienvenido'
                        ),
                        const SizedBox(height: 40),
                        FadeInUp(
                          duration: const Duration(milliseconds: 700),
                          delay: const Duration(milliseconds: 250),
                          child: _campoCorreo(),
                        ),
                        const SizedBox(height: 16),
                        FadeInUp(
                          duration: const Duration(milliseconds: 700),
                          delay: const Duration(milliseconds: 350),
                          child: _campoClave(),
                        ),
                        const SizedBox(height: 28),
                        ElasticInDown(
                          duration: const Duration(milliseconds: 900),
                          delay: const Duration(milliseconds: 450),
                          child: FilledButton(
                            onPressed: _enviando ? null : _iniciarSesion,
                            child: _enviando
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Iniciar sesión'),
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(height: 24),
                        FadeInUp(
                          duration: const Duration(milliseconds: 700),
                          delay: const Duration(milliseconds: 650),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                '¿Aún no tienes cuenta?',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 12),
                              FilledButton(
                                onPressed: _enviando ? null : _irARegistro,
                                child: const Text('Registrarse'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _campoCorreo() {
    return CampoFormulario(
      controller: _correoCtrl,
      etiqueta: 'Correo electrónico',
      icono: Icons.mail_outline_rounded,
      teclado: TextInputType.emailAddress,
      validator: (valor) {
        final String correo = (valor ?? '').trim();
        if (correo.isEmpty) return 'Ingresa tu correo';
        if (!correo.contains('@')) return 'Correo no válido';
        return null;
      },
    );
  }

  Widget _campoClave() {
    return CampoFormulario(
      controller: _claveCtrl,
      etiqueta: 'Contraseña',
      icono: Icons.lock_outline_rounded,
      textoSecreto: true,
      validator: (valor) {
        if (valor == null || valor.isEmpty) return 'Ingresa tu contraseña';
        return null;
      },
    );
  }
}
