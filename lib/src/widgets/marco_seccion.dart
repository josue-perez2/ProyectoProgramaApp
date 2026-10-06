import 'package:flutter/material.dart';

import '../datos/opciones_menu.dart';
import '../tema/tema_app.dart';
import 'encabezado_sesion.dart';
import 'fondo_decorativo.dart';
import 'menu_flotante.dart';

class MarcoSeccion extends StatelessWidget {
  const MarcoSeccion({
    super.key,
    required this.opcion,
    required this.puntos,
    required this.cargando,
    this.mensajeError,
    this.mensajeVacio,
    this.alReintentar,
    this.children = const <Widget>[],
  });

  final OpcionMenu opcion;
  final double? puntos;
  final bool cargando;
  final String? mensajeError;
  final String? mensajeVacio;
  final VoidCallback? alReintentar;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(opcion.titulo),
      ),
      extendBodyBehindAppBar: true,
      body: FondoDecorativo(
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    EncabezadoSesion(puntos: puntos),
                    const SizedBox(height: 24),
                    _contenido(),
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
                  alSeleccionar: (opcionElegida) =>
                      _irA(context, opcionElegida),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _irA(BuildContext context, OpcionMenu elegida) {
    if (elegida.ruta == opcion.ruta) return;
    Navigator.of(context).pushNamed(elegida.ruta);
  }

  Widget _contenido() {
    if (cargando) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: CircularProgressIndicator(color: Colores.verdeBoton),
        ),
      );
    }

    if (mensajeError != null) {
      return _aviso(
        icono: Icons.cloud_off_rounded,
        texto: mensajeError!,
        accion: alReintentar == null
            ? null
            : OutlinedButton.icon(
                onPressed: alReintentar,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reintentar'),
              ),
      );
    }

    if (children.isEmpty) {
      return _aviso(
        icono: Icons.inbox_rounded,
        texto: mensajeVacio ?? 'Todavia no hay nada que mostrar aqui.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  Widget _aviso({
    required IconData icono,
    required String texto,
    Widget? accion,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 34),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colores.verdePrimario.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        children: <Widget>[
          Icon(icono, size: 40, color: Colores.verdeSecundario),
          const SizedBox(height: 14),
          Text(
            texto,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colores.textoTarjeta,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (accion != null) ...<Widget>[
            const SizedBox(height: 20),
            SizedBox(height: 48, child: accion),
          ],
        ],
      ),
    );
  }
}