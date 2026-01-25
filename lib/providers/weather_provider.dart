import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:manule_weather/models/tiempo_horas_model.dart';
import 'package:manule_weather/models/tiempo_model.dart';
import 'package:manule_weather/services/localizacion_service.dart';
import 'package:manule_weather/services/tiempo_service.dart';

class WeatherProvider with ChangeNotifier{
  Tiempo? tiempoActual;
  String? localizacion;
  TiempoHoras? tiempoHoras;
  bool? isUbicacionUser;
  String nombreUbi = '';
  double tempUbi = 0;
  String estadoUbi = '';
  Position? ubiActual;
  bool isDeDia = false;
  DateTime sunrise = DateTime.now();
  DateTime sunset = DateTime.now();
  DateTime ahoraCiudad = DateTime.now();

  cambiarDatos(Tiempo tiempo, String localizacion, TiempoHoras tiempoHoras, bool isUbicacionUser){
    this.tiempoActual = tiempo;
    this.localizacion = localizacion;
    this.tiempoHoras = tiempoHoras;
    this.isUbicacionUser = isUbicacionUser;
    notifyListeners();
  }

  void buscarUbicacionActual() async {
    //Reseteamos los valores para que muestre el CircularProgressIndicator en la ubicación
    nombreUbi = '';
    tempUbi = 0;
    estadoUbi = '';
    Position position = await Geolocator.getCurrentPosition();

    Tiempo? tiempoUbi = await TiempoService().getTiempoLatLon(
      position.latitude,
      position.longitude,
    );
    String? nombreCiudad = await LocalizacionService().getNombreCiudadByCords(
      position.longitude,
      position.latitude,
    );
    nombreUbi = nombreCiudad!;
    tempUbi = tiempoUbi!.main.temp;
    estadoUbi = tiempoUbi.weather[0].main;
    ubiActual = position;
    notifyListeners();
  }

  void comprobarUbicacionUser(){
    isUbicacionUser = localizacion == nombreUbi;
    notifyListeners();
  }

  void comprobarNocheDia() {
    
    final int offsetSegundos = tiempoActual!.timezone;

    sunrise = DateTime.fromMillisecondsSinceEpoch(
      tiempoActual!.sys.sunrise * 1000,
      isUtc: true,
    ).add(Duration(seconds: offsetSegundos));

    sunset = DateTime.fromMillisecondsSinceEpoch(
      tiempoActual!.sys.sunset * 1000,
      isUtc: true,
    ).add(Duration(seconds: offsetSegundos));

    ahoraCiudad = DateTime.now().toUtc().add(Duration(seconds: offsetSegundos));
    isDeDia = ahoraCiudad.isAfter(sunrise) && ahoraCiudad.isBefore(sunset);
    notifyListeners();
  }
  
}