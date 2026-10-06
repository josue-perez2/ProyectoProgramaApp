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

class ResumenPuntos {
  const ResumenPuntos({
    required this.saldoPuntoCli,
    required this.totalCanjeables,
    required this.totalPendientes,
  });

  factory ResumenPuntos.desdeJson(Map<String, dynamic> json) {
    return ResumenPuntos(
      saldoPuntoCli: _decimal(json['saldoPuntoCli']) ?? 0,
      totalCanjeables: _entero(json['totalCanjeables']) ?? 0,
      totalPendientes: _entero(json['totalPendientes']) ?? 0,
    );
  }

  final double saldoPuntoCli;
  final int totalCanjeables;
  final int totalPendientes;
}

class Recompensa {
  const Recompensa({
    required this.idRec,
    required this.nombreRec,
    required this.puntosRequeridosRec,
    required this.tipoItemRec,
    required this.idItemRec,
    required this.canjeable,
    required this.puntosFaltantes,
  });

  factory Recompensa.desdeJson(Map<String, dynamic> json) {
    return Recompensa(
      idRec: _entero(json['idRec']) ?? 0,
      nombreRec: _texto(json['nombreRec']) ?? 'Recompensa',
      puntosRequeridosRec: _entero(json['puntosRequeridosRec']) ?? 0,
      tipoItemRec: _texto(json['tipoItemRec']) ?? '',
      idItemRec: _entero(json['idItemRec']) ?? 0,
      canjeable: json['canjeable'] == true,
      puntosFaltantes: _entero(json['puntosFaltantes']) ?? 0,
    );
  }

  final int idRec;
  final String nombreRec;
  final int puntosRequeridosRec;
  final String tipoItemRec;
  final int idItemRec;
  final bool canjeable;
  final int puntosFaltantes;

  String get etiquetaTipo {
    switch (tipoItemRec) {
      case 'P':
        return 'Producto';
      case 'S':
        return 'Sandwich';
      case 'M':
        return 'Menu';
      default:
        return 'Recompensa';
    }
  }
}

class CatalogoRecompensas {
  const CatalogoRecompensas({
    required this.idCli,
    required this.nombreCli,
    required this.resumen,
    required this.recompensas,
  });

  factory CatalogoRecompensas.desdeJson(Map<String, dynamic> json) {
    final dynamic resumenCrudo = json['resumen'];
    final dynamic listaCruda = json['recompensas'];

    return CatalogoRecompensas(
      idCli: _entero(json['idCli']) ?? 0,
      nombreCli: _texto(json['nombreCli']) ?? '',
      resumen: resumenCrudo is Map<String, dynamic>
          ? ResumenPuntos.desdeJson(resumenCrudo)
          : const ResumenPuntos(
              saldoPuntoCli: 0,
              totalCanjeables: 0,
              totalPendientes: 0,
            ),
      recompensas: listaCruda is List
          ? <Recompensa>[
              for (final dynamic item in listaCruda)
                if (item is Map<String, dynamic>) Recompensa.desdeJson(item),
            ]
          : const <Recompensa>[],
    );
  }

  final int idCli;
  final String nombreCli;
  final ResumenPuntos resumen;
  final List<Recompensa> recompensas;
}

class MovimientoPunto {
  const MovimientoPunto({
    required this.idHis,
    required this.fechaHis,
    required this.tipoOperacionHis,
    required this.puntosHis,
    required this.referenciaHis,
  });

  factory MovimientoPunto.desdeJson(Map<String, dynamic> json) {
    final String? fecha = _texto(json['fechaHis']);

    return MovimientoPunto(
      idHis: _entero(json['idHis']) ?? 0,
      fechaHis: fecha == null ? null : DateTime.tryParse(fecha),
      tipoOperacionHis: _texto(json['tipoOperacionHis']) ?? '',
      puntosHis: _entero(json['puntosHis']) ?? 0,
      referenciaHis: _texto(json['referenciaHis']),
    );
  }

  final int idHis;
  final DateTime? fechaHis;
  final String tipoOperacionHis;
  final int puntosHis;
  final String? referenciaHis;

  bool get esGanado => puntosHis >= 0;

  String get nombre {
    final String? referencia = referenciaHis;
    if (referencia != null) return referencia;
    return esGanado ? 'Puntos agregados' : 'Recompensa canjeada';
  }
}

