import '../rutas.dart';

class OpcionMenu {
  const OpcionMenu({
    required this.titulo,
    required this.ruta,
    required this.imagenIcono,
    required this.imagenCard,
  });

  final String titulo;

  final String ruta;

  final String imagenIcono;

  final String imagenCard;
}

const OpcionMenu opcionRecompensas = OpcionMenu(
  titulo: 'Recompensas',
  ruta: Rutas.recompensas,
  imagenIcono: 'assets/recompensa.png',
  imagenCard: 'assets/recompensaD.png',
);

const OpcionMenu opcionCanje = OpcionMenu(
  titulo: 'Canje',
  ruta: Rutas.canje,
  imagenIcono: 'assets/canje.png',
  imagenCard: 'assets/canjeD.png',
);

const OpcionMenu opcionHistorico = OpcionMenu(
  titulo: 'Histórico',
  ruta: Rutas.historico,
  imagenIcono: 'assets/historico.png',
  imagenCard: 'assets/historicoD.png',
);

const OpcionMenu opcionPerfil = OpcionMenu(
  titulo: 'Perfil',
  ruta: Rutas.perfil,
  imagenIcono: 'assets/perfil.png',
  imagenCard: 'assets/perfilD.png',
);

const List<OpcionMenu> opcionesMenu = <OpcionMenu>[
  opcionRecompensas,
  opcionCanje,
  opcionHistorico,
  opcionPerfil,
];