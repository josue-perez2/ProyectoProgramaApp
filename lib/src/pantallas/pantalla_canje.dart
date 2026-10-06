import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../datos/api_cliente.dart';
import '../datos/opciones_menu.dart';
import '../datos/sesion_actual.dart';
import '../tema/tema_app.dart';
import '../widgets/marco_seccion.dart';
import '../widgets/tarjeta_canje.dart';

class PantallaCanje extends StatefulWidget {
  const PantallaCanje({super.key});

  @override
  State<PantallaCanje> createState() => _PantallaCanjeState();
}

class _PantallaCanjeState extends State<PantallaCanje> {
  bool _cargando = true;
  String? _error;
  HistorialCanjes? _historial;

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
      final HistorialCanjes historial = await ApiCliente.historialCanjes(token);
      if (!mounted) return;
      setState(() {
        _historial = historial;
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

  List<CanjeRealizado> get _canjes =>
      _historial?.canjes ?? const <CanjeRealizado>[];

  @override
  Widget build(BuildContext context) {
    final List<CanjeRealizado> canjes = _canjes;

    return MarcoSeccion(
      opcion: opcionCanje,
      puntos: _historial?.saldoPuntoCli,
      cargando: _cargando,
      mensajeError: _error,
      mensajeVacio: 'Todavia no tienes canjes registrados.',
      alReintentar: _cargar,
      children: <Widget>[
        _seccion(
          'Historial de canjes',
          canjes.isEmpty ? null : '${canjes.length} recompensas canjeadas',
        ),
        const SizedBox(height: 14),
        if (canjes.isEmpty)
          _avisoVacio(
            Icons.redeem_rounded,
            'Todavia no has canjeado ninguna recompensa.',
          )
        else
          for (int i = 0; i < canjes.length; i++)
            FadeInUp(
              key: ValueKey<int>(canjes[i].idCan),
              duration: const Duration(milliseconds: 500),
              delay: Duration(milliseconds: 100 + i * 70),
              child: TarjetaCanje(
                nombre: canjes[i].nombreRec,
                puntos: canjes[i].puntosRecompensaCan,
                fecha: canjes[i].fechaCan,
                etiquetaTipo: canjes[i].etiquetaTipo,
              ),
            ),
      ],
    );
  }

  Widget _seccion(String titulo, String? subtitulo) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Text(
            titulo.toUpperCase(),
            style: const TextStyle(
              color: Colores.verdeSecundario,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ),
        if (subtitulo != null)
          Text(
            subtitulo,
            style: const TextStyle(
              color: Colores.textoSecundario,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _avisoVacio(IconData icono, String mensaje) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colores.verdePrimario.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        children: <Widget>[
          Icon(icono, size: 32, color: Colores.verdeSecundario),
          const SizedBox(height: 12),
          Text(
            mensaje,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colores.textoTarjeta,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