class HistorialPuntos {
  const HistorialPuntos({
    required this.idCli,
    required this.nombreCli,
    required this.saldoPuntoCli,
    required this.totalMovimientos,
    required this.puntosObtenidos,
    required this.puntosCanjeados,
    required this.movimientos,
  });

  factory HistorialPuntos.desdeJson(Map<String, dynamic> json) {
    final dynamic listaCruda = json['historial'];

    return HistorialPuntos(
      idCli: _entero(json['idCli']) ?? 0,
      nombreCli: _texto(json['nombreCli']) ?? '',
      saldoPuntoCli: _decimal(json['saldoPuntoCli']) ?? 0,
      totalMovimientos: _entero(json['totalMovimientos']) ?? 0,
      puntosObtenidos: _entero(json['puntosObtenidos']) ?? 0,
      puntosCanjeados: _entero(json['puntosCanjeados']) ?? 0,
      movimientos: listaCruda is List
          ? <MovimientoPunto>[
              for (final dynamic item in listaCruda)
                if (item is Map<String, dynamic>)
                  MovimientoPunto.desdeJson(item),
            ]
          : const <MovimientoPunto>[],
    );
  }

  final int idCli;
  final String nombreCli;
  final double saldoPuntoCli;
  final int totalMovimientos;
  final int puntosObtenidos;
  final int puntosCanjeados;
  final List<MovimientoPunto> movimientos;
}

class PerfilCliente {
  const PerfilCliente({
    required this.idCli,
    required this.nombreCli,
    required this.dpiCli,
    required this.correoCli,
    required this.telefonoCli,
    required this.direccionCli,
    required this.saldoPuntoCli,
    required this.totalPedidos,
    required this.estadoCli,
  });

  factory PerfilCliente.desdeJson(Map<String, dynamic> json) {
    final bool tieneDpi = json['tieneDpi'] == true;
    final bool tieneTelefono = json['tieneTelefono'] == true;

    return PerfilCliente(
      idCli: _entero(json['idCli']) ?? 0,
      nombreCli: _texto(json['nombreCli']) ?? '',
      dpiCli: tieneDpi
          ? (_texto(json['dpiCliFormateado']) ?? _texto(json['dpiCli']) ?? '')
          : '',
      correoCli: _texto(json['correoCli']) ?? '',
      telefonoCli: tieneTelefono
          ? (_texto(json['telefonoCliFormateado']) ?? _texto(json['telefonoCli']) ?? '')
          : '',
      direccionCli: json['tieneDireccion'] == true
          ? (_texto(json['direccionCli']) ?? '')
          : '',
      saldoPuntoCli: _decimal(json['saldoPuntoCli']) ?? 0,
      totalPedidos: _entero(json['totalPedidos']) ?? 0,
      estadoCli: _texto(json['estadoCli']) ?? 'A',
    );
  }

  final int idCli;
  final String nombreCli;
  final String dpiCli;
  final String correoCli;
  final String telefonoCli;
  final String direccionCli;
  final double saldoPuntoCli;
  final int totalPedidos;
  final String estadoCli;

  bool get activo => estadoCli.toUpperCase() != 'I';

  String get estadoDescripcion => activo ? 'ACTIVO' : 'INACTIVO';
}

class CanjeRealizado {
  const CanjeRealizado({
    required this.idCan,
    required this.fechaCan,
    required this.nombreRec,
    required this.puntosRecompensaCan,
    required this.tipoItemRec,
  });

  factory CanjeRealizado.desdeJson(Map<String, dynamic> json) {
    final String? fecha = _texto(json['fechaCan']);

    return CanjeRealizado(
      idCan: _entero(json['idCan']) ?? 0,
      fechaCan: fecha == null ? null : DateTime.tryParse(fecha),
      nombreRec: _texto(json['nombreRec']) ?? 'Recompensa',
      puntosRecompensaCan: _entero(json['puntosRecompensaCan']) ?? 0,
      tipoItemRec: _texto(json['tipoItemRec']) ?? '',
    );
  }

  final int idCan;
  final DateTime? fechaCan;
  final String nombreRec;
  final int puntosRecompensaCan;
  final String tipoItemRec;

  String get etiquetaTipo {
    switch (tipoItemRec) {
      case 'P':
        return 'Producto';
      case 'S':
        return 'Sandwich';
      case 'M':
        return 'Menu';
      default:
        return 'Recompensa';
    }
  }
}

