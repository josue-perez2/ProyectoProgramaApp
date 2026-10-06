import 'package:flutter/material.dart';

import '../datos/formato.dart';
import '../tema/tema_app.dart';

class TarjetaPedido extends StatelessWidget {
  const TarjetaPedido({
    super.key,
    required this.correlativo,
    required this.fechaPed,
    required this.totalPed,
    required this.puntosObtenidosPed,
    required this.metodoPago,
    required this.totalProductos,
    required this.alTocar,
  });

  final String correlativo;
  final DateTime? fechaPed;
  final double totalPed;
  final int puntosObtenidosPed;
  final String metodoPago;
  final int totalProductos;
  final VoidCallback alTocar;

  @override
  Widget build(BuildContext context) {
    final ColorPago colorPago = Formato.colorPago(metodoPago);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 3,
      shadowColor: Colores.verdeProfundo.withValues(alpha: 0.20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: alTocar,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colores.verdePrimario.withValues(alpha: 0.22),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colores.verdePrimario.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      correlativo.isEmpty ? 'PEDIDO' : correlativo,
                      style: const TextStyle(
                        color: Colores.verdeBoton,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colores.verdeSecundario,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                Formato.fechaHora(fechaPed),
                style: const TextStyle(
                  color: Colores.textoTarjeta,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _horaConSegundos(),
                style: const TextStyle(
                  color: Colores.textoSecundario,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Container(height: 1, color: const Color(0xFFE6EFEB)),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _dato(
                      icono: colorPago.icono,
                      color: colorPago.color,
                      etiqueta: 'Pago',
                      valor: metodoPago,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _dato(
                      icono: Icons.shopping_bag_rounded,
                      color: Colores.verdeSecundario,
                      etiqueta: 'Articulos',
                      valor: '$totalProductos',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'TOTAL',
                          style: TextStyle(
                            color: Colores.textoSecundario,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          Formato.dinero(totalPed),
                          style: const TextStyle(
                            color: Colores.textoTarjeta,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colores.verdeSecundario.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '+$puntosObtenidosPed pts',
                      style: const TextStyle(
                        color: Colores.verdeBoton,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _horaConSegundos() {
    if (fechaPed == null) return 'Sin hora';
    return 'Hora: ${Formato.dos(fechaPed!.hour)}:'
        '${Formato.dos(fechaPed!.minute)}:'
        '${Formato.dos(fechaPed!.second)}';
  }

  Widget _dato({
    required IconData icono,
    required Color color,
    required String etiqueta,
    required String valor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          Icon(icono, size: 15, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  etiqueta,
                  style: const TextStyle(
                    color: Colores.textoSecundario,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  valor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}