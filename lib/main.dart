import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/datos/api_cliente.dart';
import 'src/datos/opciones_menu.dart';
import 'src/pantallas/pantalla_inicio.dart';
import 'src/pantallas/pantalla_login.dart';
import 'src/pantallas/pantalla_placeholder.dart';
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
  if (settings.name == Rutas.registro) {
    return MaterialPageRoute<String>(
      settings: settings,
      builder: (context) => const PantallaRegistro(),
    );
  }

  if (settings.name != Rutas.placeholder) return null;

  final OpcionMenu? opcion = settings.arguments as OpcionMenu?;

  return MaterialPageRoute<void>(
    settings: settings,
    builder: (context) => PantallaPlaceholder(opcion: opcion),
  );
}
