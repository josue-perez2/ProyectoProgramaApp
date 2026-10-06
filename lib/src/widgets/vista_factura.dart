import 'package:flutter/material.dart';

import '../datos/api_cliente.dart';
import '../datos/formato.dart';
import '../tema/tema_app.dart';

class VistaFactura extends StatelessWidget {
  const VistaFactura({super.key, required this.factura});

  final FacturaPedido factura;

  static Future<void> mostrar(BuildContext context, FacturaPedido factura) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => VistaFactura(factura: factura),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Pedido pedido = factura.pedido;
    final PagoFactura pago = factura.pago;
    final ColorPago colorPago = Formato.colorPago(pago.metodoPago);
    final int puntosDetalle = factura.puntosGenerados;

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (BuildContext contexto, ScrollController controlador) {
        return Container(
          decoration: const BoxDecoration(
            color: Colores.fondoAlto,
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 12),
              Container(
                width: 46,
                height: 5,
                decoration: BoxDecoration(
                  color: Colores.verdePrimario.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 14),
              _encabezado(pedido),
              Expanded(
                child: SingleChildScrollView(
                  controller: controlador,
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _cliente(),
                      const SizedBox(height: 16),
                      _productos(),
                      const SizedBox(height: 16),
                      _punto(pedido, puntosDetalle),
                      const SizedBox(height: 16),
                      _pago(pago, colorPago),
                      const SizedBox(height: 16),
                      _totales(pedido, pago),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _encabezado(Pedido pedido) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: const BoxDecoration(
        color: Colores.verdePrimario,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: Column(
        children: <Widget>[
          const Text(
            'COMPROBANTE DE PAGO',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'FACTURA ELECTRONICA',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'No. ${pedido.correlativo.isEmpty ? 'FAC-000000' : pedido.correlativo}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            Formato.fechaHoraSegundos(pedido.fechaPed),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              pedido.estadoPedDescripcion,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cliente() {
    return _bloque(
      titulo: 'Cliente',
      child: Column(
        children: <Widget>[
          _filaTexto('NOMBRE', factura.nombreCli),
          _filaTexto('DPI', factura.dpiCli),
        ],
      ),
    );
  }

  Widget _productos() {
    final List<ProductoFactura> productos = factura.productos;

    return _bloque(
      titulo: 'Productos del pedido',
      child: Column(
        children: <Widget>[
          for (int i = 0; i < productos.length; i++) ...<Widget>[
            if (i > 0)
              Divider(height: 18, color: Colores.verdePrimario.withValues(alpha: 0.12)),
            _filaProducto(productos[i]),
          ],
        ],
      ),
    );
  }

  Widget _filaProducto(ProductoFactura producto) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colores.verdePrimario.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            producto.cantidadDet.toStringAsFixed(0),
            style: const TextStyle(
              color: Colores.verdeBoton,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                producto.nombreItemDet,
                style: const TextStyle(
                  color: Colores.textoTarjeta,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${producto.tipoDescripcion} - ${Formato.dinero(producto.precioUnitarioDet)} c/u',
                style: const TextStyle(
                  color: Colores.textoSecundario,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (producto.puntosGeneradosDet > 0) ...<Widget>[
                const SizedBox(height: 4),
                Text(
                  '+${producto.puntosGeneradosDet} pts',
                  style: const TextStyle(
                    color: Colores.verdeSecundario,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          Formato.dinero(producto.subtotalDet),
          style: const TextStyle(
            color: Colores.textoTarjeta,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _punto(Pedido pedido, int puntosDetalle) {
    final int puntos = pedido.puntosObtenidosPed;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colores.verdeSecundario.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colores.verdeSecundario.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.stars_rounded, size: 22, color: Colores.verdeSecundario),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Puntos obtenidos',
                  style: const TextStyle(
                    color: Colores.textoSecundario,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '+$puntos pts',
                style: const TextStyle(
                  color: Colores.verdeBoton,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          if (puntosDetalle != puntos) ...<Widget>[
            const SizedBox(height: 6),
            Row(
              children: <Widget>[
                const SizedBox(width: 32),
                Text(
                  'Suma del detalle: +$puntosDetalle pts',
                  style: const TextStyle(
                    color: Colores.textoSecundario,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 10),
          Container(height: 1, color: Colores.verdeSecundario.withValues(alpha: 0.20)),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  'Saldo acumulado actual',
                  style: TextStyle(
                    color: Colores.textoSecundario,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${Formato.puntos(factura.saldoPuntoCli)} pts',
                style: const TextStyle(
                  color: Colores.textoTarjeta,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pago(PagoFactura pago, ColorPago colorPago) {
    return _bloque(
      titulo: 'Forma de pago',
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorPago.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(colorPago.icono, size: 24, color: colorPago.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      pago.metodoPago,
                      style: TextStyle(
                        color: colorPago.color,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      pago.tienePago
                          ? 'Fecha: ${Formato.fechaHora(pago.fechaPag)}'
                          : 'Este pedido todavia no tiene pago registrado',
                      style: const TextStyle(
                        color: Colores.textoSecundario,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (pago.esEfectivo) ...<Widget>[
            const SizedBox(height: 12),
            _filaMonto('Efectivo recibido', pago.montoRecibidoPag),
            _filaMonto('Cambio', pago.cambioPag),
          ],
          if (pago.numeroReferenciaPag != null &&
              pago.numeroReferenciaPag!.isNotEmpty) ...<Widget>[
            const SizedBox(height: 12),
            _filaTexto('No. referencia', pago.numeroReferenciaPag!),
          ],
        ],
      ),
    );
  }

  Widget _totales(Pedido pedido, PagoFactura pago) {
    return _bloque(
      titulo: 'Totales',
      child: Column(
        children: <Widget>[
          _filaMonto('Subtotal', pedido.totalPed),
          _filaMonto('Descuento', 0),
          const Divider(height: 20, color: Color(0xFFE6EFEB)),
          Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  'TOTAL A PAGAR',
                  style: TextStyle(
                    color: Colores.textoTarjeta,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                Formato.dinero(pedido.totalPed),
                style: const TextStyle(
                  color: Colores.verdeBoton,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          if (pago.esEfectivo) ...<Widget>[
            const SizedBox(height: 6),
            Row(
              children: <Widget>[
                const Expanded(
                  child: Text(
                    'Pagado en efectivo',
                    style: TextStyle(
                      color: Colores.textoSecundario,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  Formato.dinero(pago.montoRecibidoPag),
                  style: const TextStyle(
                    color: Colores.textoSecundario,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _bloque({required String titulo, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colores.verdePrimario.withValues(alpha: 0.22),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            titulo.toUpperCase(),
            style: const TextStyle(
              color: Colores.verdeSecundario,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _filaTexto(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 118,
            child: Text(
              etiqueta,
              style: const TextStyle(
                color: Colores.textoSecundario,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              valor.isEmpty ? 'CF' : valor,
              style: const TextStyle(
                color: Colores.textoTarjeta,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filaMonto(String etiqueta, double valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              etiqueta,
              style: const TextStyle(
                color: Colores.textoSecundario,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            Formato.dinero(valor),
            style: const TextStyle(
              color: Colores.textoTarjeta,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}