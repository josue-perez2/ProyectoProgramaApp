import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../datos/api_cliente.dart';
import '../datos/opciones_menu.dart';
import '../datos/sesion_actual.dart';
import '../tema/tema_app.dart';
import '../widgets/marco_seccion.dart';
import '../widgets/rejilla_tarjetas.dart';
import '../widgets/tarjeta_recompensa.dart';

class PantallaRecompensas extends StatefulWidget {
  const PantallaRecompensas({super.key});

  @override
  State<PantallaRecompensas> createState() => _PantallaRecompensasState();
}

class _PantallaRecompensasState extends State<PantallaRecompensas> {
  bool _cargando = true;
  String? _error;
  CatalogoRecompensas? _catalogo;

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
      final CatalogoRecompensas catalogo = await ApiCliente.recompensas(token);
      if (!mounted) return;
      setState(() {
        _catalogo = catalogo;
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

  @override
  Widget build(BuildContext context) {
    final ResumenPuntos resumen = _catalogo?.resumen ??
        const ResumenPuntos(
          saldoPuntoCli: 0,
          totalCanjeables: 0,
          totalPendientes: 0,
        );
    final List<Recompensa> recompensas =
        _catalogo?.recompensas ?? const <Recompensa>[];

    return MarcoSeccion(
      opcion: opcionRecompensas,
      puntos: _catalogo?.resumen.saldoPuntoCli,
      cargando: _cargando,
      mensajeError: _error,
      mensajeVacio: 'Todavia no hay recompensas disponibles.',
      alReintentar: _cargar,
      children: <Widget>[
      
        const SizedBox(height: 20),
        RejillaTarjetas(
          tarjetas: <Widget>[
            for (int i = 0; i < recompensas.length; i++)
              FadeInUp(
                key: ValueKey<int>(recompensas[i].idRec),
                duration: const Duration(milliseconds: 600),
                delay: Duration(milliseconds: 120 + i * 80),
                child: _tarjeta(recompensas[i]),
              ),
          ],
        ),
      ],
    );
  }

  Widget _tarjeta(Recompensa recompensa) {
    return TarjetaRecompensa(
      nombre: recompensa.nombreRec,
      puntos: recompensa.puntosRequeridosRec,
      etiqueta: recompensa.etiquetaTipo,
      subtitulo: recompensa.canjeable
          ? 'Disponible para canjear'
          : 'Te faltan ${recompensa.puntosFaltantes} pts',
    );
  }

 

  Widget _pastilla({required IconData icono, required String texto}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colores.verdePrimario.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          Icon(icono, size: 18, color: Colores.verdeSecundario),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              texto,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
}