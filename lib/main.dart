import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:manule_weather/environment.dart';
import 'package:manule_weather/models/tiempo_horas_model.dart';
import 'package:manule_weather/models/tiempo_model.dart';
import 'package:manule_weather/presentation/widgets/home_widget/home_screen_widget_manager.dart';
import 'package:manule_weather/providers/config_provider.dart';
import 'package:manule_weather/providers/navigation_provider.dart';
import 'package:manule_weather/providers/weather_provider.dart';
import 'package:manule_weather/services/localizacion_service.dart';
import 'package:manule_weather/services/notification_service.dart';
import 'package:manule_weather/services/tiempo_service.dart';
import 'package:manule_weather/utils/Utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:manule_weather/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

// Cascada de ubicación para background
Future<Position?> _obtenerUbicacionBackground(SharedPreferences prefs) async {
  try {
    final permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever) {
      
      // 1. Intentar GPS en vivo rápido
      try {
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          timeLimit: const Duration(seconds: 8),
        );
        await prefs.setDouble('last_latitude', pos.latitude);
        await prefs.setDouble('last_longitude', pos.longitude);
        return pos;
      } on TimeoutException catch (_) {}

      // 2. Fallback: última posición conocida por el sistema
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        await prefs.setDouble('last_latitude', lastKnown.latitude);
        await prefs.setDouble('last_longitude', lastKnown.longitude);
        return lastKnown;
      }
    }
  } catch (_) {}

  // 3. Fallback: SharedPreferences guardadas previamente
  final lat = prefs.getDouble('last_latitude');
  final lon = prefs.getDouble('last_longitude');

  if (lat != null && lon != null) {
    return Position(
      latitude: lat,
      longitude: lon,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
  }

  return null;
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      // INICIALIZAR EL ENTORNO EN SEGUNDO PLANO
      WidgetsFlutterBinding.ensureInitialized();
      await NotificationService.init(pedirPermisos: false);

      final preferences = await SharedPreferences.getInstance();

      String idiomaActual =
          preferences.getString('lang') ??
          Platform.localeName.substring(0, Platform.localeName.length - 3);
      bool fondoOscuro = preferences.getBool('modoOscuro') ?? false;

      // RESOLUCIÓN DE UBICACIÓN POR CASCADA
      final posicion = await _obtenerUbicacionBackground(preferences);
      if (posicion == null) {
        return Future.value(true); // Sin ubicación disponible, salimos sin error
      }

      final double latitud = posicion.latitude;
      final double longitud = posicion.longitude;

      final resultadosPeticion = await Future.wait([
        TiempoService().getTiempoLatLon(latitud, longitud),
        LocalizacionService().getNombreCiudadByCords(
          longitud,
          latitud,
          idiomaActual,
        ),
        TiempoService().getTiempoPorHoras(latitud, longitud),
      ]);

      Tiempo? tiempoUbi = resultadosPeticion[0] as Tiempo?;
      String? nombreCiudad = resultadosPeticion[1] as String?;
      TiempoHoras? tiempoHoras = resultadosPeticion[2] as TiempoHoras?;
      printHelloSonny(); // ;)

      // Comprobación de nulos en la petición
      if (tiempoUbi == null && tiempoHoras == null) {
        return Future.value(false); // Reintenta más tarde
      }

      await HomeScreenWidgetManager.actualizarDatos(
        ciudad: nombreCiudad!,
        idioma: idiomaActual,
        fondoOscuro: fondoOscuro,
        tiempoActual: tiempoUbi!,
        rainData: Utils.getRainLevelData(null, tiempoHoras),
        snowData: Utils.getSnowLevelData(null, tiempoHoras),
        tiempoHoras: tiempoHoras!,
      );

      // NOTIFICACIONES DE TIEMPO ACTUAL
      int tempMax = tiempoHoras.temperature2M
          .sublist(0, 24)
          .reduce(max)
          .round();
      int tempMin = tiempoHoras.temperature2M
          .sublist(0, 24)
          .reduce(min)
          .round();
      Utils.mandarNotificacionTiempoActual(
        tempMax,
        tempMin,
        tiempoUbi,
        nombreCiudad,
        idiomaActual,
      );

      // Notificación nueva versión
      final responseAppVersion = await get(Uri.parse(Environment.url_version));

      if (responseAppVersion.statusCode == 200) {
        final data = jsonDecode(responseAppVersion.body);
        final versionServer = data['version'];
        final whatisnew = data['whatisnew'];

        final info = await PackageInfo.fromPlatform();
        final versionActual = info.version;

        if (versionServer != versionActual) {
          await NotificationService.mostrarNotificacion(
            titulo: Utils.stringNewUpdate(idiomaActual, versionServer),
            cuerpo: whatisnew,
            id: 0,
          );
        }
      }

      // NOTIFICACIONES DE ALERTAS
      await Utils.devolverNotificacionesAvisos(idiomaActual, tiempoHoras);

      // NOTIFICACIÓN SUPER LUNA LLENA
      double faseLunarActual = Utils.calcularFaseLunarByFecha(
        DateTime.parse(tiempoUbi.current.time),
      );
      double faseOrbitaLunarActual = Utils.obtenerPosicionOrbitaLunarByFecha(
        DateTime.parse(tiempoUbi.current.time),
      );
      if ((faseLunarActual >= 0.485 && faseLunarActual <= 0.515) &&
          (faseOrbitaLunarActual <= 0.05 || faseOrbitaLunarActual >= 0.95) &&
          tiempoUbi.current.weatherCode < 3) {
        await NotificationService.mostrarNotificacion(
          titulo: Utils.stringSuperFullMoonAdvisory(idiomaActual),
          cuerpo: Utils.stringSuperFullMoonDetailNotification(idiomaActual),
          id: 21,
        );
      }

      return Future.value(true);
    } catch (e) {
      print("Error en Workmanager: $e");
      return Future.value(false);
    }
  });
}

void printHelloSonny() {
  print('Hola Sonny :)');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );

  await Workmanager().registerPeriodicTask(
    "bucle_tiempoActual_widget_notification",
    "actualizarWidgetAndNotificationTask",
    frequency: const Duration(minutes: 15),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );

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