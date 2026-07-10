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
      //Obtenemos la posición del usuario
      Position position = await Geolocator.getCurrentPosition();
      print("Latitud: ${position.latitude}, Longitud: ${position.longitude}");
      //Buscamos en las preferences el idioma pues no podemos usar el provider
      final preferences = await SharedPreferences.getInstance();
      String idiomaActual = preferences.getString('lang')!;
      bool? fondoOscuro = preferences.getBool('modoOscuro');
      if (fondoOscuro == null) fondoOscuro = false;
    
      Tiempo? tiempoUbi = await TiempoService().getTiempoLatLon(
        position.latitude,
        position.longitude,
      );
      String? nombreCiudad = await LocalizacionService().getNombreCiudadByCords(
        position.longitude,
        position.latitude,
        idiomaActual,
      );
      TiempoHoras? tiempoHoras = await TiempoService().getTiempoPorHoras(
        position.latitude,
        position.longitude,
      );
      
      await HomeScreenWidgetManager.actualizarDatos(
        ciudad: nombreCiudad!,
        idioma: idiomaActual,
        fondoOscuro: fondoOscuro,
        tiempoActual: tiempoUbi!,
        rainData: Utils.getRainLevelData(null,tiempoHoras)
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
    frequency: const Duration(minutes: 15), // Mínimo permitido por Android: 15 min
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
          ChangeNotifierProvider(create: (_) => ConfigProvider())
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
      darkTheme: ThemeData.dark(),
      themeMode: configProvider.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}