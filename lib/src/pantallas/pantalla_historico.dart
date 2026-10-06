import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../datos/api_cliente.dart';
import '../datos/opciones_menu.dart';
import '../datos/sesion_actual.dart';
import '../tema/tema_app.dart';
import '../widgets/marco_seccion.dart';
import '../widgets/rejilla_tarjetas.dart';
import '../widgets/tarjeta_pedido.dart';
import '../widgets/vista_factura.dart';

class PantallaHistorico extends StatefulWidget {
  const PantallaHistorico({super.key});

  @override
  State<PantallaHistorico> createState() => _PantallaHistoricoState();
}

class _PantallaHistoricoState extends State<PantallaHistorico> {
  bool _cargando = true;
  String? _error;
  ListaPedidos? _pedidos;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    final String? token = SesionActual.sesion?.token;
    if (token == null) {
      setState(() {
        _cargando = false;
        _error = 'No hay una sesion activa, inicia sesion de nuevo.';
      });
      return;
    }

    try {
      final ListaPedidos pedidos = await ApiCliente.pedidos(token);
      if (!mounted) return;
      setState(() {
        _pedidos = pedidos;
        _cargando = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.mensaje;
        _cargando = false;
      });
    }
  }

  Future<void> _abrirFactura(Pedido pedido) async {
    final String? token = SesionActual.sesion?.token;
    if (token == null) return;

    try {
      final FacturaPedido factura = await ApiCliente.factura(token, pedido.idPed);
      if (!mounted) return;
      await VistaFactura.mostrar(context, factura);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(e.mensaje),
            backgroundColor: Colores.rojoError,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MarcoSeccion(
      opcion: opcionHistorico,
      puntos: _pedidos?.saldoPuntoCli,
      cargando: _cargando,
      mensajeError: _error,
      alReintentar: _cargar,
      children: <Widget>[
        _listaPedidos(),
      ],
    );
  }

  Widget _listaPedidos() {
    final List<Pedido> pedidos = _pedidos?.pedidos ?? const <Pedido>[];

    if (pedidos.isEmpty) {
      return _aviso(
        Icons.receipt_long_rounded,
        'Todavia no tienes pedidos registrados.\n'
        'Cuando realizes una compra aparecera aqui con su factura.',
      );
    }

    return RejillaTarjetas(
      tarjetasPorFila: 1,
      tarjetas: <Widget>[
        for (int i = 0; i < pedidos.length; i++)
          FadeInUp(
            key: ValueKey<int>(pedidos[i].idPed),
            duration: const Duration(milliseconds: 600),
            delay: Duration(milliseconds: 120 + i * 80),
              child: TarjetaPedido(
                correlativo: pedidos[i].correlativo,
                fechaPed: pedidos[i].fechaPed,
                totalPed: pedidos[i].totalPed,
                puntosObtenidosPed: pedidos[i].puntosObtenidosPed,
                metodoPago: pedidos[i].metodoPago,
                totalProductos: pedidos[i].totalProductos,
                alTocar: () => _abrirFactura(pedidos[i]),
              ),
          ),
      ],
    );
  }

  Widget _aviso(IconData icono, String mensaje) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 34),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colores.verdePrimario.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        children: <Widget>[
          Icon(icono, size: 40, color: Colores.verdeSecundario),
          const SizedBox(height: 14),
          Text(
            mensaje,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colores.textoTarjeta,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}