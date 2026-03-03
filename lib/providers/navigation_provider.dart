import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier{
  int indiceActual = 0;
  int indiceTiempoDiasActual = 0;
  
  void cambiarIndice(int index) {
    indiceActual = index;
    notifyListeners();
  }

  void cambiarIndiceTiempoDias(int index) {
    indiceTiempoDiasActual = index;
    notifyListeners();
  }
}