import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:manule_weather/models/localizacion_model.dart';
import 'package:manule_weather/services/notification_service.dart';
import 'package:manule_weather/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class ConfigProvider with ChangeNotifier {
  String idiomaActual = Platform.localeName.substring(
    0,
    Platform.localeName.length - 3,
  );
  double valorLineaDeCarga = 0;
  bool primeraVez = true;
  List<String> idiomasActuales = [
    'es',
    'en',
    'it',
    'fr',
    'pt',
    'de',
    'ru',
    'uk',
    'ca',
    'ar',
    'ko',
    'ja',
    'zh',
    'he',
  ];
  bool isDarkTheme = false;
  List<Localizacion> historialBusqueda = [];
  bool isNotificationsActive = false;
  bool isUbiActive = false;
  String defaultUbiID = "";
  double defaultUbiLatitude = 0;
  double defaultUbiLongitude = 0;
  String defaultUbiName = "";
  final int limitSearchHistory = 8;

  comprobarIdiomaYPrimeraVez() async {
    final preferences = await SharedPreferences.getInstance();
    bool? primeraVezCheck = preferences.getBool('primeraVez');
    if (primeraVezCheck != null) primeraVez = primeraVezCheck!;
    if (primeraVez) {
      if (idiomasActuales.contains(idiomaActual))
        return;
      else {
        idiomaActual = 'en';
      }
    } else {
      print(primeraVez);
      idiomaActual = preferences.getString('lang')!;
    }
    notifyListeners();
  }

  void validarPrimeraVez() async {
    primeraVez = false;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('primeraVez', primeraVez);
    notifyListeners();
  }

  void cambiarIdioma(String idioma) async {
    idiomaActual = idioma;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('lang', idioma);
    notifyListeners();
  }

  changeNotifications(bool newValue, BuildContext context) async {
    if (newValue == true) {
      bool permitidas = await NotificationService.estanPermitidas();

      if (!permitidas) {
        await NotificationService.init();
        permitidas = await NotificationService.estanPermitidas();

        if (!permitidas) {
          // En lugar de enviarlo de golpe, le explicamos por qué:
          if (context.mounted) {
            bool? irAjustes = await showDialog<bool>(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: Text(
                    Utils.stringTituloPermisoDialogNotifications(idiomaActual),
                  ),
                  content: Text(
                    Utils.stringCuerpoPermisoDialogNotifications(idiomaActual),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: Text(Utils.stringCancelarDialog(idiomaActual)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: Text(Utils.stringIrAjustesDialog(idiomaActual)),
                    ),
                  ],
                );
              },
            );

            if (irAjustes == true) {
              await openAppSettings();
            }
          }
          return; // Salimos y dejamos el switch en off hasta que vuelva con el permiso
        }
      }

      // Si hay permiso, activamos todo normal...
      isNotificationsActive = true;
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool('notifications', true);
    } else {
      // Lógica de apagado normal...
      isNotificationsActive = false;
      await NotificationService.borrarTodasLasNotificaciones();
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool('notifications', false);
    }

    notifyListeners();
  }

  Future<void> changeLocation(bool newValue, BuildContext context) async {
    if (newValue == true) {
      // 1. Comprobar si el GPS del dispositivo está encendido
      bool gpsActivo = await Geolocator.isLocationServiceEnabled();
      if (!gpsActivo) {
        if (context.mounted) {
          bool? irAjustesGps = await showDialog<bool>(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: Text(Utils.stringTituloGpsDialogLocation(idiomaActual)),
                content: Text(
                  Utils.stringCuerpoGpsDialogLocation(idiomaActual),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: Text(Utils.stringCancelarDialog(idiomaActual)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: Text(Utils.stringIrAjustesDialog(idiomaActual)),
                  ),
                ],
              );
            },
          );

          if (irAjustesGps == true) {
            await Geolocator.openLocationSettings();
          }
        }
        return;
      }

      // 2. Comprobar y solicitar el permiso de ubicación de la app
      LocationPermission permiso = await Geolocator.checkPermission();

      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }

      if (permiso == LocationPermission.denied ||
          permiso == LocationPermission.deniedForever) {
        if (context.mounted) {
          bool? irAjustes = await showDialog<bool>(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: Text(
                  Utils.stringTituloPermisoDialogLocation(idiomaActual),
                ),
                content: Text(
                  Utils.stringCuerpoPermisoDialogLocation(idiomaActual),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: Text(Utils.stringCancelarDialog(idiomaActual)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: Text(Utils.stringIrAjustesDialog(idiomaActual)),
                  ),
                ],
              );
            },
          );

          if (irAjustes == true) {
            await openAppSettings();
          }
        }
        return; // Salimos y dejamos el switch en off hasta que vuelva con el permiso
      }

      // Si hay permiso (whileInUse o always), activamos normal
      isUbiActive = true;
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool('ubication', true);
    } else {
      // El permiso del sistema no se puede revocar por código; desactivamos su uso en la app
      isUbiActive = false;
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool('ubication', false);
    }

    notifyListeners();
  }

  void changeTheme(bool newValue) async {
    isDarkTheme = newValue;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('modoOscuro', isDarkTheme);
    notifyListeners();
  }

  comprobarModoOscuro() async {
    final preferences = await SharedPreferences.getInstance();
    bool? isModoOscuro = preferences.getBool('modoOscuro');
    if (isModoOscuro != null) isDarkTheme = isModoOscuro;
    notifyListeners();
  }

  comprobarNotificaciones() async {
    final preferences = await SharedPreferences.getInstance();
    bool? notificaciones = preferences.getBool('notifications');
    if (notificaciones != null) isNotificationsActive = notificaciones;
    notifyListeners();
  }

  comprobarUbicacionActivada() async {
    final preferences = await SharedPreferences.getInstance();
    bool? ubiPermission = preferences.getBool('ubication');
    if (ubiPermission != null) isUbiActive = ubiPermission;
    else preferences.setBool('ubication',false);
    notifyListeners();
  }

  cargarHistorialBusqueda() async {
    final preferences = await SharedPreferences.getInstance();
    String? historialUnparsed = preferences.getString('historial');

    if (historialUnparsed != null) {
      //jsonDecode da una lista dinámica, hay que transformarla a objetos Localizacion
      final List<dynamic> decodedList = jsonDecode(historialUnparsed);
      historialBusqueda = decodedList
          .map((item) => Localizacion.fromJson(item))
          .toList();
    }

    notifyListeners();
  }

  actualizarHistorialBusqueda(Localizacion lugarNuevo) async {
    //Borramos si ya existía para evitar duplicados y por si se cambia de idioma
    historialBusqueda.removeWhere((lugar) => lugar.id == lugarNuevo.id);

    //Si ya hay 8 elementos, echamos al más viejo
    //Al hacer removeAt(0), el resto de elementos suben una posición automáticamente
    if (historialBusqueda.length >= limitSearchHistory) {
      historialBusqueda.removeAt(0);
    }
    //Añadimos el nuevo siempre al final de la lista
    historialBusqueda.add(lugarNuevo);
    notifyListeners();
    await guardarHistorialPersistencia();
  }

  eliminarDelHistorial(String? id) async {
    historialBusqueda.removeWhere((lugar) => lugar.id == id);
    notifyListeners();
    await guardarHistorialPersistencia();
  }

  guardarHistorialPersistencia() async {
    //Mapeamos la lista convirtiendo cada objeto a JSON
    final preferences = await SharedPreferences.getInstance();
    final listaMapeada = historialBusqueda
        .map((lugar) => lugar.toJson())
        .toList();
    String historialParsed = jsonEncode(listaMapeada);

    await preferences.setString("historial", historialParsed);
  }

  cambiarValorLineaDeCarga(double nuevoValor) async {
    valorLineaDeCarga = nuevoValor;
    notifyListeners();
  }

  Future<void> comprobarUbiDefault() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    defaultUbiName = preferences.getString('defUbiName') ?? defaultUbiName;
    defaultUbiID = preferences.getString('defUbiID') ?? defaultUbiID;
    defaultUbiLatitude = preferences.getDouble('latDef') ?? defaultUbiLatitude;
    defaultUbiLongitude =
        preferences.getDouble('longDef') ?? defaultUbiLongitude;

    notifyListeners();
  }

  void cambiarUbiDefault(
    String newName,
    String newId,
    double newLatitude,
    double newLongitude,
  ) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    defaultUbiName = newName;
    await preferences.setString('defUbiName', newName);

    defaultUbiID = newId;
    await preferences.setString('defUbiID', newId);

    defaultUbiLatitude = newLatitude;
    await preferences.setDouble('latDef', newLatitude);

    defaultUbiLongitude = newLongitude;
    await preferences.setDouble('longDef', newLongitude);

    notifyListeners();
  }
}
