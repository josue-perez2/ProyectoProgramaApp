import 'package:flutter/material.dart';

import '../tema/tema_app.dart';

abstract final class Formato {
  static String dos(int valor) => valor.toString().padLeft(2, '0');

  static String fecha(DateTime? momento) {
    if (momento == null) return 'Sin fecha';
    return '${dos(momento.day)}/${dos(momento.month)}/${momento.year}';
  }

  static String hora(DateTime? momento) {
    if (momento == null) return '--:--';
    return '${dos(momento.hour)}:${dos(momento.minute)}';
  }

  static String fechaHora(DateTime? momento) {
    if (momento == null) return 'Sin fecha';
    return '${fecha(momento)} ${hora(momento)}';
  }

  static String fechaHoraSegundos(DateTime? momento) {
    if (momento == null) return 'Sin fecha';
    return '${fecha(momento)} '
        '${dos(momento.hour)}:${dos(momento.minute)}:${dos(momento.second)}';
  }

  static String dinero(double valor) {
    final String negativo = valor < 0 ? '-' : '';
    final String absoluto = valor.abs().toStringAsFixed(2);
    final List<String> partes = absoluto.split('.');
    final String enteros = partes.first;
    final String centavos = partes.length > 1 ? partes[1] : '00';

    final StringBuffer buffer = StringBuffer(negativo);
    for (int i = 0; i < enteros.length; i++) {
      if (i > 0 && (enteros.length - i) % 3 == 0) buffer.write(',');
      buffer.write(enteros[i]);
    }

    buffer.write('.$centavos');
    return 'Q ${buffer.toString()}';
  }

  static String puntos(double? valor) {
    final double cantidad = valor ?? 0;
    if (cantidad == cantidad.roundToDouble()) return cantidad.toStringAsFixed(0);
    return cantidad.toStringAsFixed(2);
  }

  static ColorPago colorPago(String metodo) {
    final String normalizado = metodo.toUpperCase();
    if (normalizado.contains('EFECTIVO')) return ColorPago.efectivo;
    if (normalizado.contains('TARJETA')) return ColorPago.tarjeta;
    return ColorPago.otro;
  }
}

enum ColorPago { efectivo, tarjeta, otro }

extension ColorPagoIcono on ColorPago {
  Color get color {
    switch (this) {
      case ColorPago.efectivo:
        return Colores.verdeSecundario;
      case ColorPago.tarjeta:
        return Colores.azulTarjeta;
      case ColorPago.otro:
        return Colores.textoSecundario;
    }
  }

  IconData get icono {
    switch (this) {
      case ColorPago.efectivo:
        return Icons.payments_rounded;
      case ColorPago.tarjeta:
        return Icons.credit_card_rounded;
      case ColorPago.otro:
        return Icons.account_balance_wallet_rounded;
    }
  }
}