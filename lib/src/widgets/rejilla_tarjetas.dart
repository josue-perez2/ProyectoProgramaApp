import 'package:flutter/material.dart';

class RejillaTarjetas extends StatelessWidget {
  const RejillaTarjetas({
    super.key,
    required this.tarjetas,
    this.tarjetasPorFila = 2,
    this.espaciado = 16,
  });

  final List<Widget> tarjetas;
  final int tarjetasPorFila;
  final double espaciado;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double ancho =
            (constraints.maxWidth - espaciado * (tarjetasPorFila - 1)) /
            tarjetasPorFila;

        return Wrap(
          spacing: espaciado,
          runSpacing: espaciado,
          children: <Widget>[
            for (final Widget tarjeta in tarjetas)
              SizedBox(width: ancho, child: tarjeta),
          ],
        );
      },
    );
  }
}