import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manule_weather/routes/app_routes.dart';

void main() {
  // Asegura que los bindings estén listos
  WidgetsFlutterBinding.ensureInitialized();

  // Bloquea la orientación a vertical hacia arriba y hacia abajo
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MainApp());
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.hedvigLettersSansTextTheme()
      ),
      routerConfig: appRouter,
    );
  }
}
