import 'package:flutter/material.dart';

import '../datos/opciones_menu.dart';
import '../tema/tema_app.dart';
import '../widgets/fondo_decorativo.dart';

class PantallaPlaceholder extends StatelessWidget {
  const PantallaPlaceholder({super.key, this.opcion});

  final OpcionMenu? opcion;

  @override
  Widget build(BuildContext context) {
    final OpcionMenu? seleccion = opcion ??
        ModalRoute.of(context)?.settings.arguments as OpcionMenu?;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        title: Text(seleccion?.titulo ?? 'Vista'),
      ),
      extendBodyBehindAppBar: true,
      body: FondoDecorativo(
        child: SafeArea(
          child: Center(
            child: Text(
              seleccion?.titulo ?? 'Vista',
              style: const TextStyle(
                color: Colores.textoTarjeta,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
