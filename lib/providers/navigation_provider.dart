import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier{
  int indiceActual = 0;
  
  void cambiarIndice(int index) {
    indiceActual = index;
    notifyListeners();
  }
}