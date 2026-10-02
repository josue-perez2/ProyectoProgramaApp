import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../tema/tema_app.dart';

class ResplandorVerde extends StatelessWidget {
  const ResplandorVerde({super.key, this.altura = 300});

  final double altura;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: double.infinity,
        height: altura,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colores.verdePrimario.withValues(alpha: 0.22),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: -110,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
                child: Pulse(
                  infinite: true,
                  duration: const Duration(milliseconds: 3400),
                  curve: Curves.easeInOut,
                  from: 0.94,
                  to: 1.07,
                  child: Container(
                    width: 230,
                    height: 230,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                      colors: [
                        Colores.verdePrimario.withValues(alpha: 0.45),
                        Colores.verdeSecundario.withValues(alpha: 0.18),
                        Colors.transparent,
                      ],
                        stops: const [0, 0.5, 1],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 34,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 14),
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colores.verdeBoton.withValues(alpha: 0.45),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
