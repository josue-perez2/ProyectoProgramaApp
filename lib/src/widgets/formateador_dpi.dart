import 'package:flutter/services.dart';


class FormateadorDpi extends TextInputFormatter {
  const FormateadorDpi();

  static const int digitosTotales = 13;

  static const int caracteresTotales = digitosTotales + 2;

  static final RegExp _noDigitos = RegExp(r'\D');

  static String soloDigitos(String valor) => valor.replaceAll(_noDigitos, '');

  static String formatear(String valor) {
    final String digitos = soloDigitos(valor);
    final StringBuffer buffer = StringBuffer();

    for (int i = 0; i < digitos.length; i++) {
      if (i >= digitosTotales) break;
      if (i == 4 || i == 9) buffer.write(' ');
      buffer.write(digitos[i]);
    }

    return buffer.toString();
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue anterior,
    TextEditingValue nuevo,
  ) {
    final String texto = formatear(nuevo.text);

    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}