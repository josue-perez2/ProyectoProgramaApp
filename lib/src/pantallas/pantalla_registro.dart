import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../datos/api_cliente.dart';
import '../widgets/campo_formulario.dart';
import '../widgets/encabezado_logo.dart';
import '../widgets/fondo_decorativo.dart';
import '../widgets/formateador_dpi.dart';

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final GlobalKey<FormState> _formularioKey = GlobalKey<FormState>();
  final TextEditingController _dpiCtrl = TextEditingController();
  final TextEditingController _correoCtrl = TextEditingController();
  final TextEditingController _claveCtrl = TextEditingController();
  final TextEditingController _confirmarCtrl = TextEditingController();
  bool _enviando = false;

  @override
  void dispose() {
    _dpiCtrl.dispose();
    _correoCtrl.dispose();
    _claveCtrl.dispose();
    _confirmarCtrl.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (!(_formularioKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    setState(() => _enviando = true);

    try {
      final ResultadoRegistro resultado = await ApiCliente.registrar(
        dpi: FormateadorDpi.soloDigitos(_dpiCtrl.text),
        correo: _correoCtrl.text.trim(),
        password: _claveCtrl.text,
      );

      if (!mounted) return;
      Navigator.of(context)
          .pop<String>(resultado.correoCli ?? _correoCtrl.text.trim());
    } on ApiException catch (e) {
      if (mounted) _mostrarAviso(e.mensaje);
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
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
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formularioKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 15),
                        const EncabezadoLogo(titulo: 'Crea tu cuenta'),
                        const SizedBox(height: 36),
                        FadeInUp(
                          duration: const Duration(milliseconds: 700),
                          delay: const Duration(milliseconds: 200),
                          child: _campoDpi(),
                        ),
                        const SizedBox(height: 16),
                        FadeInUp(
                          duration: const Duration(milliseconds: 700),
                          delay: const Duration(milliseconds: 300),
                          child: _campoCorreo(),
                        ),
                        const SizedBox(height: 16),
                        FadeInUp(
                          duration: const Duration(milliseconds: 700),
                          delay: const Duration(milliseconds: 400),
                          child: _campoClave(),
                        ),
                        const SizedBox(height: 16),
                        FadeInUp(
                          duration: const Duration(milliseconds: 700),
                          delay: const Duration(milliseconds: 500),
                          child: _campoConfirmar(),
                        ),
                        const SizedBox(height: 28),
                        ElasticInDown(
                          duration: const Duration(milliseconds: 900),
                          delay: const Duration(milliseconds: 600),
                          child: FilledButton(
                            onPressed: _enviando ? null : _registrar,
                            child: _enviando
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Registrarme'),
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(height: 24),
                        FadeInUp(
                          duration: const Duration(milliseconds: 700),
                          delay: const Duration(milliseconds: 700),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Â¿Ya tienes una cuenta?',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                                
                              ),
                              const SizedBox(height: 12),
                              FilledButton(
                                onPressed: _enviando
                                    ? null
                                    : () => Navigator.of(context).pop(),
                                child: const Text('Iniciar sesiÃ³n'),
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

  Widget _campoDpi() {
    return CampoFormulario(
      controller: _dpiCtrl,
      etiqueta: 'DPI',
      icono: Icons.badge_outlined,
      teclado: TextInputType.number,
      maxLength: FormateadorDpi.caracteresTotales,
      
      formatters: const <TextInputFormatter>[FormateadorDpi()],
      validator: (valor) {
        final String dpi = FormateadorDpi.soloDigitos((valor ?? '').trim());
        if (dpi.isEmpty) return 'Ingresa tu DPI';
        if (dpi.length != FormateadorDpi.digitosTotales) {
          return 'El DPI debe tener 13 digitos';
        }
        return null;
      },
    );
  }

  Widget _campoCorreo() {
    return CampoFormulario(
      controller: _correoCtrl,
      etiqueta: 'Correo electrÃ³nico',
      icono: Icons.mail_outline_rounded,
      teclado: TextInputType.emailAddress,
      validator: (valor) {
        final String correo = (valor ?? '').trim();
        if (correo.isEmpty) return 'Ingresa tu correo';
        if (!correo.contains('@') || !correo.contains('.')) {
          return 'Correo no vÃ¡lido';
        }
        return null;
      },
    );
  }

  Widget _campoClave() {
    return CampoFormulario(
      controller: _claveCtrl,
      etiqueta: 'ContraseÃ±a',
      icono: Icons.lock_outline_rounded,
      textoSecreto: true,
      validator: (valor) {
        if (valor == null || valor.isEmpty) return 'Ingresa tu contraseÃ±a';
        if (valor.length < 6) {
          return 'La contraseÃ±a debe tener 6 caracteres o mas';
        }
        return null;
      },
    );
  }

  Widget _campoConfirmar() {
    return CampoFormulario(
      controller: _confirmarCtrl,
      etiqueta: 'Confirmar contraseÃ±a',
      icono: Icons.lock_reset_rounded,
      textoSecreto: true,
      validator: (valor) {
        if (valor == null || valor.isEmpty) return 'Confirma tu contraseÃ±a';
        if (valor != _claveCtrl.text) return 'Las contraseÃ±as no coinciden';
        return null;
      },
    );
  }
}
