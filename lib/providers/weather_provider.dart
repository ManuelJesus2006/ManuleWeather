import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:manule_weather/models/tiempo_dias_response_model.dart';
import 'package:manule_weather/models/tiempo_horas_model.dart';
import 'package:manule_weather/models/tiempo_model.dart';
import 'package:manule_weather/presentation/widgets/home_widget/home_screen_widget_manager.dart';
import 'package:manule_weather/services/localizacion_service.dart';
import 'package:manule_weather/services/tiempo_service.dart';
import 'package:manule_weather/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  DateTime moonrise = DateTime.now();
  DateTime moonset = DateTime.now();
  DateTime ahoraCiudad = DateTime.now();
  TiempoDias? tiempoDias;
  double latitudActual = 0;
  double longitudActual = 0;
  double faseLunar = 0; //Número del 0 al 1, 0 = luna nueva / 0.5 = luna llena / 1 = fin fase y luna nueva otra vez
  DateTime fechaProximaLunaNueva = DateTime.now();
  DateTime fechaProximaLunaLlena = DateTime.now();

  cambiarDatos(
    Tiempo tiempo,
    String localizacion,
    TiempoHoras tiempoHoras,
    TiempoDias tiempoDias,
    bool isUbicacionUser,
    double latitude,
    double longitude,
  ) async {
    this.tiempoActual = tiempo;
    this.localizacion = localizacion;
    this.tiempoHoras = tiempoHoras;
    this.isUbicacionUser = isUbicacionUser;
    this.tiempoDias = tiempoDias;
    latitudActual = latitude;
    longitudActual = longitude;
    if (isUbicacionUser) {
      //Si el cambio de data es de la ubicación actual, los guardamos para las notificaciones y el widget
      final preferences = await SharedPreferences.getInstance();
      await preferences.setDouble('last_latitude', latitudActual);
      await preferences.setDouble('last_longitude', longitudActual);
    }
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
      idioma,
    );
    nombreUbi = nombreCiudad!;
    tempUbi = tiempoUbi!.current.temperature2M;
    //estadoUbi = Utils.obtenerTiempoText(tiempoUbi.current.weatherCode);
    iconoUbi = Utils.obtenerSimbolo(
      tiempoUbi.current.weatherCode,
      false,
      tiempoUbi.current.isDay == 1 ? true : false,
    );
    geolocalizacion = position;
    notifyListeners();
  }

  void comprobarUbicacionUser() {
    isUbicacionUser = localizacion!.toLowerCase() == nombreUbi.toLowerCase();
    notifyListeners();
  }

  void comprobarNocheDia() {
    ahoraCiudad = DateTime.parse(tiempoActual!.current.time);
    isDeDia = tiempoActual!.current.isDay == 1;

    // Protegemos el sol (por si estás en los polos y es noche/día polar)
    sunrise = DateTime.parse(tiempoDias!.sunrise[0]);

    sunset = DateTime.parse(tiempoDias!.sunset[0]);

    // Protegemos la luna (la verdadera culpable, no sale todos los días)
    moonrise = tiempoDias!.moonrise[0] != null 
        ? DateTime.parse(tiempoDias!.moonrise[0]!) 
        : ahoraCiudad;

    moonset = tiempoDias!.moonset[0] != null 
        ? DateTime.parse(tiempoDias!.moonset[0]!) 
        : ahoraCiudad;

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
    tiempoHoras!.relativeHumidity2M.removeRange(0, elementosAEliminar);
    tiempoHoras!.precipitation.removeRange(0, elementosAEliminar);
    print(tiempoHoras!.time);
    notifyListeners();
  }

  void inicializarTiempoDias(String idioma) {
    tiempoDias!.weatherCode.forEach((weatherCode) {
      tiempoDias!.iconosGenerales.add(
        Utils.obtenerSimbolo(weatherCode, false, true),
      );
      tiempoDias!.descripcionesCortas.add(
        Utils.obtenerTiempoText(weatherCode, idioma),
      );
    });
    notifyListeners();
  }

  Future<void> actualizarDatos(String idioma) async {
    if (isUbicacionUser!) {
      final preferences = await SharedPreferences.getInstance();
      Position position = await Geolocator.getCurrentPosition();
      print("Latitud: ${position.latitude}, Longitud: ${position.longitude}");

      final resultadosPeticion = await Future.wait([
        TiempoService().getTiempoLatLon(position.latitude, position.longitude),
        LocalizacionService().getNombreCiudadByCords(
          position.longitude,
          position.latitude,
          idioma,
        ),
        TiempoService().getTiempoPorHoras(
          position.latitude,
          position.longitude,
        ),
        TiempoService().getTiempoPorDias(position.latitude, position.longitude),
      ]);

      Tiempo? tiempoUbi = resultadosPeticion[0] as Tiempo;
      String? nombreCiudad = resultadosPeticion[1] as String;
      TiempoHoras? tiempoHoras = resultadosPeticion[2] as TiempoHoras;
      TiempoDias? tiempoDias = resultadosPeticion[3] as TiempoDias;

      if (tiempoUbi != null && nombreCiudad != null && tiempoHoras != null) {
        cambiarDatos(
          tiempoUbi,
          nombreCiudad,
          tiempoHoras,
          tiempoDias,
          true,
          position.latitude,
          position.longitude,
        );
        comprobarNocheDia();
        inicializarTiempoDias(idioma);
        int elementosAEliminar = ahoraCiudad.hour;
        eliminarHorasPasadas(elementosAEliminar);
        //Cambiamos los datos en el widget
        HomeScreenWidgetManager.actualizarDatos(
          ciudad: nombreCiudad,
          idioma: idioma,
          fondoOscuro: preferences.getBool('modoOscuro') ?? false,
          tiempoActual: tiempoUbi,
          rainData: Utils.getRainLevelData(null, tiempoHoras),
          snowData: Utils.getSnowLevelData(null, tiempoHoras),
          hayNieve: tiempoHoras.weatherCode
              .take(8)
              .any((code) => Utils.isNevando(code)),
              hayLluvia: tiempoHoras.weatherCode
              .take(8)
              .any((code) => Utils.isLloviendo(code),
        ));
        //Actualizamos la notificacion de tiempo actual
        //Temperatura maxima y minima
        int tempMax = tiempoDias.temperature2MMax[0].round();
        int tempMin = tiempoDias.temperature2MMin[0].round();
        await Utils.mandarNotificacionTiempoActual(
          tempMax,
          tempMin,
          tiempoUbi,
          nombreCiudad,
          idioma,
        );
      }
    } else {
      final resultadosPeticion = await Future.wait([
        TiempoService().getTiempoLatLon(latitudActual, longitudActual),
        TiempoService().getTiempoPorHoras(latitudActual, longitudActual),
        TiempoService().getTiempoPorDias(latitudActual, longitudActual),
      ]);

      Tiempo? tiempoUbi = resultadosPeticion[0] as Tiempo;
      TiempoHoras? tiempoHoras = resultadosPeticion[1] as TiempoHoras;
      TiempoDias? tiempoDias = resultadosPeticion[2] as TiempoDias;
      cambiarDatos(
        tiempoUbi,
        localizacion!,
        tiempoHoras,
        tiempoDias,
        false,
        latitudActual,
        longitudActual,
      );
      comprobarNocheDia();
      inicializarTiempoDias(idioma);
      int elementosAEliminar = ahoraCiudad.hour;
      eliminarHorasPasadas(elementosAEliminar);
      cambiarFaseLunar();
    }
    notifyListeners();
  }

  void cambiarFaseLunar() {
    //Para calcular simplemente la fase actual utilizamos un método aparte que reutilizo para el tiempoDias
    faseLunar = Utils.calcularFaseLunarByFecha(ahoraCiudad);

    //Para obtener los datos de las proximas lunas llena y nueva volvemos a usar lo mismo que el método anterior pero sin hacer lo mismo
    DateTime lunaLlenaReferencia = DateTime(2000, 1, 6); // Luna llena conocida
    double diasDesde =
        ahoraCiudad.difference(lunaLlenaReferencia).inSeconds / 86400;

    // El ciclo lunar exacto en días
    const double cicloLunar = 29.530588;

    double faseActualDias = diasDesde % cicloLunar;

    // Días que faltan para la próxima Luna Nueva (final del ciclo)
    double diasParaNueva = cicloLunar - faseActualDias;

    // Días que faltan para la próxima Luna Llena (mitad del ciclo)
    double diasParaLlena = faseActualDias < (cicloLunar / 2)
        ? (cicloLunar / 2) - faseActualDias
        : cicloLunar - (faseActualDias - (cicloLunar / 2));

    // Sumamos esos días a la fecha que le pasaste y devolvemos las dos fechas
    fechaProximaLunaLlena = ahoraCiudad.add(
      Duration(seconds: (diasParaLlena * 86400).round()),
    );
    fechaProximaLunaNueva = ahoraCiudad.add(
      Duration(seconds: (diasParaNueva * 86400).round()),
    );
    notifyListeners();
  }
}
