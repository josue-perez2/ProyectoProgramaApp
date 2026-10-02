class OpcionMenu {
  const OpcionMenu({
    required this.titulo,
    required this.imagenIcono,
    required this.imagenCard,
  });

  final String titulo;

  final String imagenIcono;

  final String imagenCard;
}

const List<OpcionMenu> opcionesMenu = <OpcionMenu>[
  OpcionMenu(
    titulo: 'Recompensas',
    imagenIcono: 'assets/recompensa.png',
    imagenCard: 'assets/recompensaD.png',
  ),
  OpcionMenu(
    titulo: 'Canje',
    imagenIcono: 'assets/canje.png',
    imagenCard: 'assets/canjeD.png',
  ),
  OpcionMenu(
    titulo: 'HistÃ³rico',
    imagenIcono: 'assets/historico.png',
    imagenCard: 'assets/historicoD.png',
  ),
  OpcionMenu(
    titulo: 'Perfil',
    imagenIcono: 'assets/perfil.png',
    imagenCard: 'assets/perfilD.png',
  ),
];
