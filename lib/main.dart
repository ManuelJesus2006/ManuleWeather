import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manule_weather/models/tiempo_horas_model.dart';
import 'package:manule_weather/models/tiempo_model.dart';
import 'package:manule_weather/presentation/screens/error_screen.dart';
import 'package:manule_weather/presentation/widgets/home_widget/home_screen_widget_manager.dart';
import 'package:manule_weather/providers/config_provider.dart';
import 'package:manule_weather/providers/navigation_provider.dart';
import 'package:manule_weather/providers/weather_provider.dart';
import 'package:manule_weather/services/localizacion_service.dart';
import 'package:manule_weather/services/tiempo_service.dart';
import 'package:manule_weather/utils/Utils.dart';
import 'package:provider/provider.dart';
import 'package:manule_weather/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
// import 'package:manule_weather/widgets/home_widget/home_screen_widget_manager.dart'; // Tu Manager del Widget

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      //Buscamos en las preferences el idioma pues no podemos usar el provider
      final preferences = await SharedPreferences.getInstance();
      String idiomaActual =
          preferences.getString('lang') ??
          Platform.localeName.substring(0, Platform.localeName.length - 3);
      bool? fondoOscuro = preferences.getBool('modoOscuro') ?? false;
      //Obtenemos la posición del usuario
      double latitud = preferences.getDouble('last_latitude')!;
      double longitud = preferences.getDouble('last_longitude')!;

      final resultadosPeticion = await Future.wait([
        TiempoService().getTiempoLatLon(latitud, longitud),
        LocalizacionService().getNombreCiudadByCords(
          longitud,
          latitud,
          idiomaActual,
        ),
        TiempoService().getTiempoPorHoras(longitud, latitud),
      ]);
      Tiempo? tiempoUbi = resultadosPeticion[0] as Tiempo;
      String? nombreCiudad = resultadosPeticion[1] as String;
      TiempoHoras? tiempoHoras = resultadosPeticion[2] as TiempoHoras;

      await HomeScreenWidgetManager.actualizarDatos(
        ciudad: nombreCiudad,
        idioma: idiomaActual,
        fondoOscuro: fondoOscuro,
        tiempoActual: tiempoUbi,
        hayNieve: tiempoHoras.weatherCode
            .take(8)
            .any((code) => Utils.isNevando(code)),
        rainData: Utils.getRainLevelData(null, tiempoHoras),
        snowData: Utils.getSnowLevelData(null, tiempoHoras),
      );

      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  });
}

void main() async {
  // Asegura que los bindings estén listos (lo movemos arriba del todo para Workmanager)
  WidgetsFlutterBinding.ensureInitialized();

  // 🕒 3. Inicializamos Workmanager y programamos la tarea cada hora
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true, // Ponlo en false cuando subas la app a producción
  );

  await Workmanager().registerPeriodicTask(
    "bucle_clima_widget",
    "actualizarClimaWidgetTask",
    frequency: const Duration(
      minutes: 30,
    ), // Mínimo permitido por Android: 15 min
    constraints: Constraints(
      networkType: NetworkType.connected, // Solo con internet
    ),
  );

  // Bloquea la orientación a vertical hacia arriba y hacia abajo
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => WeatherProvider()),
          ChangeNotifierProvider(create: (_) => NavigationProvider()),
          ChangeNotifierProvider(create: (_) => ConfigProvider()),
        ],
        child: const MainApp(),
      ),
    );
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.hedvigLettersSansTextTheme()),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.hedvigLettersSansTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      themeMode: configProvider.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}
