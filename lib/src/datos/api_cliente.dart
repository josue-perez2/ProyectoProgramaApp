import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'clave_sha256.dart';

class ApiException implements Exception {
  const ApiException(this.mensaje, {this.estado});

  final String mensaje;
  final int? estado;

  @override
  String toString() => mensaje;
}

class ResultadoRegistro {
  const ResultadoRegistro({
    required this.mensaje,
    required this.idCli,
    required this.nombreCli,
    this.correoCli,
  });

  final String mensaje;
  final int idCli;
  final String nombreCli;
  final String? correoCli;
}

class Sesion {
  const Sesion({
    required this.token,
    required this.idCli,
    required this.nombreCli,
    this.correoCli,
    this.saldoPuntoCli,
  });

  final String token;
  final int idCli;
  final String nombreCli;
  final String? correoCli;
  final double? saldoPuntoCli;
}


abstract final class ApiCliente {
  static const String baseUrl = 'http://192.168.0.23:8080';
  static const Duration _timeout = Duration(seconds: 15);


  static Future<ResultadoRegistro> registrar({
    required String dpi,
    required String correo,
    required String password,
  }) async {
    final Map<String, dynamic> cuerpo = await _enviar(
      '/api/registro',
      <String, dynamic>{
        'dpi': dpi,
        'correo': correo,
        'password': Clave.sha256(password),
      },
    );

    return ResultadoRegistro(
      mensaje: _texto(cuerpo['mensaje']) ?? 'Registro exitoso',
      idCli: _entero(cuerpo['idCli']) ?? 0,
      nombreCli: _texto(cuerpo['nombreCli']) ?? '',
      correoCli: _texto(cuerpo['correoCli']),
    );
  }

  static Future<Sesion> iniciarSesion({
    required String correo,
    required String password,
  }) async {
    final Map<String, dynamic> cuerpo = await _enviar(
      '/api/login',
      <String, dynamic>{'correo': correo, 'password': Clave.sha256(password)},
    );

    final String? token = _texto(cuerpo['token']);
    if (token == null || token.isEmpty) {
      throw const ApiException('La API no devolvio un token de sesion.');
    }

    return Sesion(
      token: token,
      idCli: _entero(cuerpo['idCli']) ?? 0,
      nombreCli: _texto(cuerpo['nombreCli']) ?? '',
      correoCli: _texto(cuerpo['correoCli']),
      saldoPuntoCli: _decimal(cuerpo['saldoPuntoCli']),
    );
  }

  static Future<Map<String, dynamic>> _enviar(
    String ruta,
    Map<String, dynamic> cuerpo,
  ) async {
    final Uri uri = Uri.parse('$baseUrl$ruta');

    late final http.Response respuesta;
    try {
      respuesta = await http
          .post(
            uri,
            headers: const <String, String>{
              'Content-Type': 'application/json; charset=utf-8',
              'Accept': 'application/json',
            },
            body: jsonEncode(cuerpo),
          )
          .timeout(_timeout);
    } on SocketException {
      throw const ApiException(
        'No se pudo conectar con el servidor. Revisa que la API este '
        'encendida y que la IP en API_URL sea correcta.',
      );
    } on HttpException {
      throw const ApiException('El servidor respondio con un error de red.');
    } catch (e) {
      throw ApiException('No se pudo completar la peticion: $e');
    }

    Map<String, dynamic> cuerpoRespuesta = <String, dynamic>{};
    if (respuesta.body.isNotEmpty) {
      try {
        final dynamic decodificado = jsonDecode(respuesta.body);
        if (decodificado is Map<String, dynamic>) {
          cuerpoRespuesta = decodificado;
        }
      } on FormatException {
        throw ApiException(
          'La API devolvio una respuesta ilegible (HTTP ${respuesta.statusCode}).',
          estado: respuesta.statusCode,
        );
      }
    }

    if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
      if (cuerpoRespuesta['ok'] == false) {
        throw ApiException(
          _texto(cuerpoRespuesta['error']) ?? 'La API rechazo la operacion.',
          estado: respuesta.statusCode,
        );
      }
      return cuerpoRespuesta;
    }

    throw ApiException(
      _texto(cuerpoRespuesta['error']) ??
          'La API respondio con el codigo ${respuesta.statusCode}.',
      estado: respuesta.statusCode,
    );
  }

  static String? _texto(Object? valor) {
    if (valor == null) return null;
    final String texto = valor is String ? valor : valor.toString();
    return texto.trim().isEmpty ? null : texto;
  }

  static int? _entero(Object? valor) {
    if (valor is int) return valor;
    if (valor is num) return valor.toInt();
    return int.tryParse(valor?.toString() ?? '');
  }

  static double? _decimal(Object? valor) {
    if (valor is num) return valor.toDouble();
    return double.tryParse(valor?.toString() ?? '');
  }
}
