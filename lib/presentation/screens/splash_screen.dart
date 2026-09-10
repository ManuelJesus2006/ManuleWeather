import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:manule_weather/models/tiempo_dias_response_model.dart';
import 'package:manule_weather/models/tiempo_horas_model.dart';
import 'package:manule_weather/models/tiempo_model.dart';
import 'package:manule_weather/presentation/widgets/home_widget/home_screen_widget_manager.dart';
import 'package:manule_weather/providers/config_provider.dart';
import 'package:manule_weather/providers/weather_provider.dart';
import 'package:manule_weather/services/localizacion_service.dart';
import 'package:manule_weather/services/tiempo_service.dart';
import 'package:manule_weather/services/version_service.dart';
import 'package:manule_weather/utils/Utils.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _getLocalizacionActual();
  }

  _getLocalizacionActual() async {
    //Abrimos el configProvider
    final configProvider = Provider.of<ConfigProvider>(context, listen: false);

    await configProvider.comprobarIdiomaYPrimeraVez();

    await configProvider.comprobarModoOscuro();

    await configProvider.cargarHistorialBusqueda();

    //Antes de hacer toda la logica principal avisamos al usuario en el caso de que haya actualizacion
    await VersionService().comprobarActualizacion(
      configProvider.idiomaActual,
      context,
    );

    configProvider.cambiarValorLineaDeCarga(12.5);

    bool serviceEnabled;
    LocationPermission permission;

    // Verifica si los servicios de ubicación están activados en el dispositivo
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Los servicios de ubicación están desactivados.');
      if (mounted)
        context.go(
          '/error',
          extra: Utils.stringErrorServerDown(configProvider.idiomaActual),
        );
      return;
    }

    // Verifica el estado actual de los permisos
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // Si están denegados, pide permiso al usuario
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('El usuario denegó los permisos.');
        if (mounted)
          context.go(
            '/error',
            extra: Utils.stringErrorServerDown(configProvider.idiomaActual),
          );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // El usuario marcó no volver a preguntar, hay que enviarlo a ajustes
      print('Permisos denegados permanentemente.');
      if (mounted)
        context.go(
          '/error',
          extra: Utils.stringErrorServerDown(configProvider.idiomaActual),
        );
      return;
    }
    configProvider.cambiarValorLineaDeCarga(25);

    print(configProvider.primeraVez);

    //Quiero hacer el await aquí y que luego siga con lo demás
    if (configProvider.primeraVez) {
      await context.push('/onboarding');
    }

    // Tenemos permiso, ya podemos obtener la posición
    Position position = await Geolocator.getCurrentPosition();
    print("Latitud: ${position.latitude}, Longitud: ${position.longitude}");
    try {
      Tiempo? tiempoUbi = await TiempoService()
          .getTiempoLatLon(position.latitude, position.longitude)
          .timeout(const Duration(seconds: 10));

      configProvider.cambiarValorLineaDeCarga(37.5);
      String? nombreCiudad = await LocalizacionService()
          .getNombreCiudadByCords(
            position.longitude,
            position.latitude,
            configProvider.idiomaActual,
          )
          .timeout(const Duration(seconds: 10));

      configProvider.cambiarValorLineaDeCarga(50);
      TiempoHoras? tiempoHoras = await TiempoService()
          .getTiempoPorHoras(position.latitude, position.longitude)
          .timeout(const Duration(seconds: 10));

      configProvider.cambiarValorLineaDeCarga(62.5);
      TiempoDias? tiempoDias = await TiempoService()
          .getTiempoPorDias(position.latitude, position.longitude)
          .timeout(const Duration(seconds: 10));
      configProvider.cambiarValorLineaDeCarga(75);
      // Actualizamos el Provider AQUÍ, antes de cambiar de pantalla.
      // Usamos listen: false porque estamos dentro de una función, no pintando.
      final weatherProvider = Provider.of<WeatherProvider>(
        context,
        listen: false,
      );

      weatherProvider.cambiarDatos(
        tiempoUbi!,
        nombreCiudad!,
        tiempoHoras!,
        tiempoDias!,
        true,
        position.latitude,
        position.longitude,
      );
      configProvider.cambiarValorLineaDeCarga(87.5);

      //Cambiamos los datos en el widget
      HomeScreenWidgetManager.actualizarDatos(
        ciudad: nombreCiudad,
        idioma: configProvider.idiomaActual,
        fondoOscuro: configProvider.isDarkTheme,
        tiempoActual: weatherProvider.tiempoActual!,
        hayNieve: weatherProvider.tiempoHoras!.weatherCode
            .take(8)
            .any((code) => Utils.isNevando(code)),
        rainData: Utils.getRainLevelData(weatherProvider, null),
        snowData: Utils.getSnowLevelData(weatherProvider, null),
      );

      weatherProvider.comprobarNocheDia();
      weatherProvider.inicializarTiempoDias(configProvider.idiomaActual);
      int elementosAEliminar = weatherProvider.ahoraCiudad.hour;
      weatherProvider.eliminarHorasPasadas(elementosAEliminar);
      weatherProvider.cambiarFaseLunar();
      configProvider.cambiarValorLineaDeCarga(100);

      if (mounted) {
        context.go('/home');
      }
    } on TimeoutException {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Utils.stringErrorTimeout(configProvider.idiomaActual)),
        ),
      );
    } catch (e) {
      if (mounted && e is HttpException) {
        context.go(
          '/error',
          extra: Utils.stringErrorServerDown(configProvider.idiomaActual),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Utils.stringErrorApp(configProvider.idiomaActual)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo con tamaño controlado para que no desentone
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Image.asset('assets/images/LogoApp.png'),
                ),
                const SizedBox(height: 40),

                //Linea de carga
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 8,
                    child: LinearProgressIndicator(
                      value: configProvider.valorLineaDeCarga / 100,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Utils.dynamicStringSplashScreen(
                        configProvider.idiomaActual,
                        configProvider.valorLineaDeCarga,
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