class HistorialCanjes {
  const HistorialCanjes({
    required this.idCli,
    required this.nombreCli,
    required this.saldoPuntoCli,
    required this.totalCanjes,
    required this.puntosCanjeados,
    required this.canjes,
  });

  factory HistorialCanjes.desdeJson(Map<String, dynamic> json) {
    final dynamic listaCruda = json['canjes'];

    return HistorialCanjes(
      idCli: _entero(json['idCli']) ?? 0,
      nombreCli: _texto(json['nombreCli']) ?? '',
      saldoPuntoCli: _decimal(json['saldoPuntoCli']) ?? 0,
      totalCanjes: _entero(json['totalCanjes']) ?? 0,
      puntosCanjeados: _entero(json['puntosCanjeados']) ?? 0,
      canjes: listaCruda is List
          ? <CanjeRealizado>[
              for (final dynamic item in listaCruda)
                if (item is Map<String, dynamic>) CanjeRealizado.desdeJson(item),
            ]
          : const <CanjeRealizado>[],
    );
  }

  final int idCli;
  final String nombreCli;
  final double saldoPuntoCli;
  final int totalCanjes;
  final int puntosCanjeados;
  final List<CanjeRealizado> canjes;
}

class ResultadoCanje {
  const ResultadoCanje({
    required this.mensaje,
    required this.nombreRec,
    required this.puntosCanjeados,
    required this.saldoActual,
  });

  factory ResultadoCanje.desdeJson(Map<String, dynamic> json) {
    return ResultadoCanje(
      mensaje: _texto(json['mensaje']) ?? 'Canje realizado con exito',
      nombreRec: _texto(json['nombreRec']) ?? 'Recompensa',
      puntosCanjeados: _entero(json['puntosCanjeados']) ?? 0,
      saldoActual: _decimal(json['saldoActual']) ?? 0,
    );
  }

  final String mensaje;
  final String nombreRec;
  final int puntosCanjeados;
  final double saldoActual;
}

class Pedido {
  const Pedido({
    required this.idPed,
    required this.correlativo,
    required this.fechaPed,
    required this.totalPed,
    required this.puntosObtenidosPed,
    required this.estadoPedDescripcion,
    required this.totalProductos,
    required this.metodoPago,
    required this.esEfectivo,
    required this.esTarjeta,
  });

  factory Pedido.desdeJson(Map<String, dynamic> json) {
    final String? fecha = _texto(json['fechaPed']);

    return Pedido(
      idPed: _entero(json['idPed']) ?? 0,
      correlativo: _texto(json['correlativo']) ?? '',
      fechaPed: fecha == null ? null : DateTime.tryParse(fecha),
      totalPed: _decimal(json['totalPed']) ?? 0,
      puntosObtenidosPed: _entero(json['puntosObtenidosPed']) ?? 0,
      estadoPedDescripcion: _texto(json['estadoPedDescripcion']) ?? 'PENDIENTE',
      totalProductos: _entero(json['totalProductos']) ?? 0,
      metodoPago: _texto(json['metodoPago']) ?? 'PENDIENTE',
      esEfectivo: json['esEfectivo'] == true,
      esTarjeta: json['esTarjeta'] == true,
    );
  }

  final int idPed;
  final String correlativo;
  final DateTime? fechaPed;
  final double totalPed;
  final int puntosObtenidosPed;
  final String estadoPedDescripcion;
  final int totalProductos;
  final String metodoPago;
  final bool esEfectivo;
  final bool esTarjeta;
}

class ListaPedidos {
  const ListaPedidos({
    required this.idCli,
    required this.nombreCli,
    required this.saldoPuntoCli,
    required this.totalPedidos,
    required this.pedidos,
  });

  factory ListaPedidos.desdeJson(Map<String, dynamic> json) {
    final dynamic listaCruda = json['pedidos'];

    return ListaPedidos(
      idCli: _entero(json['idCli']) ?? 0,
      nombreCli: _texto(json['nombreCli']) ?? '',
      saldoPuntoCli: _decimal(json['saldoPuntoCli']) ?? 0,
      totalPedidos: _entero(json['totalPedidos']) ?? 0,
      pedidos: listaCruda is List
          ? <Pedido>[
              for (final dynamic item in listaCruda)
                if (item is Map<String, dynamic>) Pedido.desdeJson(item),
            ]
          : const <Pedido>[],
    );
  }

