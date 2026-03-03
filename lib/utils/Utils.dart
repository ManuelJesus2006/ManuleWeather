import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Utils {
  static String formatearHora(DateTime fecha) {
    // Añade un 0 a la izquierda si los minutos son menores de 10
    String minutos = fecha.minute < 10 ? '0${fecha.minute}' : '${fecha.minute}';
    return '${fecha.hour}:$minutos';
  }

  static String obtenerDiaSemana(int weekday) {
    switch (weekday) {
      case 1:
        return 'Lunes';
      case 2:
        return 'Martes';
      case 3:
        return 'Miércoles';
      case 4:
        return 'Jueves';
      case 5:
        return 'Viernes';
      case 6:
        return 'Sábado';
      case 7:
        return 'Domingo';
      default:
        return 'Desconocido';
    }
  }

  static String obtenerMes(int mesNum) {
    switch (mesNum) {
      case 1:
        return 'enero';
      case 2:
        return 'febrero';
      case 3:
        return 'marzo';
      case 4:
        return 'abril';
      case 5:
        return 'mayo';
      case 6:
        return 'junio';
      case 7:
        return 'julio';
      case 8:
        return 'agosto';
      case 9:
        return 'septiembre';
      case 10:
        return 'octubre';
      case 11:
        return 'noviembre';
      case 12:
        return 'diciembre';
      default:
        return 'desconocido';
    }
  }

  static obtenerSimbolo(int weatherCode, bool isTiempoHora) {
    IconData iconData;

    if (weatherCode == 0 || weatherCode == 1)
      iconData = LucideIcons.sun;
    else if (weatherCode == 2)
      iconData = LucideIcons.cloudSun;
    else if (weatherCode == 3)
      iconData = LucideIcons.cloud;
    else if (weatherCode == 45 || weatherCode == 48)
      iconData = LucideIcons.cloudFog;
    else if (weatherCode >= 51 && weatherCode <= 57)
      iconData = LucideIcons.cloudDrizzle;
    else if (weatherCode == 61 || weatherCode == 63 || weatherCode == 66)
      iconData = LucideIcons.cloudRain;
    else if (weatherCode == 65 || weatherCode == 67)
      iconData = LucideIcons.cloudRainWind;
    else if (weatherCode >= 71 && weatherCode <= 75)
      iconData = LucideIcons.cloudSnow;
    else if (weatherCode == 77)
      iconData = LucideIcons.snowflake;
    else if (weatherCode == 80 || weatherCode == 81)
      iconData = LucideIcons.cloudRain;
    else if (weatherCode == 82)
      iconData = LucideIcons.cloudRainWind;
    else if (weatherCode == 85 || weatherCode == 86)
      iconData = LucideIcons.cloudSnow;
    else if (weatherCode >= 95)
      iconData = LucideIcons.cloudLightning;
    else
      iconData = LucideIcons.cloud;

    return isTiempoHora ? Icon(iconData, size: 30, color: Colors.black) : iconData;
  }

  static String obtenerTiempoText(int weatherCode) {
  if (weatherCode == 0) return 'Cielo despejado';
  if (weatherCode == 1) return 'Principalmente despejado';
  if (weatherCode == 2) return 'Parcialmente nublado';
  if (weatherCode == 3) return 'Nublado';
  if (weatherCode == 45) return 'Niebla';
  if (weatherCode == 48) return 'Niebla con escarcha';
  if (weatherCode == 51) return 'Llovizna ligera';
  if (weatherCode == 53) return 'Llovizna moderada';
  if (weatherCode == 55) return 'Llovizna intensa';
  if (weatherCode == 56) return 'Llovizna engelante ligera';
  if (weatherCode == 57) return 'Llovizna engelante intensa';
  if (weatherCode == 61) return 'Lluvia ligera';
  if (weatherCode == 63) return 'Lluvia moderada';
  if (weatherCode == 65) return 'Lluvia intensa';
  if (weatherCode == 66) return 'Lluvia engelante ligera';
  if (weatherCode == 67) return 'Lluvia engelante intensa';
  if (weatherCode == 71) return 'Nevada ligera';
  if (weatherCode == 73) return 'Nevada moderada';
  if (weatherCode == 75) return 'Nevada intensa';
  if (weatherCode == 77) return 'Granos de nieve';
  if (weatherCode == 80) return 'Chubascos ligeros';
  if (weatherCode == 81) return 'Chubascos moderados';
  if (weatherCode == 82) return 'Chubascos violentos';
  if (weatherCode == 85) return 'Chubascos de nieve ligeros';
  if (weatherCode == 86) return 'Chubascos de nieve intensos';
  if (weatherCode == 95) return 'Tormenta eléctrica';
  if (weatherCode == 96) return 'Tormenta con granizo ligero';
  if (weatherCode == 99) return 'Tormenta con granizo intenso';
  return 'Desconocido';
}

  static obtenerSimboloTiempoActual(String iconCode) {
    IconData iconData;

  switch (iconCode) {
    case '01d':
      iconData = LucideIcons.sun;
      break;
    case '01n':
      iconData = LucideIcons.moon;
      break;
    case '02d':
      iconData = LucideIcons.cloudSun;
      break;
    case '02n':
      iconData = LucideIcons.cloudMoon;
      break;
    case '03d':
    case '03n':
      iconData = LucideIcons.cloud;
      break;
    case '04d':
    case '04n':
      iconData = LucideIcons.cloudy;
      break;
    case '09d':
    case '09n':
      iconData = LucideIcons.cloudDrizzle;
      break;
    case '10d':
      iconData = LucideIcons.cloudSunRain;
      break;
    case '10n':
      iconData = LucideIcons.cloudRain;
      break;
    case '11d':
    case '11n':
      iconData = LucideIcons.cloudLightning;
      break;
    case '13d':
    case '13n':
      iconData = LucideIcons.cloudSnow;
      break;
    case '50d':
    case '50n':
      iconData = LucideIcons.cloudFog;
      break;
    default:
      iconData = LucideIcons.cloud;
  }

  return Icon(iconData, size: 50, color: Colors.white);
  }
}
