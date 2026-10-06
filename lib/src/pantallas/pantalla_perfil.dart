import 'package:flutter/material.dart';

import '../datos/api_cliente.dart';
import '../datos/formato.dart';
import '../datos/opciones_menu.dart';
import '../datos/sesion_actual.dart';
import '../tema/tema_app.dart';
import '../widgets/marco_seccion.dart';

class PantallaPerfil extends StatefulWidget {
  const PantallaPerfil({super.key});

  @override
  State<PantallaPerfil> createState() => _PantallaPerfilState();
}

class _PantallaPerfilState extends State<PantallaPerfil> {
  bool _cargando = true;
  String? _error;
  PerfilCliente? _perfil;

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
      final PerfilCliente perfil = await ApiCliente.perfil(token);
      if (!mounted) return;
      setState(() {
        _perfil = perfil;
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
    final PerfilCliente? perfil = _perfil;
    final double? puntos = perfil?.saldoPuntoCli ?? SesionActual.sesion?.saldoPuntoCli;

    return MarcoSeccion(
      opcion: opcionPerfil,
      puntos: puntos,
      cargando: _cargando,
      mensajeError: _error,
      alReintentar: _cargar,
      children: <Widget>[
        _titulo('Mis datos'),
        const SizedBox(height: 12),
        _dato(Icons.badge_outlined, 'Nombre', perfil?.nombreCli ?? '', obligatory: true),
        _dato(Icons.numbers_rounded, 'DPI', perfil?.dpiCli ?? ''),
        _dato(Icons.mail_outline_rounded, 'Correo', perfil?.correoCli ?? '', obligatory: true),
        _dato(Icons.phone_rounded, 'Telefono', perfil?.telefonoCli ?? ''),
        _dato(Icons.home_rounded, 'Direccion', perfil?.direccionCli ?? ''),
        const SizedBox(height: 6),
        _titulo('Mi programa de puntos'),
        const SizedBox(height: 12),
        _filaResumen(
          icono: Icons.stars_rounded,
          etiqueta: 'Puntos acumulados',
          valor: '${Formato.puntos(puntos)} pts',
        ),
        _filaResumen(
          icono: Icons.receipt_long_rounded,
          etiqueta: 'Pedidos realizados',
          valor: '${perfil?.totalPedidos ?? 0}',
        ),
      ],
    );
  }

  Widget _titulo(String texto) {
    return Text(
      texto.toUpperCase(),
      style: const TextStyle(
        color: Colores.verdeSecundario,
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _dato(
    IconData icono,
    String etiqueta,
    String valor, {
    bool obligatory = false,
  }) {
    final bool vacio = valor.isEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colores.verdePrimario.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: <Widget>[
          Icon(icono, size: 22, color: Colores.verdeSecundario),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  etiqueta,
                  style: const TextStyle(
                    color: Colores.textoSecundario,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  vacio
                      ? (obligatory ? 'No registrado' : 'No tiene registrado')
                      : valor,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: vacio
                        ? Colores.textoSecundario.withValues(alpha: 0.7)
                        : Colores.textoTarjeta,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontStyle: vacio ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filaResumen({
    required IconData icono,
    required String etiqueta,
    required String valor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colores.verdePrimario.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: <Widget>[
          Icon(icono, size: 22, color: Colores.verdeSecundario),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              etiqueta,
              style: const TextStyle(
                color: Colores.textoSecundario,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            valor,
            style: const TextStyle(
              color: Colores.textoTarjeta,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}