  final int idCli;
  final String nombreCli;
  final double saldoPuntoCli;
  final int totalPedidos;
  final List<Pedido> pedidos;
}

class ProductoFactura {
  const ProductoFactura({
    required this.idDet,
    required this.nombreItemDet,
    required this.tipoDescripcion,
    required this.cantidadDet,
    required this.precioUnitarioDet,
    required this.subtotalDet,
    required this.puntosGeneradosDet,
  });

  factory ProductoFactura.desdeJson(Map<String, dynamic> json) {
    return ProductoFactura(
      idDet: _entero(json['idDet']) ?? 0,
      nombreItemDet: _texto(json['nombreItemDet']) ?? 'Producto',
      tipoDescripcion: _texto(json['tipoDescripcion']) ?? 'PRODUCTO',
      cantidadDet: _decimal(json['cantidadDet']) ?? 0,
      precioUnitarioDet: _decimal(json['precioUnitarioDet']) ?? 0,
      subtotalDet: _decimal(json['subtotalDet']) ?? 0,
      puntosGeneradosDet: _entero(json['puntosGeneradosDet']) ?? 0,
    );
  }

  final int idDet;
  final String nombreItemDet;
  final String tipoDescripcion;
  final double cantidadDet;
  final double precioUnitarioDet;
  final double subtotalDet;
  final int puntosGeneradosDet;
}

class PagoFactura {
  const PagoFactura({
    required this.tienePago,
    required this.metodoPago,
    required this.fechaPag,
    required this.montoRecibidoPag,
    required this.cambioPag,
    required this.numeroReferenciaPag,
    required this.esEfectivo,
    required this.esTarjeta,
  });

  factory PagoFactura.desdeJson(Map<String, dynamic> json) {
    final String? fecha = _texto(json['fechaPag']);

    return PagoFactura(
      tienePago: json['tienePago'] == true,
      metodoPago: _texto(json['metodoPago']) ?? 'PENDIENTE',
      fechaPag: fecha == null ? null : DateTime.tryParse(fecha),
      montoRecibidoPag: _decimal(json['montoRecibidoPag']) ?? 0,
      cambioPag: _decimal(json['cambioPag']) ?? 0,
      numeroReferenciaPag: _texto(json['numeroReferenciaPag']),
      esEfectivo: json['esEfectivo'] == true,
      esTarjeta: json['esTarjeta'] == true,
    );
  }

  final bool tienePago;
  final String metodoPago;
  final DateTime? fechaPag;
  final double montoRecibidoPag;
  final double cambioPag;
  final String? numeroReferenciaPag;
  final bool esEfectivo;
  final bool esTarjeta;
}

class FacturaPedido {
  const FacturaPedido({
    required this.pedido,
    required this.pago,
    required this.productos,
    required this.nombreCli,
    required this.dpiCli,
    required this.saldoPuntoCli,
  });

  factory FacturaPedido.desdeJson(Map<String, dynamic> json) {
    final dynamic facturaCruda = json['factura'];
    final dynamic pagoCrudo = json['pago'];
    final dynamic productosCrudo = json['productos'];

    return FacturaPedido(
      pedido: facturaCruda is Map<String, dynamic>
          ? Pedido.desdeJson(facturaCruda)
          : const Pedido(
              idPed: 0,
              correlativo: '',
              fechaPed: null,
              totalPed: 0,
              puntosObtenidosPed: 0,
              estadoPedDescripcion: 'PENDIENTE',
              totalProductos: 0,
              metodoPago: 'PENDIENTE',
              esEfectivo: false,
              esTarjeta: false,
            ),
      pago: pagoCrudo is Map<String, dynamic>
          ? PagoFactura.desdeJson(pagoCrudo)
          : const PagoFactura(
              tienePago: false,
              metodoPago: 'PENDIENTE',
              fechaPag: null,
              montoRecibidoPag: 0,
              cambioPag: 0,
              numeroReferenciaPag: null,
              esEfectivo: false,
              esTarjeta: false,
            ),
      productos: productosCrudo is List
          ? <ProductoFactura>[
              for (final dynamic item in productosCrudo)
                if (item is Map<String, dynamic>) ProductoFactura.desdeJson(item),
            ]
          : const <ProductoFactura>[],
      nombreCli: _texto(json['nombreCli']) ?? '',
      dpiCli: _texto(json['dpiCliFormateado']) ?? _texto(json['dpiCli']) ?? '',
      saldoPuntoCli: _decimal(json['saldoPuntoCli']) ?? 0,
    );
  }

