import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:manule_weather/models/tiempo_horas_model.dart';
import 'package:manule_weather/models/tiempo_model.dart';
import 'package:manule_weather/services/localizacion_service.dart';
import 'package:manule_weather/services/tiempo_service.dart';

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

    // Tenemos permiso, ya podemos obtener la posición
    Position position = await Geolocator.getCurrentPosition();
    print("Latitud: ${position.latitude}, Longitud: ${position.longitude}");
    Tiempo? tiempoUbi = await TiempoService().getTiempoLatLon(
      position.latitude,
      position.longitude,
    );
    String? nombreCiudad = await LocalizacionService().getNombreCiudadByCords(position.longitude, position.latitude);
    TiempoHoras? tiempoHoras = await TiempoService().getTiempoPorHoras(position.latitude, position.longitude);
    tiempoUbi != null ? context.pushReplacement('/home', extra: [tiempoUbi, nombreCiudad, tiempoHoras, true]) : context.push('/error');
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
