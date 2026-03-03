import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:manule_weather/models/tiempo_dias_model.dart';
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
  List<TiempoDias>? tiempoDias = [];
  double latitudActual = 0;
  double longitudActual = 0;

  cambiarDatos(
    Tiempo tiempo,
    String localizacion,
    TiempoHoras tiempoHoras,
    bool isUbicacionUser,
    double latitude,
    double longitude,
  ) {
    this.tiempoActual = tiempo;
    this.localizacion = localizacion;
    this.tiempoHoras = tiempoHoras;
    this.isUbicacionUser = isUbicacionUser;
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
    tiempoDias = []; //Reiniciamos el array
    double tempMax = -1000;
    double tempMin = 1000;
    double lengthBucle = (tiempoHoras!.time.length / 24);
    final hora = tiempoHoras!
        .time[0]; //Cogemos la primera hora que veamos porque solo mostraremos el día, no las horas
    DateTime fecha = DateTime.parse(hora);
    for (int i = 0; i < lengthBucle; i++) {
      //Bucle inicial cada 24hrs (1 día) disponibles
      tempMax = -1000;
      tempMin = 1000;
      int multiplicacion = (i + 1) * 24;
      int primerValor = i * 24;
      List<double> hrs24 = tiempoHoras!.temperature2M.sublist(
        primerValor,
        multiplicacion,
      );
      List<int> weatherCodes24hrs = tiempoHoras!.weatherCode.sublist(
        primerValor,
        multiplicacion,
      );
      hrs24.forEach((temp) {
        if (temp > tempMax) tempMax = temp;
        if (temp < tempMin) tempMin = temp;
      });
      Map<int, int> frecuencias = {};

      weatherCodes24hrs.forEach((weatherCode) {
        frecuencias[weatherCode] = (frecuencias[weatherCode] ?? 0) + 1;
      });

      int codeMasFrecuente = frecuencias.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;

      IconData iconoMasRepetitivo = Utils.obtenerSimbolo(
        codeMasFrecuente,
        false,
      );
      TiempoDias tiempoDiasGenerado = TiempoDias(
        tempMax: tempMax,
        tempMin: tempMin,
        iconoGeneral: iconoMasRepetitivo,
        descripcionCorta: Utils.obtenerTiempoText(codeMasFrecuente),
        fecha: fecha,
      );
      print(tiempoDiasGenerado.fecha);
      tiempoDias!.add(tiempoDiasGenerado);
      fecha = fecha.add(Duration(days: 1));
    }
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

      if (tiempoUbi != null && nombreCiudad != null && tiempoHoras != null) {
        cambiarDatos(
          tiempoUbi,
          nombreCiudad,
          tiempoHoras,
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