  final Pedido pedido;
  final PagoFactura pago;
  final List<ProductoFactura> productos;
  final String nombreCli;
  final String dpiCli;
  final double saldoPuntoCli;

  int get puntosGenerados =>
      productos.fold<int>(0, (total, item) => total + item.puntosGeneradosDet);
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

  static Future<CatalogoRecompensas> recompensas(String token) async {
    final Map<String, dynamic> cuerpo = await _consultar(
      '/api/puntos/recompensas',
      token,
    );

    return CatalogoRecompensas.desdeJson(cuerpo);
  }

  static Future<HistorialPuntos> historialPuntos(String token) async {
    final Map<String, dynamic> cuerpo = await _consultar(
      '/api/puntos/historial',
      token,
    );

    return HistorialPuntos.desdeJson(cuerpo);
  }

  static Future<HistorialCanjes> historialCanjes(String token) async {
    final Map<String, dynamic> cuerpo = await _consultar(
      '/api/puntos/canjes',
      token,
    );

    return HistorialCanjes.desdeJson(cuerpo);
  }

  static Future<ResultadoCanje> canjear({
    required String token,
    required int idRec,
  }) async {
    final Map<String, dynamic> cuerpo = await _enviar(
      '/api/puntos/canjear',
      <String, dynamic>{'idRec': idRec},
      token: token,
    );

    return ResultadoCanje.desdeJson(cuerpo);
  }

  static Future<PerfilCliente> perfil(String token) async {
    final Map<String, dynamic> cuerpo = await _consultar(
      '/api/cliente/perfil',
      token,
    );

    return PerfilCliente.desdeJson(cuerpo);
  }

  static Future<ListaPedidos> pedidos(String token) async {
    final Map<String, dynamic> cuerpo = await _consultar(
      '/api/pedidos',
      token,
    );

    return ListaPedidos.desdeJson(cuerpo);
  }

  static Future<FacturaPedido> factura(String token, int idPed) async {
    final Map<String, dynamic> cuerpo = await _consultar(
      '/api/pedidos/$idPed',
      token,
    );

    return FacturaPedido.desdeJson(cuerpo);
  }

  static Future<Map<String, dynamic>> _consultar(
    String ruta,
    String token,
  ) async {
    if (token.trim().isEmpty) {
      throw const ApiException('No hay una sesion activa, inicia sesion de nuevo.');
    }

    final Uri uri = Uri.parse('$baseUrl$ruta');

    late final http.Response respuesta;
    try {
      respuesta = await http
          .get(
            uri,
            headers: <String, String>{
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
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

    return _interpretar(respuesta);
  }

  static Future<Map<String, dynamic>> _enviar(
    String ruta,
    Map<String, dynamic> cuerpo, {
    String? token,
  }) async {
    final Uri uri = Uri.parse('$baseUrl$ruta');

    final Map<String, String> cabeceras = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json',
    };
    if (token != null && token.trim().isNotEmpty) {
      cabeceras['Authorization'] = 'Bearer $token';
    }

    late final http.Response respuesta;
    try {
      respuesta = await http
          .post(
            uri,
            headers: cabeceras,
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

    return _interpretar(respuesta);
  }

  static Map<String, dynamic> _interpretar(http.Response respuesta) {
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

    if (respuesta.statusCode == 401) {
      throw ApiException(
        _texto(cuerpoRespuesta['error']) ??
            'Tu sesion no es valida, inicia sesion de nuevo.',
        estado: respuesta.statusCode,
      );
    }

    throw ApiException(
      _texto(cuerpoRespuesta['error']) ??
          'La API respondio con el codigo ${respuesta.statusCode}.',
      estado: respuesta.statusCode,
    );
  }

  }

String? _texto(Object? valor) {
  if (valor == null) return null;
  final String texto = valor is String ? valor : valor.toString();
  return texto.trim().isEmpty ? null : texto;
}

int? _entero(Object? valor) {
  if (valor is int) return valor;
  if (valor is num) return valor.toInt();
  return int.tryParse(valor?.toString() ?? '');
}

double? _decimal(Object? valor) {
  if (valor is num) return valor.toDouble();
  return double.tryParse(valor?.toString() ?? '');
}
