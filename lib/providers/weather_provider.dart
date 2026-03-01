import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:manule_weather/models/tiempo_dias_model.dart';
import 'package:manule_weather/models/tiempo_horas_model.dart';
import 'package:manule_weather/models/tiempo_model.dart';
import 'package:manule_weather/services/localizacion_service.dart';
import 'package:manule_weather/services/tiempo_service.dart';

class WeatherProvider with ChangeNotifier {
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
  List<TiempoDias>? tiempoDias = [];

  cambiarDatos(
    Tiempo tiempo,
    String localizacion,
    TiempoHoras tiempoHoras,
    bool isUbicacionUser,
  ) {
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
    notifyListeners();
  }

  void inicializarTiempoDias() {
    tiempoDias = []; //Reiniciamos el array
    double tempMax = -1000;
    double tempMin = 1000;
    double lengthBucle = (tiempoHoras!.time.length / 24);
    final hora = tiempoHoras!.time[0]; //Cogemos la primera hora que veamos porque solo mostraremos el día, no las horas
    DateTime fecha = DateTime.parse(hora);
    for (int i = 0; i < lengthBucle; i++) {

      int multiplicacion = (i+1)*24;
      int primerValor = i*24;
      List<double> hrs24 = tiempoHoras!.temperature2M.sublist(primerValor, multiplicacion);
      hrs24.forEach((temp){
        if (temp > tempMax) tempMax = temp;
        if (temp < tempMin) tempMin = temp;
      });
      TiempoDias tiempoDiasGenerado = TiempoDias(tempMax: tempMax, tempMin: tempMin, iconoGeneral: LucideIcons.sun, descripcionCorta: 'Esto es una prueba', fecha: fecha);
      print(tiempoDiasGenerado.fecha);
      tiempoDias!.add(tiempoDiasGenerado);
      fecha = fecha.add(Duration(days: 1));
    }
    notifyListeners();
  }
}
