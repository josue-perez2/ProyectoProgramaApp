import 'api_cliente.dart';

abstract final class SesionActual {
  static Sesion? _sesion;
  static String? _correo;

  static Sesion? get sesion => _sesion;

  static String get correo => _correo ?? _sesion?.correoCli ?? '';

  static double? get saldoPunto => _sesion?.saldoPuntoCli;

  static bool get activa => _sesion != null;

  static void iniciar(Sesion sesion, {String? correo}) {
    _sesion = sesion;
    _correo = correo;
  }

  static void cerrar() {
    _sesion = null;
    _correo = null;
  }

  static String formatearPuntos(double? puntos) {
    final double valor = puntos ?? 0;
    if (valor == valor.roundToDouble()) return valor.toStringAsFixed(0);
    return valor.toStringAsFixed(2);
  }
}