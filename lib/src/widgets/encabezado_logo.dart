import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'logo_app.dart';

class EncabezadoLogo extends StatelessWidget {
  const EncabezadoLogo({
    super.key,
    required this.titulo,
     this.subtitulo = "",
    this.anchoLogo = 250,
  });

  final String titulo;
  final String subtitulo;
  final double anchoLogo;

  @override
  Widget build(BuildContext context) {
    return FadeInDownBig(
      duration: const Duration(milliseconds: 900),
      child: Column(
        children: [
          Pulse(
            infinite: true,
            duration: const Duration(milliseconds: 2600),
            curve: Curves.easeInOut,
            from: 1,
            to: 1.06,
            child: LogoApp(ancho: anchoLogo),
          ),
          const SizedBox(height: 26),
          Text(titulo, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            subtitulo,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
