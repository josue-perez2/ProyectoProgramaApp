import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../datos/opciones_menu.dart';
import '../tema/tema_app.dart';

class MenuFlotante extends StatelessWidget {
  const MenuFlotante({super.key, required this.alSeleccionar});

  final ValueChanged<OpcionMenu> alSeleccionar;

  @override
  Widget build(BuildContext context) {
    return ElasticInUp(
      duration: const Duration(milliseconds: 900),
      delay: const Duration(milliseconds: 250),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colores.verdePrimario.withValues(alpha: 0.38),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colores.verdeProfundo.withValues(alpha: 0.18),
                  blurRadius: 26,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var i = 0; i < opcionesMenu.length; i++)
                  Expanded(
                    child: BounceInUp(
                      key: ValueKey(opcionesMenu[i].titulo),
                      duration: const Duration(milliseconds: 600),
                      delay: Duration(milliseconds: 400 + i * 90),
                      child: _BotonMenu(
                        opcion: opcionesMenu[i],
                        alTocar: () => alSeleccionar(opcionesMenu[i]),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BotonMenu extends StatelessWidget {
  const _BotonMenu({required this.opcion, required this.alTocar});

  final OpcionMenu opcion;
  final VoidCallback alTocar;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: alTocar,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Semantics(
            button: true,
            label: opcion.titulo,
            child: Image.asset(
              opcion.imagenIcono,
              width: 34,
              height: 34,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
