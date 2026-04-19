import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:manule_weather/models/tiempo_dias_response_model.dart';
import 'package:manule_weather/models/tiempo_horas_model.dart';
import 'package:manule_weather/models/tiempo_model.dart';
import 'package:manule_weather/services/localizacion_service.dart';
import 'package:manule_weather/services/tiempo_service.dart';
import 'package:manule_weather/utils/Utils.dart';

class WeatherProvider with ChangeNotifier {
  Tiempo? tiempoActual;
  String? localizacion;
  TiempoHoras? tiempoHoras;
  bool? isUbicacionUser;
  String nombreUbi = '';
  double tempUbi = 0;
  String estadoUbi = '';
  IconData? iconoUbi;
  Position? geolocalizacion;
  bool isDeDia = false;
  DateTime sunrise = DateTime.now();
  DateTime sunset = DateTime.now();
  DateTime ahoraCiudad = DateTime.now();
  TiempoDias? tiempoDias;
  double latitudActual = 0;
  double longitudActual = 0;

  cambiarDatos(
    Tiempo tiempo,
    String localizacion,
    TiempoHoras tiempoHoras,
    TiempoDias tiempoDias,
    bool isUbicacionUser,
    double latitude,
    double longitude,
  ) {
    this.tiempoActual = tiempo;
    this.localizacion = localizacion;
    this.tiempoHoras = tiempoHoras;
    this.isUbicacionUser = isUbicacionUser;
    this.tiempoDias = tiempoDias;
    latitudActual = latitude;
    longitudActual = longitude;
    notifyListeners();
  }

  void buscarUbicacionActual(String idioma) async {
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
      idioma
    );
    nombreUbi = nombreCiudad!;
    tempUbi = tiempoUbi!.current.temperature2M;
    //estadoUbi = Utils.obtenerTiempoText(tiempoUbi.current.weatherCode);
    iconoUbi = Utils.obtenerSimbolo(tiempoUbi.current.weatherCode, false, tiempoUbi.current.isDay == 1 ? true:false);
    geolocalizacion = position;
    notifyListeners();
  }

  void comprobarUbicacionUser() {
    isUbicacionUser = localizacion == nombreUbi;
    notifyListeners();
  }

  void comprobarNocheDia() {

    sunrise = DateTime.parse(tiempoDias!.sunrise[0]);

    sunset = DateTime.parse(tiempoDias!.sunset[0]);

    ahoraCiudad = DateTime.parse(tiempoActual!.current.time);
    isDeDia = tiempoActual!.current.isDay == 1 ? true : false;
    notifyListeners();
  }

  void eliminarHorasPasadas(int elementosAEliminar) {
    tiempoHoras!.time.removeRange(0, elementosAEliminar);
    tiempoHoras!.temperature2M.removeRange(0, elementosAEliminar);
    tiempoHoras!.weatherCode.removeRange(0, elementosAEliminar);
    tiempoHoras!.precipitationProbability.removeRange(0, elementosAEliminar);
    tiempoHoras!.uvIndex.removeRange(0, elementosAEliminar);
    tiempoHoras!.windSpeed10M.removeRange(0, elementosAEliminar);
    tiempoHoras!.cloudCover.removeRange(0, elementosAEliminar);
    print(tiempoHoras!.time.toString());
    notifyListeners();
  }

  void inicializarTiempoDias(String idioma) {
    tiempoDias!.weatherCode.forEach((weatherCode) {
      tiempoDias!.iconosGenerales.add(Utils.obtenerSimbolo(weatherCode, false, true));
      tiempoDias!.descripcionesCortas.add(Utils.obtenerTiempoText(weatherCode, idioma));
    });
    notifyListeners();
  }

  Future<void> actualizarDatos(String idioma) async {
    if (isUbicacionUser!) {
      Position position = await Geolocator.getCurrentPosition();
      print("Latitud: ${position.latitude}, Longitud: ${position.longitude}");
      Tiempo? tiempoUbi = await TiempoService().getTiempoLatLon(
        position.latitude,
        position.longitude,
      );
      String? nombreCiudad = await LocalizacionService().getNombreCiudadByCords(
        position.longitude,
        position.latitude,
        idioma
      );
      TiempoHoras? tiempoHoras = await TiempoService().getTiempoPorHoras(
        position.latitude,
        position.longitude,
      );
      TiempoDias? tiempoDias = await TiempoService().getTiempoPorDias(
        position.latitude,
        position.longitude,
      );

      if (tiempoUbi != null && nombreCiudad != null && tiempoHoras != null) {
        cambiarDatos(
          tiempoUbi,
          nombreCiudad,
          tiempoHoras,
          tiempoDias!,
          true,
          position.latitude,
          position.longitude,
        );
        comprobarNocheDia();
        inicializarTiempoDias(idioma);
        DateTime horaActual = ahoraCiudad;
        int elementosAEliminar = horaActual.hour;
        eliminarHorasPasadas(elementosAEliminar);
      }
    } else {
      Tiempo? tiempoUbi = await TiempoService().getTiempoLatLon(
        latitudActual,
        longitudActual,
      );
      TiempoHoras? tiempoHoras = await TiempoService().getTiempoPorHoras(
        latitudActual,
        longitudActual,
      );
      cambiarDatos(
        tiempoUbi!,
        localizacion!,
        tiempoHoras!,
        tiempoDias!,
        false,
        latitudActual,
        longitudActual,
      );
      comprobarNocheDia();
      inicializarTiempoDias(idioma);
      DateTime horaActual = ahoraCiudad;
      int elementosAEliminar = horaActual.hour;
      eliminarHorasPasadas(elementosAEliminar);
    }
    notifyListeners();
  }
}
