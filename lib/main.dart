import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:manule_weather/environment.dart';
import 'package:manule_weather/models/tiempo_dias_response_model.dart';
import 'package:manule_weather/models/tiempo_horas_model.dart';
import 'package:manule_weather/models/tiempo_model.dart';
import 'package:manule_weather/presentation/screens/error_screen.dart';
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
// import 'package:manule_weather/widgets/home_widget/home_screen_widget_manager.dart'; // Tu Manager del Widget

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      //INICIALIZAR EL ENTORNO EN SEGUNDO PLANO
      WidgetsFlutterBinding.ensureInitialized();
      await NotificationService.init(pedirPermisos: false);

      final preferences = await SharedPreferences.getInstance();

      String idiomaActual =
          preferences.getString('lang') ??
          Platform.localeName.substring(0, Platform.localeName.length - 3);
      bool fondoOscuro = preferences.getBool('modoOscuro') ?? false;

      //COMPROBACIÓN DE SEGURIDAD (Evita el crasheo si no hay ubicación)
      double? latitud = preferences.getDouble('last_latitude');
      double? longitud = preferences.getDouble('last_longitude');

      if (latitud == null || longitud == null) {
        return Future.value(
          true,
        ); // Matamos la tarea sin error porque aún no hay datos
      }

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

      //
      if (tiempoUbi == null && tiempoHoras == null) {
        return Future.value(
          false,
        ); // Matamos la tarea con error porque ha fallado
      }

      switch (taskName) {
        case "actualizarTiempoActualWidgetNotificationTask":
          {
            await HomeScreenWidgetManager.actualizarDatos(
              ciudad: nombreCiudad!,
              idioma: idiomaActual,
              fondoOscuro: fondoOscuro,
              tiempoActual: tiempoUbi!,
              hayNieve: tiempoHoras!.weatherCode
                  .take(8)
                  .any((code) => Utils.isNevando(code)),
              rainData: Utils.getRainLevelData(null, tiempoHoras),
              snowData: Utils.getSnowLevelData(null, tiempoHoras),
            );

            //TODO: NOTIFICACIONES DE TIEMPO ACTUAL
            //Buscamos la temperatura maxima e minima en el tiempoHoras para no tener que hacer otra petición
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
          }
          break;
        case "actualizarUpdatesAlertsNotificationsTask":
          {
            // Notificacion nueva version
            final responseAppVersion = await get(
              Uri.parse(Environment.url_version),
            );

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

            //TODO: NOTIFICACIONES DE ALERTAS
            await Utils.devolverNotificacionesAvisos(
              idiomaActual,
              tiempoHoras!,
            );
          }
          break;
      }

      return Future.value(true);
    } catch (e) {
      print("Error en Workmanager: $e");
      return Future.value(
        false,
      ); // Devuelve false para que Android intente repetirlo más tarde
    }
  });
}

void main() async {
  // Asegura que los bindings estén listos (lo movemos arriba del todo para Workmanager)
  WidgetsFlutterBinding.ensureInitialized();

  // 🕒 3. Inicializamos Workmanager y programamos la tarea cada hora
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false, // Ponlo en false cuando subas la app a producción
  );

  //Bucle de tiempo actual para el widget y la notificacion
  await Workmanager().registerPeriodicTask(
    "bucle_tiempoActual_widget_notification",
    "actualizarTiempoActualWidgetNotificationTask",
    frequency: const Duration(
      minutes: 15,
    ), // Mínimo permitido por Android: 15 min
    constraints: Constraints(
      networkType: NetworkType.connected, // Solo con internet
    ),
  );

  //Bucle de notificaciones variadas (actualizaciones, alertas entre otros...)
  await Workmanager().registerPeriodicTask(
    "bucle_otherNotifications",
    "actualizarUpdatesAlertsNotificationsTask",
    frequency: const Duration(hours: 1),
    constraints: Constraints(
      networkType: NetworkType.connected, // Solo con internet
    ),
  );

  //Para pruebas
  /*await Workmanager().registerOneOffTask(
    "tarea_prueba_rapida", // Un nombre cualquiera
    "actualizarTiempoActualWidgetNotificationTask", // El mismo nombre que espera tu callbackDispatcher
    initialDelay: const Duration(seconds: 10), // ¡Arranca en 10 segundos!
  );*/

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
