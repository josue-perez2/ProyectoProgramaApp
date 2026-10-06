import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../datos/api_cliente.dart';
import '../datos/opciones_menu.dart';
import '../widgets/encabezado_sesion.dart';
import '../widgets/fondo_decorativo.dart';
import '../widgets/menu_flotante.dart';
import '../widgets/tarjeta_seccion.dart';

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key, this.sesion});

  final Sesion? sesion;

  @override
  Widget build(BuildContext context) {
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
                      child: EncabezadoSesion(puntos: sesion?.saldoPuntoCli),
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

  void _irAPantalla(BuildContext context, {required OpcionMenu opcion}) {
    Navigator.of(context).pushNamed(opcion.ruta);
  }
}
