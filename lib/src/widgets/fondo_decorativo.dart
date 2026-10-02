import 'package:flutter/material.dart';

import 'onda_superior.dart';
import 'resplandor_verde.dart';

class FondoDecorativo extends StatelessWidget {
  const FondoDecorativo({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(top: 0, left: 0, right: 0, child: OndaSuperior()),
        const Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ResplandorVerde(),
        ),
        const Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: OndaInferior(),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}
