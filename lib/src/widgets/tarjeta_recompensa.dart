import 'package:flutter/material.dart';

import '../tema/tema_app.dart';

class TarjetaRecompensa extends StatelessWidget {
  const TarjetaRecompensa({
    super.key,
    required this.nombre,
    required this.puntos,
    this.imagen = imagenPorDefecto,
    this.etiqueta,
    this.subtitulo,
    this.alTocar,
  });

  static const String imagenPorDefecto = 'assets/recompensaCard.jpg';

  final String nombre;
  final int puntos;
  final String imagen;
  final String? etiqueta;
  final String? subtitulo;
  final VoidCallback? alTocar;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      elevation: 3,
      shadowColor: Colores.verdeProfundo.withValues(alpha: 0.22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: alTocar,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    imagen,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (etiqueta != null) ...[
                Text(
                  etiqueta!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colores.textoSecundario,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 4),
              ],
              Text(
                nombre,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colores.textoTarjeta,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              _pastillaPuntos(),
              if (subtitulo != null) ...[
                const SizedBox(height: 6),
                Text(
                  subtitulo!,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: puntos >= 0
                        ? Colores.verdeSecundario
                        : Colores.rojoError,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _pastillaPuntos() {
    final Color color = puntos >= 0 ? Colores.verdeBoton : Colores.rojoError;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.stars_rounded, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            '$puntos pts',
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}