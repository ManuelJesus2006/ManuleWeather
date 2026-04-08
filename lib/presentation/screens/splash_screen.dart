import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:manule_weather/models/tiempo_dias_response_model.dart';
import 'package:manule_weather/models/tiempo_horas_model.dart';
import 'package:manule_weather/models/tiempo_model.dart';
import 'package:manule_weather/providers/config_provider.dart';
import 'package:manule_weather/providers/weather_provider.dart';
import 'package:manule_weather/services/localizacion_service.dart';
import 'package:manule_weather/services/tiempo_service.dart';
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
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica si los servicios de ubicación están activados en el dispositivo
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Los servicios de ubicación están desactivados.');
      return;
    }

    // Verifica el estado actual de los permisos
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // Si están denegados, pide permiso al usuario
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('El usuario denegó los permisos.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // El usuario marcó no volver a preguntar, hay que enviarlo a ajustes
      print('Permisos denegados permanentemente.');
      return;
    }

    //Abrimos el configProvider
    final configProvider = Provider.of<ConfigProvider>(
        context,
        listen: false,
      );

    await configProvider.comprobarIdiomaYPrimeraVez();

    print(configProvider.primeraVez);

      //Quiero hacer el await aquí y que luego siga con lo demás
      if (configProvider.primeraVez) {
        await context.push('/onboarding');
      }

    // Tenemos permiso, ya podemos obtener la posición
    Position position = await Geolocator.getCurrentPosition();
    print("Latitud: ${position.latitude}, Longitud: ${position.longitude}");
    Tiempo? tiempoUbi = await TiempoService().getTiempoLatLon(
      position.latitude,
      position.longitude,
    );
    String? nombreCiudad = await LocalizacionService().getNombreCiudadByCords(
      position.longitude,
      position.latitude,
      configProvider.idiomaActual
    );
    TiempoHoras? tiempoHoras = await TiempoService().getTiempoPorHoras(
      position.latitude,
      position.longitude,
    );
    TiempoDias? tiempoDias = await TiempoService().getTiempoPorDias(
      position.latitude,
      position.longitude,
    );

    if (tiempoUbi != null && nombreCiudad != null && tiempoHoras != null && tiempoDias != null) {
      // Actualizamos el Provider AQUÍ, antes de cambiar de pantalla.
      // Usamos listen: false porque estamos dentro de una función, no pintando.
      final weatherProvider = Provider.of<WeatherProvider>(
        context,
        listen: false,
      );
      

      weatherProvider.cambiarDatos(
        tiempoUbi,
        nombreCiudad,
        tiempoHoras,
        tiempoDias!,
        true,
        position.latitude,
        position.longitude,
      );

      weatherProvider.comprobarNocheDia();
      weatherProvider.inicializarTiempoDias(configProvider.idiomaActual);
      DateTime horaActual = weatherProvider.ahoraCiudad;
      int elementosAEliminar = horaActual.hour;
      weatherProvider.eliminarHorasPasadas(elementosAEliminar);

      if (mounted) {
        context.go('/home');
      }
      //Usamos mounted para que no crashee la aplicación
    } else {
      if (mounted) context.go('/error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Image.asset('assets/images/LogoApp.png'),
            SizedBox(height: 8),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
