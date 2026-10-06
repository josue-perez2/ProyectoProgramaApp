import 'package:flutter/material.dart';

import '../datos/sesion_actual.dart';
import '../tema/tema_app.dart';

class EncabezadoSesion extends StatelessWidget {
  const EncabezadoSesion({super.key, required this.puntos});

  final double? puntos;

  @override
  Widget build(BuildContext context) {
    final String nombre = SesionActual.sesion?.nombreCli ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colores.verdePrimario.withValues(alpha: 0.25),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colores.verdeProfundo.withValues(alpha: 0.16),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              nombre,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colores.textoTarjeta,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: Colores.verdePrimario.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'MIS PUNTOS',
                  style: TextStyle(
                    color: Colores.textoSecundario,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  SesionActual.formatearPuntos(puntos ?? SesionActual.saldoPunto),
                  style: const TextStyle(
                    color: Colores.verdeBoton,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
