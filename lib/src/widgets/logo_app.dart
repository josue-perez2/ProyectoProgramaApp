import 'package:flutter/material.dart';

import '../tema/tema_app.dart';

class LogoApp extends StatelessWidget {
  const LogoApp({super.key, this.ancho = 240});

  final double ancho;

  static const double _proporcion = 900 / 289;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ancho,
      padding: EdgeInsets.symmetric(
        horizontal: ancho * 0.10,
        vertical: ancho * 0.075,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ancho * 0.14),
        border: Border.all(
          color: Colores.verdePrimario.withValues(alpha: 0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colores.verdeProfundo.withValues(alpha: 0.22),
            blurRadius: ancho * 0.12,
            offset: Offset(0, ancho * 0.05),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: _proporcion,
        child: Image.asset(
          'assets/logo3.png',
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
          excludeFromSemantics: true,
        ),
      ),
    );
  }
}
