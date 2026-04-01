import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigProvider with ChangeNotifier {
  String idiomaActual = Platform.localeName.substring(
    0,
    Platform.localeName.length - 3,
  );
  bool primeraVez = true;
  List<String> idiomasActuales = ['es', 'en'];

  comprobarIdiomaYPrimeraVez() async{
    final preferences = await SharedPreferences.getInstance();
    bool? primeraVezCheck = preferences.getBool('primeraVez');
    if (primeraVezCheck != null) primeraVez = primeraVezCheck!;
    if (primeraVez) {
      if (idiomasActuales.contains(idiomaActual))
        return;
      else {
        idiomaActual = 'en';
      }
    }else{
      print(primeraVez);
      idiomaActual = preferences.getString('lang')!;
    }
    notifyListeners();
  }

  void validarPrimeraVez()async{
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
}
