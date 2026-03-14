import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:manule_weather/models/tiempo_dias_response_model.dart';
import 'package:manule_weather/models/tiempo_horas_model.dart';
import 'package:manule_weather/models/tiempo_model.dart';
import 'package:manule_weather/services/localizacion_service.dart';
import 'package:manule_weather/services/tiempo_service.dart';
import 'package:manule_weather/utils/Utils.dart';
import 'package:provider/provider.dart';

class WeatherProvider with ChangeNotifier {
  Tiempo? tiempoActual;
  String? localizacion;
  TiempoHoras? tiempoHoras;
  bool? isUbicacionUser;
  String nombreUbi = '';
  double tempUbi = 0;
  String estadoUbi = '';
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
    geolocalizacion = position;
    notifyListeners();
  }

  void comprobarUbicacionUser() {
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

  void eliminarHorasPasadas(int elementosAEliminar) {
    tiempoHoras!.time.removeRange(0, elementosAEliminar);
    tiempoHoras!.temperature2M.removeRange(0, elementosAEliminar);
    print(tiempoHoras!.time.toString());
    notifyListeners();
  }

  void inicializarTiempoDias() {
    tiempoDias!.weatherCode.forEach((weatherCode) {
      tiempoDias!.iconosGenerales.add(Utils.obtenerSimbolo(weatherCode, false));
      tiempoDias!.descripcionesCortas.add(Utils.obtenerTiempoText(weatherCode));
    });
    notifyListeners();
  }

  Future<void> actualizarDatos() async {
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
        inicializarTiempoDias();
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
      inicializarTiempoDias();
      DateTime horaActual = ahoraCiudad;
      int elementosAEliminar = horaActual.hour;
      eliminarHorasPasadas(elementosAEliminar);
    }
    notifyListeners();
  }
}
