import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../tema/tema_app.dart';

class OndaSuperior extends StatelessWidget {
  const OndaSuperior({super.key, this.altura = 210, this.duracion = 7});

  final double altura;
  final double duracion;

  @override
  Widget build(BuildContext context) {
    return _OndaAnimada(altura: altura, duracion: duracion, haciaArriba: true);
  }
}

class OndaInferior extends StatelessWidget {
  const OndaInferior({super.key, this.altura = 210, this.duracion = 9});

  final double altura;
  final double duracion;

  @override
  Widget build(BuildContext context) {
    return _OndaAnimada(altura: altura, duracion: duracion, haciaArriba: false);
  }
}

class _OndaAnimada extends StatelessWidget {
  const _OndaAnimada({
    required this.altura,
    required this.duracion,
    required this.haciaArriba,
  });

  final double altura;
  final double duracion;
  final bool haciaArriba;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: double.infinity,
        height: altura,
        child: RepeatingAnimationBuilder(
          animatable: Tween<double>(begin: 0, end: 1),
          duration: Duration(milliseconds: (duracion * 1000).round()),
          curve: Curves.linear,
          builder: (context, fase, child) => CustomPaint(
            painter: PintadorOnda(fase: fase, haciaArriba: haciaArriba),
          ),
        ),
      ),
    );
  }
}

class PintadorOnda extends CustomPainter {
  const PintadorOnda({required this.fase, this.haciaArriba = true});

  final double fase;
  final bool haciaArriba;

  static const double _amplitud = 13;
  static const double _ciclos = 1.4;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    if (haciaArriba) {
      _pintar(canvas, size, fase);
      return;
    }

    canvas.save();
    canvas.translate(0, size.height);
    canvas.scale(1, -1);
    _pintar(canvas, size, fase + 0.35);
    canvas.restore();
  }

  void _pintar(Canvas canvas, Size size, double avanceFase) {
    final avance = avanceFase * 2 * math.pi;

    _pintarCapa(
      canvas,
      size,
      base: size.height * 0.46,
      amplitud: _amplitud * 1.35,
      desfase: avance * 0.55,
      color: Colores.verdeProfundo.withValues(alpha: 0.22),
    );

    _pintarCapa(
      canvas,
      size,
      base: size.height * 0.32,
      amplitud: _amplitud,
      desfase: avance,
      color: Colores.verdePrimario.withValues(alpha: 0.28),
    );
  }

  void _pintarCapa(
    Canvas canvas,
    Size size, {
    required double base,
    required double amplitud,
    required double desfase,
    required Color color,
  }) {
    final camino = Path()..moveTo(0, 0);
    camino.lineTo(0, _altura(size, 0, base, amplitud, desfase));

    for (double x = 0; x <= size.width; x += 3) {
      camino.lineTo(x, _altura(size, x, base, amplitud, desfase));
    }

    camino.lineTo(size.width, 0);
    camino.close();

    canvas.drawPath(
      camino,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color, color.withValues(alpha: 0)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    canvas.drawPath(
      camino,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colores.verdePrimario.withValues(alpha: 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
  }

  double _altura(
    Size size,
    double x,
    double base,
    double amplitud,
    double desfase,
  ) {
    final progreso = x / size.width * _ciclos * math.pi * 2;
    return base + math.sin(progreso + desfase) * amplitud;
  }

  @override
  bool shouldRepaint(PintadorOnda anterior) =>
      anterior.fase != fase || anterior.haciaArriba != haciaArriba;
}
