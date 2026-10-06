import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/datos/api_cliente.dart';
import 'src/pantallas/pantalla_canje.dart';
import 'src/pantallas/pantalla_historico.dart';
import 'src/pantallas/pantalla_inicio.dart';
import 'src/pantallas/pantalla_login.dart';
import 'src/pantallas/pantalla_perfil.dart';
import 'src/pantallas/pantalla_recompensas.dart';
import 'src/pantallas/pantalla_registro.dart';
import 'src/rutas.dart';
import 'src/tema/tema_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(const <DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);
  runApp(const ProgramaApp());
}

class ProgramaApp extends StatelessWidget {
  const ProgramaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Programa Pan',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.claro,
      initialRoute: Rutas.login,
      routes: <String, WidgetBuilder>{
        Rutas.login: (_) => const PantallaLogin(),
        Rutas.inicio: (context) => PantallaInicio(
          sesion: ModalRoute.of(context)?.settings.arguments as Sesion?,
        ),
      },
      onGenerateRoute: _generarRuta,
    );
  }
}

Route<Object?>? _generarRuta(RouteSettings settings) {
  switch (settings.name) {
    case Rutas.registro:
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => const PantallaRegistro(),
      );
    case Rutas.recompensas:
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => const PantallaRecompensas(),
      );
    case Rutas.canje:
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => const PantallaCanje(),
      );
    case Rutas.historico:
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => const PantallaHistorico(),
      );
    case Rutas.perfil:
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => const PantallaPerfil(),
      );
  }

  return null;
}