import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../datos/api_cliente.dart';
import '../datos/opciones_menu.dart';
import '../rutas.dart';
import '../tema/tema_app.dart';
import '../widgets/fondo_decorativo.dart';
import '../widgets/menu_flotante.dart';
import '../widgets/tarjeta_seccion.dart';

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key, this.sesion});

  final Sesion? sesion;

  @override
  Widget build(BuildContext context) {
    final String nombre = sesion?.nombreCli ?? '';

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: FondoDecorativo(
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FadeInDown(
                      duration: const Duration(milliseconds: 700),
                      child: _cardBienvenida(nombre),
                    ),
                    const SizedBox(height: 24),
                    _filaTarjetas(context, desde: 0),
                    const SizedBox(height: 16),
                    _filaTarjetas(context, desde: 2),
                    const SizedBox(height: 130),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 20,
              child: SafeArea(
                child: MenuFlotante(
                  alSeleccionar: (opcion) =>
                      _irAPantalla(context, opcion: opcion),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filaTarjetas(BuildContext context, {required int desde}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = desde; i < desde + 2; i++) ...[
          if (i > desde) const SizedBox(width: 16),
          Expanded(
            child: FadeInUp(
              key: ValueKey(opcionesMenu[i].titulo),
              duration: const Duration(milliseconds: 600),
              delay: Duration(milliseconds: 200 + i * 90),
              child: TarjetaSeccion(
                opcion: opcionesMenu[i],
                alTocar: () =>
                    _irAPantalla(context, opcion: opcionesMenu[i]),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _cardBienvenida(String nombre) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colores.verdePrimario.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colores.verdeProfundo.withValues(alpha: 0.16),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bienvenido',
            style: TextStyle(
              color: Colores.textoSecundario,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            nombre,
            style: const TextStyle(
              color: Colores.textoTarjeta,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  void _irAPantalla(BuildContext context, {required OpcionMenu opcion}) {
    Navigator.of(context).pushNamed(Rutas.placeholder, arguments: opcion);
  }
}
