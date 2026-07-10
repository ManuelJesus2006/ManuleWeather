import 'dart:ffi';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:manule_weather/models/lluvia_level_model.dart';
import 'package:manule_weather/models/tiempo_horas_model.dart';
import 'package:manule_weather/presentation/widgets/card_alert_widget.dart';
import 'package:manule_weather/providers/weather_provider.dart';

class Utils {
  static String formatearHora(DateTime fecha) {
    // Añade un 0 a la izquierda si los minutos son menores de 10
    String minutos = fecha.minute < 10 ? '0${fecha.minute}' : '${fecha.minute}';
    return '${fecha.hour}:$minutos';
  }

  static String getFlagEmoji(String idioma) {
    switch (idioma) {
      case 'es':
        return '🇪🇸';
      case 'en':
        return '🇬🇧';
      case 'fr':
        return '🇫🇷';
      case 'de':
        return '🇩🇪';
      case 'it':
        return '🇮🇹';
      case 'pt':
        return '🇵🇹';
      case 'uk':
        return '🇺🇦';
      case 'ru':
        return '🇷🇺';
      case 'he':
        return '🇮🇱';
      case 'ar':
        return '🇸🇦';
      case 'zh':
        return '🇨🇳';
      case 'ko':
        return '🇰🇷';
      case 'ja':
        return '🇯🇵';
      default:
        return '🌐';
    }
  }

  static obtenerSimbolo(int weatherCode, bool isTiempoHora, bool isDeDia) {
    IconData iconData;

    if (isDeDia) {
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
        iconData = LucideIcons.x;
    } else {
      if (weatherCode == 0 || weatherCode == 1)
        iconData = LucideIcons.moon;
      else if (weatherCode == 2)
        iconData = LucideIcons.cloudMoon;
      else if (weatherCode == 3)
        iconData = LucideIcons.cloud;
      else if (weatherCode == 45 || weatherCode == 48)
        iconData = LucideIcons.cloudFog;
      else if (weatherCode >= 51 && weatherCode <= 57)
        // ignore: curly_braces_in_flow_control_structures
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
        iconData = LucideIcons.x;
    }

    return isTiempoHora
        ? Icon(iconData, size: 26, color: Colors.black)
        : iconData;
  }

  static AssetImage recibirFondoApp(bool isDeDia, int weatherCode) {
    //Si hace tormenta comprobamos el weatherCode y nos da igual si es de día o de noche
    if (weatherCode == 95 || weatherCode == 96 || weatherCode == 99)
      return AssetImage("assets/images/fondo_tormenta.gif");

    //Si esta lloviendo comprobamos el weatherCode y nos da igual si es de día o de noche
    const codigosLluvia = {51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82};

    if (codigosLluvia.contains(weatherCode)) {
      return AssetImage('assets/images/fondo_lluvia_dia.gif');
    }

    //Si esta nevando comprobamos el weatherCode y nos da igual si es de día o de noche
    const codigosNieve = {71, 73, 75, 77, 85, 86};

    if (codigosNieve.contains(weatherCode)) {
      return AssetImage('assets/images/fondo_nieve.gif');
    }

    if (isDeDia) {
      if (weatherCode == 2)
        return AssetImage('assets/images/fondo_parcialmente_nublado_dia.png');
      else if (weatherCode == 3 || weatherCode == 45 || weatherCode == 48)
        return AssetImage('assets/images/fondo_nublado_dia.png');
      else
        return AssetImage('assets/images/fondo_dia.png');
    } else {
      if (weatherCode == 3 || weatherCode == 45 || weatherCode == 48)
        return AssetImage('assets/images/fondo_nublado_noche.png');
      else
        return AssetImage('assets/images/fondo_noche.jpg');
    }
  }

  static AssetImage recibirFondoWidget(bool isDeDia, int weatherCode) {
  // 🚀 PARCHE PARA EL WIDGET: Si es un GIF, cámbialo por un PNG/JPG equivalente estático
  /*if (weatherCode == 95 || weatherCode == 96 || weatherCode == 99)
    return const AssetImage("assets/images/fondo_tormenta_estatico.png"); // Crea una versión estática

  const codigosLluvia = {51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82};
  if (codigosLluvia.contains(weatherCode)) {
    return const AssetImage('assets/images/fondo_lluvia_estatico.png'); // Versión estática
  }

  const codigosNieve = {71, 73, 75, 77, 85, 86};
  if (codigosNieve.contains(weatherCode)) {
    return const AssetImage('assets/images/fondo_nieve_estatico.png'); // Versión estática
  }*/

  // Las que ya son .png o .jpg van a funcionar perfectamente de primeras:
  if (isDeDia) {
    if (weatherCode == 2)
      return const AssetImage('assets/images/fondo_parcialmente_nublado_dia.png');
    else if (weatherCode == 3 || weatherCode == 45 || weatherCode == 48)
      return const AssetImage('assets/images/fondo_nublado_dia.png');
    else
      return const AssetImage('assets/images/fondo_dia.png');
  } else {
    if (weatherCode == 3 || weatherCode == 45 || weatherCode == 48)
      return const AssetImage('assets/images/fondo_nublado_noche.png');
    else
      return const AssetImage('assets/images/fondo_noche.jpg');
  }
}

  static String obtenerDiaSemana(int weekday, String idioma) {
    switch (idioma) {
      case 'es':
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
      case 'fr':
        switch (weekday) {
          case 1:
            return 'Lundi';
          case 2:
            return 'Mardi';
          case 3:
            return 'Mercredi';
          case 4:
            return 'Jeudi';
          case 5:
            return 'Vendredi';
          case 6:
            return 'Samedi';
          case 7:
            return 'Dimanche';
          default:
            return 'Inconnu';
        }
      case 'it':
        switch (weekday) {
          case 1:
            return 'Lunedì';
          case 2:
            return 'Martedì';
          case 3:
            return 'Mercoledì';
          case 4:
            return 'Giovedì';
          case 5:
            return 'Venerdì';
          case 6:
            return 'Sabato';
          case 7:
            return 'Domenica';
          default:
            return 'Sconosciuto';
        }
      case 'de':
        switch (weekday) {
          case 1:
            return 'Montag';
          case 2:
            return 'Dienstag';
          case 3:
            return 'Mittwoch';
          case 4:
            return 'Donnerstag';
          case 5:
            return 'Freitag';
          case 6:
            return 'Samstag';
          case 7:
            return 'Sonntag';
          default:
            return 'Unbekannt';
        }
      case 'ru':
        switch (weekday) {
          case 1:
            return 'Понедельник';
          case 2:
            return 'Вторник';
          case 3:
            return 'Среда';
          case 4:
            return 'Четверг';
          case 5:
            return 'Пятница';
          case 6:
            return 'Суббота';
          case 7:
            return 'Воскресенье';
          default:
            return 'Неизвестно';
        }
      case 'pt':
        switch (weekday) {
          case 1:
            return 'Segunda-feira';
          case 2:
            return 'Terça-feira';
          case 3:
            return 'Quarta-feira';
          case 4:
            return 'Quinta-feira';
          case 5:
            return 'Sexta-feira';
          case 6:
            return 'Sábado';
          case 7:
            return 'Domingo';
          default:
            return 'Desconhecido';
        }
      case 'ca':
        switch (weekday) {
          case 1:
            return 'Dilluns';
          case 2:
            return 'Dimarts';
          case 3:
            return 'Dimecres';
          case 4:
            return 'Dijous';
          case 5:
            return 'Divendres';
          case 6:
            return 'Dissabte';
          case 7:
            return 'Diumenge';
          default:
            return 'Desconegut';
        }
      case 'he':
        switch (weekday) {
          case 1:
            return 'יום שני';
          case 2:
            return 'יום שלישי';
          case 3:
            return 'יום רביעי';
          case 4:
            return 'יום חמישי';
          case 5:
            return 'יום שישי';
          case 6:
            return 'יום שבת';
          case 7:
            return 'יום ראשון';
          default:
            return 'לא ידוע';
        }
      case 'uk':
        switch (weekday) {
          case 1:
            return 'Понеділок';
          case 2:
            return 'Вівторок';
          case 3:
            return 'Середа';
          case 4:
            return 'Четвер';
          case 5:
            return 'П’ятниця';
          case 6:
            return 'Субота';
          case 7:
            return 'Неділя';
          default:
            return 'Невідомо';
        }
      case 'ar':
        switch (weekday) {
          case 1:
            return 'الإثنين';
          case 2:
            return 'الثلاثاء';
          case 3:
            return 'الأربعاء';
          case 4:
            return 'الخميس';
          case 5:
            return 'الجمعة';
          case 6:
            return 'السبت';
          case 7:
            return 'الأحد';
          default:
            return 'غير معروف';
        }
      case 'zh':
        switch (weekday) {
          case 1:
            return '星期一';
          case 2:
            return '星期二';
          case 3:
            return '星期三';
          case 4:
            return '星期四';
          case 5:
            return '星期五';
          case 6:
            return '星期六';
          case 7:
            return '星期日';
          default:
            return '未知';
        }
      case 'ko':
        switch (weekday) {
          case 1:
            return '월요일';
          case 2:
            return '화요일';
          case 3:
            return '수요일';
          case 4:
            return '목요일';
          case 5:
            return '금요일';
          case 6:
            return '토요일';
          case 7:
            return '일요일';
          default:
            return '알 수 없음';
        }
      case 'ja':
        switch (weekday) {
          case 1:
            return '月曜日';
          case 2:
            return '火曜日';
          case 3:
            return '水曜日';
          case 4:
            return '木曜日';
          case 5:
            return '金曜日';
          case 6:
            return '土曜日';
          case 7:
            return '日曜日';
          default:
            return '不明';
        }
      default:
        switch (weekday) {
          case 1:
            return 'Monday';
          case 2:
            return 'Tuesday';
          case 3:
            return 'Wednesday';
          case 4:
            return 'Thursday';
          case 5:
            return 'Friday';
          case 6:
            return 'Saturday';
          case 7:
            return 'Sunday';
          default:
            return 'Unknown';
        }
    }
  }

  static String obtenerMes(int mesNum, String idioma) {
    switch (idioma) {
      case 'es':
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
      case 'fr':
        switch (mesNum) {
          case 1:
            return 'janvier';
          case 2:
            return 'février';
          case 3:
            return 'mars';
          case 4:
            return 'avril';
          case 5:
            return 'mai';
          case 6:
            return 'juin';
          case 7:
            return 'juillet';
          case 8:
            return 'août';
          case 9:
            return 'septembre';
          case 10:
            return 'octobre';
          case 11:
            return 'novembre';
          case 12:
            return 'décembre';
          default:
            return 'inconnu';
        }
      case 'it':
        switch (mesNum) {
          case 1:
            return 'gennaio';
          case 2:
            return 'febbraio';
          case 3:
            return 'marzo';
          case 4:
            return 'aprile';
          case 5:
            return 'maggio';
          case 6:
            return 'giugno';
          case 7:
            return 'luglio';
          case 8:
            return 'agosto';
          case 9:
            return 'settembre';
          case 10:
            return 'ottobre';
          case 11:
            return 'novembre';
          case 12:
            return 'dicembre';
          default:
            return 'sconosciuto';
        }
      case 'de':
        switch (mesNum) {
          case 1:
            return 'Januar';
          case 2:
            return 'Februar';
          case 3:
            return 'März';
          case 4:
            return 'April';
          case 5:
            return 'Mai';
          case 6:
            return 'Juni';
          case 7:
            return 'Juli';
          case 8:
            return 'August';
          case 9:
            return 'September';
          case 10:
            return 'Oktober';
          case 11:
            return 'November';
          case 12:
            return 'Dezember';
          default:
            return 'unbekannt';
        }
      case 'ru':
        switch (mesNum) {
          case 1:
            return 'января';
          case 2:
            return 'февраля';
          case 3:
            return 'марта';
          case 4:
            return 'апреля';
          case 5:
            return 'мая';
          case 6:
            return 'июня';
          case 7:
            return 'июля';
          case 8:
            return 'августа';
          case 9:
            return 'сентября';
          case 10:
            return 'октября';
          case 11:
            return 'ноября';
          case 12:
            return 'декабря';
          default:
            return 'неизвестно';
        }
      case 'pt':
        switch (mesNum) {
          case 1:
            return 'janeiro';
          case 2:
            return 'fevereiro';
          case 3:
            return 'março';
          case 4:
            return 'abril';
          case 5:
            return 'maio';
          case 6:
            return 'junho';
          case 7:
            return 'julho';
          case 8:
            return 'agosto';
          case 9:
            return 'setembro';
          case 10:
            return 'outubro';
          case 11:
            return 'novembro';
          case 12:
            return 'dezembro';
          default:
            return 'desconhecido';
        }
      case 'ca':
        switch (mesNum) {
          case 1:
            return 'gener';
          case 2:
            return 'febrer';
          case 3:
            return 'març';
          case 4:
            return 'abril';
          case 5:
            return 'maig';
          case 6:
            return 'juny';
          case 7:
            return 'juliol';
          case 8:
            return 'agost';
          case 9:
            return 'setembre';
          case 10:
            return 'octubre';
          case 11:
            return 'novembre';
          case 12:
            return 'desembre';
          default:
            return 'desconegut';
        }
      case 'he':
        switch (mesNum) {
          case 1:
            return 'ינואר';
          case 2:
            return 'פברואר';
          case 3:
            return 'מרץ';
          case 4:
            return 'אפריל';
          case 5:
            return 'מאי';
          case 6:
            return 'יוני';
          case 7:
            return 'יולי';
          case 8:
            return 'אוגוסט';
          case 9:
            return 'ספטמבר';
          case 10:
            return 'אוקטובר';
          case 11:
            return 'נובמבר';
          case 12:
            return 'דצמבר';
          default:
            return 'לא ידוע';
        }
      case 'uk':
        switch (mesNum) {
          case 1:
            return 'січня';
          case 2:
            return 'лютого';
          case 3:
            return 'березня';
          case 4:
            return 'квітня';
          case 5:
            return 'травня';
          case 6:
            return 'червня';
          case 7:
            return 'липня';
          case 8:
            return 'серпня';
          case 9:
            return 'вересня';
          case 10:
            return 'жовтня';
          case 11:
            return 'листопада';
          case 12:
            return 'грудня';
          default:
            return 'невідомо';
        }
      case 'ar':
        switch (mesNum) {
          case 1:
            return 'يناير';
          case 2:
            return 'فبراير';
          case 3:
            return 'مارس';
          case 4:
            return 'أبريل';
          case 5:
            return 'مايو';
          case 6:
            return 'يونيو';
          case 7:
            return 'يوليو';
          case 8:
            return 'أغسطس';
          case 9:
            return 'سبتمبر';
          case 10:
            return 'أكتوبر';
          case 11:
            return 'نوفمبر';
          case 12:
            return 'ديسمبر';
          default:
            return 'غير معروف';
        }
      case 'zh':
        switch (mesNum) {
          case 1:
            return '一月';
          case 2:
            return '二月';
          case 3:
            return '三月';
          case 4:
            return '四月';
          case 5:
            return '五月';
          case 6:
            return '六月';
          case 7:
            return '七月';
          case 8:
            return '八月';
          case 9:
            return '九月';
          case 10:
            return '十月';
          case 11:
            return '十一月';
          case 12:
            return '十二月';
          default:
            return '未知';
        }
      case 'ko':
        switch (mesNum) {
          case 1:
            return '1월';
          case 2:
            return '2월';
          case 3:
            return '3월';
          case 4:
            return '4월';
          case 5:
            return '5월';
          case 6:
            return '6월';
          case 7:
            return '7월';
          case 8:
            return '8월';
          case 9:
            return '9월';
          case 10:
            return '10월';
          case 11:
            return '11월';
          case 12:
            return '12월';
          default:
            return '알 수 없음';
        }
      case 'ja':
        switch (mesNum) {
          case 1:
            return '1月';
          case 2:
            return '2月';
          case 3:
            return '3月';
          case 4:
            return '4月';
          case 5:
            return '5月';
          case 6:
            return '6月';
          case 7:
            return '7月';
          case 8:
            return '8月';
          case 9:
            return '9月';
          case 10:
            return '10月';
          case 11:
            return '11月';
          case 12:
            return '12月';
          default:
            return '不明';
        }
      default:
        switch (mesNum) {
          case 1:
            return 'january';
          case 2:
            return 'february';
          case 3:
            return 'march';
          case 4:
            return 'april';
          case 5:
            return 'may';
          case 6:
            return 'june';
          case 7:
            return 'july';
          case 8:
            return 'august';
          case 9:
            return 'september';
          case 10:
            return 'october';
          case 11:
            return 'november';
          case 12:
            return 'december';
          default:
            return 'unknown';
        }
    }
  }

  static String obtenerTiempoText(int weatherCode, String idioma) {
    switch (idioma) {
      case 'es':
        switch (weatherCode) {
          case 0:
            return 'Cielo despejado';
          case 1:
            return 'Principalmente despejado';
          case 2:
            return 'Parcialmente nublado';
          case 3:
            return 'Nublado';
          case 45:
            return 'Niebla';
          case 48:
            return 'Niebla con escarcha';
          case 51:
            return 'Llovizna ligera';
          case 53:
            return 'Llovizna moderada';
          case 55:
            return 'Llovizna intensa';
          case 56:
            return 'Llovizna engelante ligera';
          case 57:
            return 'Llovizna engelante intensa';
          case 61:
            return 'Lluvia ligera';
          case 63:
            return 'Lluvia moderada';
          case 65:
            return 'Lluvia intensa';
          case 66:
            return 'Lluvia engelante ligera';
          case 67:
            return 'Lluvia engelante intensa';
          case 71:
            return 'Nevada ligera';
          case 73:
            return 'Nevada moderada';
          case 75:
            return 'Nevada intensa';
          case 77:
            return 'Granos de nieve';
          case 80:
            return 'Chubascos ligeros';
          case 81:
            return 'Chubascos moderados';
          case 82:
            return 'Chubascos violentos';
          case 85:
            return 'Chubascos de nieve ligeros';
          case 86:
            return 'Chubascos de nieve intensos';
          case 95:
            return 'Tormenta eléctrica';
          case 96:
            return 'Tormenta con granizo ligero';
          case 99:
            return 'Tormenta con granizo intenso';
          default:
            return 'Desconocido';
        }
      case 'fr':
        switch (weatherCode) {
          case 0:
            return 'Ciel dégagé';
          case 1:
            return 'Principalement dégagé';
          case 2:
            return 'Partiellement nuageux';
          case 3:
            return 'Couvert';
          case 45:
            return 'Brouillard';
          case 48:
            return 'Brouillard givrant';
          case 51:
            return 'Bruine légère';
          case 53:
            return 'Bruine modérée';
          case 55:
            return 'Bruine forte';
          case 56:
            return 'Bruine verglaçante légère';
          case 57:
            return 'Bruine verglaçante forte';
          case 61:
            return 'Pluie légère';
          case 63:
            return 'Pluie modérée';
          case 65:
            return 'Pluie forte';
          case 66:
            return 'Pluie verglaçante légère';
          case 67:
            return 'Pluie verglaçante forte';
          case 71:
            return 'Chute de neige légère';
          case 73:
            return 'Chute de neige modérée';
          case 75:
            return 'Chute de neige forte';
          case 77:
            return 'Neige en grains';
          case 80:
            return 'Averses de pluie légères';
          case 81:
            return 'Averses de pluie modérées';
          case 82:
            return 'Averses de pluie violentes';
          case 85:
            return 'Averses de neige légères';
          case 86:
            return 'Averses de neige fortes';
          case 95:
            return 'Orage';
          case 96:
            return 'Orage avec grêle légère';
          case 99:
            return 'Orage avec grêle forte';
          default:
            return 'Inconnu';
        }
      case 'it':
        switch (weatherCode) {
          case 0:
            return 'Cielo sereno';
          case 1:
            return 'Prevalentemente sereno';
          case 2:
            return 'Parzialmente nuvoloso';
          case 3:
            return 'Nuvoloso';
          case 45:
            return 'Nebbia';
          case 48:
            return 'Nebbia brinosa';
          case 51:
            return 'Pioviggine leggera';
          case 53:
            return 'Pioviggine moderata';
          case 55:
            return 'Pioviggine intensa';
          case 56:
            return 'Pioviggine gelata leggera';
          case 57:
            return 'Pioviggine gelata intensa';
          case 61:
            return 'Pioggia leggera';
          case 63:
            return 'Pioggia moderata';
          case 65:
            return 'Pioggia intensa';
          case 66:
            return 'Pioggia gelata leggera';
          case 67:
            return 'Pioggia gelata intensa';
          case 71:
            return 'Nevicata leggera';
          case 73:
            return 'Nevicata moderata';
          case 75:
            return 'Nevicata intensa';
          case 77:
            return 'Nevischio';
          case 80:
            return 'Rovesci leggeri';
          case 81:
            return 'Rovesci moderati';
          case 82:
            return 'Rovesci violenti';
          case 85:
            return 'Rovesci di neve leggeri';
          case 86:
            return 'Rovesci di neve intensi';
          case 95:
            return 'Temporale';
          case 96:
            return 'Temporale con grandine leggera';
          case 99:
            return 'Temporale con grandine intensa';
          default:
            return 'Sconosciuto';
        }
      case 'de':
        switch (weatherCode) {
          case 0:
            return 'Klarer Himmel';
          case 1:
            return 'Prächtig klar';
          case 2:
            return 'Teils bewölkt';
          case 3:
            return 'Bedeckt';
          case 45:
            return 'Nebel';
          case 48:
            return 'Reifnebel';
          case 51:
            return 'Leichter Sprühregen';
          case 53:
            return 'Mäßiger Sprühregen';
          case 55:
            return 'Starker Sprühregen';
          case 56:
            return 'Leichter gefrierender Sprühregen';
          case 57:
            return 'Starker gefrierender Sprühregen';
          case 61:
            return 'Leichter Regen';
          case 63:
            return 'Mäßiger Regen';
          case 65:
            return 'Starker Regen';
          case 66:
            return 'Leichter gefrierender Regen';
          case 67:
            return 'Starker gefrierender Regen';
          case 71:
            return 'Leichter Schneefall';
          case 73:
            return 'Mäßiger Schneefall';
          case 75:
            return 'Starker Schneefall';
          case 77:
            return 'Schneegriesel';
          case 80:
            return 'Leichte Regenschauer';
          case 81:
            return 'Mäßige Regenschauer';
          case 82:
            return 'Starke Regenschauer';
          case 85:
            return 'Leichte Schneeschauer';
          case 86:
            return 'Starke Schneeschauer';
          case 95:
            return 'Gewitter';
          case 96:
            return 'Gewitter mit leichtem Hagel';
          case 99:
            return 'Gewitter mit starkem Hagel';
          default:
            return 'Unbekannt';
        }
      case 'ru':
        switch (weatherCode) {
          case 0:
            return 'Ясно';
          case 1:
            return 'Преимущественно ясно';
          case 2:
            return 'Переменная облачность';
          case 3:
            return 'Пасмурно';
          case 45:
            return 'Туман';
          case 48:
            return 'Ледяной туман';
          case 51:
            return 'Легкая морось';
          case 53:
            return 'Умеренная морось';
          case 55:
            return 'Сильная морось';
          case 56:
            return 'Легкая замерзающая морось';
          case 57:
            return 'Сильная замерзающая морось';
          case 61:
            return 'Небольшой дождь';
          case 63:
            return 'Умеренный дождь';
          case 65:
            return 'Сильный дождь';
          case 66:
            return 'Легкий ледяной дождь';
          case 67:
            return 'Сильный ледяной дождь';
          case 71:
            return 'Небольшой снегопад';
          case 73:
            return 'Умеренный снегопад';
          case 75:
            return 'Сильный снегопад';
          case 77:
            return 'Снежная крупа';
          case 80:
            return 'Слабые ливни';
          case 81:
            return 'Умеренные ливни';
          case 82:
            return 'Сильные ливни';
          case 85:
            return 'Небольшие снежные ливни';
          case 86:
            return 'Сильные снежные ливни';
          case 95:
            return 'Гроза';
          case 96:
            return 'Гроза со слабым градом';
          case 99:
            return 'Гроза с сильным градом';
          default:
            return 'Неизвестно';
        }
      case 'pt':
        switch (weatherCode) {
          case 0:
            return 'Céu limpo';
          case 1:
            return 'Predominantemente limpo';
          case 2:
            return 'Parcialmente nublado';
          case 3:
            return 'Encoberto';
          case 45:
            return 'Nevoeiro';
          case 48:
            return 'Nevoeiro com geada';
          case 51:
            return 'Chuvisco leve';
          case 53:
            return 'Chuvisco moderado';
          case 55:
            return 'Chuvisco intenso';
          case 56:
            return 'Chuvisco congelante leve';
          case 57:
            return 'Chuvisco congelante intenso';
          case 61:
            return 'Chuva leve';
          case 63:
            return 'Chuva moderada';
          case 65:
            return 'Chuva intensa';
          case 66:
            return 'Chuva congelante leve';
          case 67:
            return 'Chuva congelante intensa';
          case 71:
            return 'Neve leve';
          case 73:
            return 'Neve moderada';
          case 75:
            return 'Neve intensa';
          case 77:
            return 'Granizo miúdo';
          case 80:
            return 'Aguaceiros leves';
          case 81:
            return 'Aguaceiros moderados';
          case 82:
            return 'Aguaceiros violentos';
          case 85:
            return 'Aguaceiros de neve leves';
          case 86:
            return 'Aguaceiros de neve intensos';
          case 95:
            return 'Trovoada';
          case 96:
            return 'Trovoada com granizo leve';
          case 99:
            return 'Trovoada com granizo intenso';
          default:
            return 'Desconhecido';
        }
      case 'ca':
        switch (weatherCode) {
          case 0:
            return 'Cel clar';
          case 1:
            return 'Majoritàriament clar';
          case 2:
            return 'Parcialment ennuvolat';
          case 3:
            return 'Ennuvolat';
          case 45:
            return 'Boira';
          case 48:
            return 'Boira amb trossos de glaç';
          case 51:
            return 'Boira menuda lleugera';
          case 53:
            return 'Boira menuda moderada';
          case 55:
            return 'Boira menuda intensa';
          case 56:
            return 'Boira menuda gelant lleugera';
          case 57:
            return 'Boira menuda gelant intensa';
          case 61:
            return 'Pluja lleugera';
          case 63:
            return 'Pluja moderada';
          case 65:
            return 'Pluja intensa';
          case 66:
            return 'Pluja gelant lleugera';
          case 67:
            return 'Pluja gelant intensa';
          case 71:
            return 'Nevada lleugera';
          case 73:
            return 'Nevada moderada';
          case 75:
            return 'Nevada intensa';
          case 77:
            return 'Grans de neu';
          case 80:
            return 'Ruixats lleugers';
          case 81:
            return 'Ruixats moderats';
          case 82:
            return 'Ruixats violents';
          case 85:
            return 'Ruixats de neu lleugers';
          case 86:
            return 'Ruixats de neu intensos';
          case 95:
            return 'Tempesta';
          case 96:
            return 'Tempesta amb granissa lleugera';
          case 99:
            return 'Tempesta amb granissa intensa';
          default:
            return 'Desconegut';
        }
      case 'he':
        switch (weatherCode) {
          case 0:
            return 'שמיים בהירים';
          case 1:
            return 'בהיר ברובו';
          case 2:
            return 'מעונן חלקית';
          case 3:
            return 'מעונן';
          case 45:
            return 'ערפל';
          case 48:
            return 'ערפל קופא';
          case 51:
            return 'טפטוף קל';
          case 53:
            return 'טפטוף מתון';
          case 55:
            return 'טפטוף כבד';
          case 56:
            return 'טפטוף קופא קל';
          case 57:
            return 'טפטוף קופא כבד';
          case 61:
            return 'גשם קל';
          case 63:
            return 'גשם מתון';
          case 65:
            return 'גשם כבד';
          case 66:
            return 'גשם קופא קל';
          case 67:
            return 'גשם קופא כבד';
          case 71:
            return 'שלг קל';
          case 73:
            return 'שלג מתון';
          case 75:
            return 'שלג כבד';
          case 77:
            return 'פתיתי שלג';
          case 80:
            return 'ממטרים קלים';
          case 81:
            return 'ממטרים מתונים';
          case 82:
            return 'ממטרים עזים';
          case 85:
            return 'ממטרי שלג קלים';
          case 86:
            return 'ממטרי שלג כבדים';
          case 95:
            return 'סופת רעמים';
          case 96:
            return 'סופת רעמים עם ברד קל';
          case 99:
            return 'סופת רעמים עם ברד כבד';
          default:
            return 'לא ידוע';
        }
      case 'uk':
        switch (weatherCode) {
          case 0:
            return 'Ясно';
          case 1:
            return 'Переважно ясно';
          case 2:
            return 'Мінлива хмарність';
          case 3:
            return 'Хмарно';
          case 45:
            return 'Туман';
          case 48:
            return 'Інійний туман';
          case 51:
            return 'Легка мжичка';
          case 53:
            return 'Помірна мжичка';
          case 55:
            return 'Сильна мжичка';
          case 56:
            return 'Легка замерзаюча мжичка';
          case 57:
            return 'Сильна замерзаюча мжичка';
          case 61:
            return 'Невеликий дощ';
          case 63:
            return 'Помірний дощ';
          case 65:
            return 'Сильний дощ';
          case 66:
            return 'Легкий крижаний дощ';
          case 67:
            return 'Сильний крижаний дощ';
          case 71:
            return 'Невеликий снігопад';
          case 73:
            return 'Помірний снігопад';
          case 75:
            return 'Сильний снігопад';
          case 77:
            return 'Сніжні зерна';
          case 80:
            return 'Слабкі зливи';
          case 81:
            return 'Помірні зливи';
          case 82:
            return 'Сильні зливи';
          case 85:
            return 'Невеликі снігові зливи';
          case 86:
            return 'Сильні снігові зливи';
          case 95:
            return 'Гроза';
          case 96:
            return 'Гроза з легким градом';
          case 99:
            return 'Гроза з сильним градом';
          default:
            return 'Невідомо';
        }
      case 'ar':
        switch (weatherCode) {
          case 0:
            return 'سماء صافية';
          case 1:
            return 'غالباً صافٍ';
          case 2:
            return 'غائم جزئياً';
          case 3:
            return 'غائم';
          case 45:
            return 'ضباب';
          case 48:
            return 'ضباب جليدي';
          case 51:
            return 'رذاذ خفيف';
          case 53:
            return 'رذاذ متوسط';
          case 55:
            return 'رذاذ كثيف';
          case 56:
            return 'رذاذ متجمد خفيف';
          case 57:
            return 'رذاذ متجمد كثيف';
          case 61:
            return 'مطر خفيف';
          case 63:
            return 'مطر متوسط';
          case 65:
            return 'مطر غزير';
          case 66:
            return 'مطر متجمد خفيف';
          case 67:
            return 'مطر متجمد غزير';
          case 71:
            return 'تساقط ثلوج خفيف';
          case 73:
            return 'تساقط ثلوج متوسط';
          case 75:
            return 'تساقط ثلوج كثيف';
          case 77:
            return 'حبيبات ثلجية';
          case 80:
            return 'زخات مطر خفيفة';
          case 81:
            return 'زخات مطر متوسطة';
          case 82:
            return 'زخات مطر عنيفة';
          case 85:
            return 'زخات ثلج خفيفة';
          case 86:
            return 'زخات ثلج كثيفة';
          case 95:
            return 'عاصفة رعدية';
          case 96:
            return 'عاصفة رعدية مع برد خفيف';
          case 99:
            return 'عاصفة رعدية مع برد كثيف';
          default:
            return 'غير معروف';
        }
      case 'zh':
        switch (weatherCode) {
          case 0:
            return '晴朗';
          case 1:
            return '大部晴朗';
          case 2:
            return '多云';
          case 3:
            return '阴天';
          case 45:
            return '雾';
          case 48:
            return '雾凇';
          case 51:
            return '小毛毛雨';
          case 53:
            return '毛毛雨';
          case 55:
            return '大毛毛雨';
          case 56:
            return '冻毛毛雨';
          case 57:
            return '密集冻毛毛雨';
          case 61:
            return '小雨';
          case 63:
            return '中雨';
          case 65:
            return '大雨';
          case 66:
            return '冻雨';
          case 67:
            return '大冻雨';
          case 71:
            return '小雪';
          case 73:
            return '中雪';
          case 75:
            return '大雪';
          case 77:
            return '雪粒';
          case 80:
            return '阵雨';
          case 81:
            return '中阵雨';
          case 82:
            return '暴阵雨';
          case 85:
            return '小阵雪';
          case 86:
            return '大阵雪';
          case 95:
            return '雷阵雨';
          case 96:
            return '雷阵雨伴有小冰雹';
          case 99:
            return '雷阵雨伴有大冰雹';
          default:
            return '未知';
        }
      case 'ko':
        switch (weatherCode) {
          case 0:
            return '맑음';
          case 1:
            return '대체로 맑음';
          case 2:
            return '구름 조금';
          case 3:
            return '흐림';
          case 45:
            return '안개';
          case 48:
            return '빙결 안개';
          case 51:
            return '약한 이슬비';
          case 53:
            return '보통 이슬비';
          case 55:
            return '강한 이슬비';
          case 56:
            return '약한 얼어붙는 이슬비';
          case 57:
            return '강한 얼어붙는 이슬비';
          case 61:
            return '약한 비';
          case 63:
            return '보통 비';
          case 65:
            return '강한 비';
          case 66:
            return '약한 얼어붙는 비';
          case 67:
            return '강한 얼어붙는 비';
          case 71:
            return '약한 눈';
          case 73:
            return '보통 눈';
          case 75:
            return '강한 눈';
          case 77:
            return '싸락눈';
          case 80:
            return '약한 소나기';
          case 81:
            return '보통 소나기';
          case 82:
            return '강한 소나기';
          case 85:
            return '약한 진눈깨비 소나기';
          case 86:
            return '강한 진눈깨비 소나기';
          case 95:
            return '뇌우';
          case 96:
            return '우박을 동반한 약한 뇌우';
          case 99:
            return '우박을 동반한 강한 뇌우';
          default:
            return '알 수 없음';
        }
      case 'ja':
        switch (weatherCode) {
          case 0:
            return '快晴';
          case 1:
            return '晴れ';
          case 2:
            return 'くもり';
          case 3:
            return '厚い雲';
          case 45:
            return '霧';
          case 48:
            return '着氷性の霧';
          case 51:
            return '弱い霧雨';
          case 53:
            return '霧雨';
          case 55:
            return '強い霧雨';
          case 56:
            return '弱い着氷性の霧雨';
          case 57:
            return '強い着氷性の霧雨';
          case 61:
            return '小雨';
          case 63:
            return '雨';
          case 65:
            return '大雨';
          case 66:
            return '弱い着氷性の雨';
          case 67:
            return '強い着氷性の雨';
          case 71:
            return '小雪';
          case 73:
            return '雪';
          case 75:
            return '大雪';
          case 77:
            return '霧雪';
          case 80:
            return '弱いにわか雨';
          case 81:
            return 'にわか雨';
          case 82:
            return '激しいにわか雨';
          case 85:
            return '弱いにわか雪';
          case 86:
            return '激しいにわか雪';
          case 95:
            return '雷雨';
          case 96:
            return 'ひょうを伴う弱い雷雨';
          case 99:
            return 'ひょうを伴う激しい雷雨';
          default:
            return '不明';
        }
      default:
        switch (weatherCode) {
          case 0:
            return 'Clear sky';
          case 1:
            return 'Mainly clear';
          case 2:
            return 'Partly cloudy';
          case 3:
            return 'Overcast';
          case 45:
            return 'Fog';
          case 48:
            return 'Icy fog';
          case 51:
            return 'Light drizzle';
          case 53:
            return 'Moderate drizzle';
          case 55:
            return 'Heavy drizzle';
          case 56:
            return 'Light freezing drizzle';
          case 57:
            return 'Heavy freezing drizzle';
          case 61:
            return 'Light rain';
          case 63:
            return 'Moderate rain';
          case 65:
            return 'Heavy rain';
          case 66:
            return 'Light freezing rain';
          case 67:
            return 'Heavy freezing rain';
          case 71:
            return 'Light snowfall';
          case 73:
            return 'Moderate snowfall';
          case 75:
            return 'Heavy snowfall';
          case 77:
            return 'Snow grains';
          case 80:
            return 'Light showers';
          case 81:
            return 'Moderate showers';
          case 82:
            return 'Violent showers';
          case 85:
            return 'Light snow showers';
          case 86:
            return 'Heavy snow showers';
          case 95:
            return 'Thunderstorm';
          case 96:
            return 'Thunderstorm with light hail';
          case 99:
            return 'Thunderstorm with heavy hail';
          default:
            return 'Unknown';
        }
    }
  }

  static String stringSunrise(String idioma) {
    if (idioma == 'es') return 'Amanecer🌅';
    if (idioma == 'fr') return 'Lever du soleil🌅';
    if (idioma == 'it') return 'Alba🌅';
    if (idioma == 'de') return 'Sonnenaufgang🌅';
    if (idioma == 'ru') return 'Восход🌅';
    if (idioma == 'pt') return 'Nascer do sol🌅';
    if (idioma == 'ca') return 'Alba🌅';
    if (idioma == 'he') return 'זריחה🌅';
    if (idioma == 'uk') return 'Схід сонця🌅';
    if (idioma == 'ar') return 'شروق الشمس🌅';
    if (idioma == 'zh') return '日出🌅';
    if (idioma == 'ko') return '일출🌅';
    if (idioma == 'ja') return '日の出🌅';
    return 'Sunrise🌅';
  }

  static String stringSunset(String idioma) {
    if (idioma == 'es') return 'Anochecer🌄';
    if (idioma == 'fr') return 'Coucher du soleil🌄';
    if (idioma == 'it') return 'Tramonto🌄';
    if (idioma == 'de') return 'Sonnenuntergang🌄';
    if (idioma == 'ru') return 'Закат🌄';
    if (idioma == 'pt') return 'Pôr do sol🌄';
    if (idioma == 'ca') return 'Posta de sol🌄';
    if (idioma == 'he') return 'שקיעה🌄';
    if (idioma == 'uk') return 'Захід сонця🌄';
    if (idioma == 'ar') return 'غروب الشمس🌄';
    if (idioma == 'zh') return '日落🌄';
    if (idioma == 'ko') return '일몰🌄';
    if (idioma == 'ja') return '日の入り🌄';
    return 'Sunset🌄';
  }

  static String stringWind(String idioma) {
    if (idioma == 'es') return 'Viento🍃';
    if (idioma == 'fr') return 'Vent🍃';
    if (idioma == 'it') return 'Vento🍃';
    if (idioma == 'de') return 'Wind🍃';
    if (idioma == 'ru') return 'Ветер🍃';
    if (idioma == 'pt') return 'Vento🍃';
    if (idioma == 'ca') return 'Vent🍃';
    if (idioma == 'he') return 'רוח🍃';
    if (idioma == 'uk') return 'Вітер🍃';
    if (idioma == 'ar') return 'الرياح🍃';
    if (idioma == 'zh') return '风速🍃';
    if (idioma == 'ko') return '바람🍃';
    if (idioma == 'ja') return '風🍃';
    return 'Wind🍃';
  }

  static String stringMaxGust(String idioma) {
    if (idioma == 'es') return 'Rachas máximas de viento🪁';
    if (idioma == 'fr') return 'Rafales de vent maximales🪁';
    if (idioma == 'it') return 'Raffiche di vento massime🪁';
    if (idioma == 'de') return 'Maximale Windböen🪁';
    if (idioma == 'ru') return 'Макс. порывы ветра🪁';
    if (idioma == 'pt') return 'Rajadas máximas de vento🪁';
    if (idioma == 'ca') return 'Ràfegues màximes de vent🪁';
    if (idioma == 'he') return 'משבי רוח מרביים🪁';
    if (idioma == 'uk') return 'Макс. пориви вітру🪁';
    if (idioma == 'ar') return 'هبات الرياح القصوى🪁';
    if (idioma == 'zh') return '最大阵风🪁';
    if (idioma == 'ko') return '최대 돌풍🪁';
    if (idioma == 'ja') return '最大瞬間風速🪁';
    return 'Max wind gusts🪁';
  }

  static String stringWindOrientation(String idioma) {
    if (idioma == 'es') return 'Orientación del viento🧭';
    if (idioma == 'fr') return 'Direction du vent🧭';
    if (idioma == 'it') return 'Direzione del vento🧭';
    if (idioma == 'de') return 'Windrichtung🧭';
    if (idioma == 'ru') return 'Направление ветра🧭';
    if (idioma == 'pt') return 'Orientação do vento🧭';
    if (idioma == 'ca') return 'Orientació del vent🧭';
    if (idioma == 'he') return 'כיוון הרוח🧭';
    if (idioma == 'uk') return 'Напрямок вітру🧭';
    if (idioma == 'ar') return 'اتجاه الرياح🧭';
    if (idioma == 'zh') return '风向🧭';
    if (idioma == 'ko') return '풍향🧭';
    if (idioma == 'ja') return '风向🧭';
    return 'Wind orientation🧭';
  }

  static String stringNubosity(String idioma) {
    if (idioma == 'es') return 'Nubosidad☁️';
    if (idioma == 'fr') return 'Nébulosité☁️';
    if (idioma == 'it') return 'Nuvolosità☁️';
    if (idioma == 'de') return 'Bewölkung☁️';
    if (idioma == 'ru') return 'Облачность☁️';
    if (idioma == 'pt') return 'Nebulosidade☁️';
    if (idioma == 'ca') return 'Nuvolositat☁️';
    if (idioma == 'he') return 'עננות☁️';
    if (idioma == 'uk') return 'Хмарність☁️';
    if (idioma == 'ar') return 'الغيوم☁️';
    if (idioma == 'zh') return '云量☁️';
    if (idioma == 'ko') return '운량☁️';
    if (idioma == 'ja') return '雲量☁️';
    return 'Cloudiness☁️';
  }

  static String stringHumidity(String idioma) {
    if (idioma == 'es') return 'Humedad💧';
    if (idioma == 'fr') return 'Humidité💧';
    if (idioma == 'it') return 'Umidità💧';
    if (idioma == 'de') return 'Luftfeuchtigkeit💧';
    if (idioma == 'ru') return 'Влажность💧';
    if (idioma == 'pt') return 'Humidade💧';
    if (idioma == 'ca') return 'Humitat💧';
    if (idioma == 'he') return 'לחות💧';
    if (idioma == 'uk') return 'Вологість💧';
    if (idioma == 'ar') return 'الرطوبة💧';
    if (idioma == 'zh') return '湿度💧';
    if (idioma == 'ko') return '습도💧';
    if (idioma == 'ja') return '湿度💧';
    return 'Humidity💧';
  }

  static String stringVisibility(String idioma) {
    if (idioma == 'es') return 'Visibilidad👁️';
    if (idioma == 'fr') return 'Visibilité👁️';
    if (idioma == 'it') return 'Visibilità👁️';
    if (idioma == 'de') return 'Sichtweite👁️';
    if (idioma == 'ru') return 'Видимость👁️';
    if (idioma == 'pt') return 'Visibilidade👁️';
    if (idioma == 'ca') return 'Visibilitat👁️';
    if (idioma == 'he') return 'ראות👁️';
    if (idioma == 'uk') return 'Видимість👁️';
    if (idioma == 'ar') return 'الرؤية👁️';
    if (idioma == 'zh') return '能见度👁️';
    if (idioma == 'ko') return '시정👁️';
    if (idioma == 'ja') return '视程👁️';
    return 'Visibility👁️';
  }

  static String stringPressure(String idioma) {
    if (idioma == 'es') return 'Presión atmosférica🌍';
    if (idioma == 'fr') return 'Pression atmosphérique🌍';
    if (idioma == 'it') return 'Pressione atmosferica🌍';
    if (idioma == 'de') return 'Luftdruck🌍';
    if (idioma == 'ru') return 'Атм. давление🌍';
    if (idioma == 'pt') return 'Pressão atmosférica🌍';
    if (idioma == 'ca') return 'Pressió atmosfèrica🌍';
    if (idioma == 'he') return 'לחץ אטמוספרי🌍';
    if (idioma == 'uk') return 'Атмосферний тиск🌍';
    if (idioma == 'ar') return 'الضغط الجوي🌍';
    if (idioma == 'zh') return '气压🌍';
    if (idioma == 'ko') return '기압🌍';
    if (idioma == 'ja') return '気圧🌍';
    return 'Atmospheric pressure🌍';
  }

  static String stringFeelsLike(String idioma) {
    if (idioma == 'es') return 'Sensación térmica:';
    if (idioma == 'fr') return 'Température ressentie :';
    if (idioma == 'it') return 'Percepita:';
    if (idioma == 'de') return 'Gefühlt:';
    if (idioma == 'ru') return 'Ощущается как:';
    if (idioma == 'pt') return 'Sensação térmica:';
    if (idioma == 'ca') return 'Sensació tèrmica:';
    if (idioma == 'he') return 'מרגיש כמו:';
    if (idioma == 'uk') return 'Відчувається як:';
    if (idioma == 'ar') return 'الحرارة المحسوسة:';
    if (idioma == 'zh') return '体感温度：';
    if (idioma == 'ko') return '체감 온도:';
    if (idioma == 'ja') return '体感温度:';
    return 'Feels like:';
  }

  static String stringAmountOfRainSnow(String idioma) {
    if (idioma == 'es') return 'Cantidad de precipitación/nieve🌧️❄️';
    if (idioma == 'fr') return 'Quantité de précipitation/neige🌧️❄️';
    if (idioma == 'it') return 'Quantità di precipitazione/neve🌧️❄️';
    if (idioma == 'de') return 'Niederschlags-/Schneemenge🌧️❄️';
    if (idioma == 'ru') return 'Количество осадков/снега🌧️❄️';
    if (idioma == 'pt') return 'Quantidade de precipitação/neve🌧️❄️';
    if (idioma == 'ca') return 'Quantitat de precipitació/neu🌧️❄️';
    if (idioma == 'he') return 'כמות משקעים/שלג🌧️❄️';
    if (idioma == 'uk') return 'Кількість осадків/снігу🌧️❄️';
    if (idioma == 'ar') return 'كمية الأمطار/الثلوج🌧️❄️';
    if (idioma == 'zh') return '降水量/降雪量🌧️❄️';
    if (idioma == 'ko') return '강수량/강설량🌧️❄️';
    if (idioma == 'ja') return '降水量/降雪量🌧️❄️';
    return 'Amount of rain/snow🌧️❄️';
  }

  static String stringMaxWindSpeed(String idioma) {
    if (idioma == 'es') return 'Velocidad de viento máxima🍃';
    if (idioma == 'fr') return 'Vitesse maximale du vent🍃';
    if (idioma == 'it') return 'Velocità massima del vento🍃';
    if (idioma == 'de') return 'Maximale Windgeschwindigkeit🍃';
    if (idioma == 'ru') return 'Макс. скорость ветра🍃';
    if (idioma == 'pt') return 'Velocidade máxima do vento🍃';
    if (idioma == 'ca') return 'Velocitat màxima del vent🍃';
    if (idioma == 'he') return 'מהירות רוח מרבית🍃';
    if (idioma == 'uk') return 'Максимальна швидкість вітру🍃';
    if (idioma == 'ar') return 'سرعة الرياح القصوى🍃';
    if (idioma == 'zh') return '最大风速🍃';
    if (idioma == 'ko') return '최대 풍속🍃';
    if (idioma == 'ja') return '最大风速🍃';
    return 'Max wind speed🍃';
  }

  static String stringOf(String idioma) {
    if (idioma == 'es') return 'de';
    if (idioma == 'fr') return 'de';
    if (idioma == 'it') return 'di';
    if (idioma == 'pt') return 'de';
    if (idioma == 'ca') return 'de';
    return '';
  }

  static String stringLicenses(String idioma) {
    if (idioma == 'es') return 'Licencias de software';
    if (idioma == 'fr') return 'Licences de logiciel';
    if (idioma == 'it') return 'Licenze software';
    if (idioma == 'de') return 'Software-Lizenzen';
    if (idioma == 'ru') return 'Лицензии ПО';
    if (idioma == 'pt') return 'Licenças de software';
    if (idioma == 'ca') return 'Llicències de programari';
    if (idioma == 'he') return 'רישיונות תוכנה';
    if (idioma == 'uk') return 'Ліцензії ПЗ';
    if (idioma == 'ar') return 'تراخيص البرمجيات';
    if (idioma == 'zh') return '软件许可';
    if (idioma == 'ko') return '소프트웨어 라이선스';
    if (idioma == 'ja') return 'ソフトウェアライセンス';
    return 'Software licenses';
  }

  static String stringWelcome(String idioma) {
    if (idioma == 'es') return '¡Bienvenido a ManuleWeather!';
    if (idioma == 'fr') return 'Bienvenue sur ManuleWeather !';
    if (idioma == 'it') return 'Benvenuto su ManuleWeather!';
    if (idioma == 'de') return 'Willkommen bei ManuleWeather!';
    if (idioma == 'ru') return 'Добро пожаловать в ManuleWeather!';
    if (idioma == 'pt') return 'Bem-vindo ao ManuleWeather!';
    if (idioma == 'ca') return 'Benvingut a ManuleWeather!';
    if (idioma == 'he') return 'ברוכים הבאים ל-ManuleWeather!';
    if (idioma == 'uk') return 'Ласкаво просимо до ManuleWeather!';
    if (idioma == 'ar') return 'مرحباً بك في ManuleWeather!';
    if (idioma == 'zh') return '欢迎使用 ManuleWeather!';
    if (idioma == 'ko') return 'ManuleWeather에 오신 것을 환영합니다!';
    if (idioma == 'ja') return 'ManuleWeatherへようこそ！';
    return 'Welcome to ManuleWeather!';
  }

  static String stringConfiguration(String idioma) {
    if (idioma == 'es') return 'Configuración';
    if (idioma == 'fr') return 'Paramètres';
    if (idioma == 'it') return 'Impostazioni';
    if (idioma == 'de') return 'Einstellungen';
    if (idioma == 'ru') return 'Настройки';
    if (idioma == 'pt') return 'Configurações';
    if (idioma == 'ca') return 'Configuració';
    if (idioma == 'he') return 'הגדרות';
    if (idioma == 'uk') return 'Налаштування';
    if (idioma == 'ar') return 'الإعدادات';
    if (idioma == 'zh') return '设置';
    if (idioma == 'ko') return '설정';
    if (idioma == 'ja') return '設定';
    return 'Settings';
  }

  static String stringHome(String idioma) {
    if (idioma == 'es') return 'Inicio';
    if (idioma == 'fr') return 'Accueil';
    if (idioma == 'it') return 'Home';
    if (idioma == 'de') return 'Startseite';
    if (idioma == 'ru') return 'Главная';
    if (idioma == 'pt') return 'Início';
    if (idioma == 'ca') return 'Inici';
    if (idioma == 'he') return 'מסך הבית';
    if (idioma == 'uk') return 'Головна';
    if (idioma == 'ar') return 'الرئيسية';
    if (idioma == 'zh') return '首页';
    if (idioma == 'ko') return '홈';
    if (idioma == 'ja') return 'ホーム';
    return 'Home';
  }

  static String stringDaily(String idioma) {
    if (idioma == 'es') return 'Por días';
    if (idioma == 'fr') return 'Par jour';
    if (idioma == 'it') return 'Giornaliero';
    if (idioma == 'de') return 'Täglich';
    if (idioma == 'ru') return 'По дням';
    if (idioma == 'pt') return 'Por dias';
    if (idioma == 'ca') return 'Per dies';
    if (idioma == 'he') return 'יומי';
    if (idioma == 'uk') return 'По днях';
    if (idioma == 'ar') return 'يومي';
    if (idioma == 'zh') return '按天';
    if (idioma == 'ko') return '일별';
    if (idioma == 'ja') return '日別';
    return 'Daily';
  }

  static String stringHourly(String idioma) {
    if (idioma == 'es') return 'Por horas';
    if (idioma == 'fr') return 'Par heure';
    if (idioma == 'it') return 'Orario';
    if (idioma == 'de') return 'Stündlich';
    if (idioma == 'ru') return 'По часам';
    if (idioma == 'pt') return 'Por horas';
    if (idioma == 'ca') return 'Per hores';
    if (idioma == 'he') return 'שעתי';
    if (idioma == 'uk') return 'По годинах';
    if (idioma == 'ar') return 'ساعتي';
    if (idioma == 'zh') return '按小时';
    if (idioma == 'ko') return '시간별';
    if (idioma == 'ja') return '時間別';
    return 'Hourly';
  }

  static String? stringInputSearch(String idioma) {
    if (idioma == 'es') return 'Busque un lugar';
    if (idioma == 'fr') return 'Rechercher un lieu';
    if (idioma == 'it') return 'Cerca un luogo';
    if (idioma == 'de') return 'Ort suchen';
    if (idioma == 'ru') return 'Поиск места';
    if (idioma == 'pt') return 'Buscar um lugar';
    if (idioma == 'ca') return 'Cerca un lloc';
    if (idioma == 'he') return 'חפש מקום';
    if (idioma == 'uk') return 'Пошук місця';
    if (idioma == 'ar') return 'ابحث عن مكان';
    if (idioma == 'zh') return '搜索地点';
    if (idioma == 'ko') return '위치 검색';
    if (idioma == 'ja') return '場所を検索';
    return 'Search for a place';
  }

  static String stringCurrentLocation(String idioma) {
    if (idioma == 'es') return 'Ubicación actual';
    if (idioma == 'fr') return 'Position actuelle';
    if (idioma == 'it') return 'Posizione attuale';
    if (idioma == 'de') return 'Aktueller Standort';
    if (idioma == 'ru') return 'Текущее местоположение';
    if (idioma == 'pt') return 'Localização atual';
    if (idioma == 'ca') return 'Ubicació actual';
    if (idioma == 'he') return 'מיקום נוכחי';
    if (idioma == 'uk') return 'Поточне місцезнаходження';
    if (idioma == 'ar') return 'الموقع الحالي';
    if (idioma == 'zh') return '当前位置';
    if (idioma == 'ko') return '현재 위치';
    if (idioma == 'ja') return '現在地';
    return 'Current location';
  }

  static String stringObtainingLocation(String idioma) {
    if (idioma == 'es') return 'Obteniendo ubicación...';
    if (idioma == 'fr') return 'Obtention de la position...';
    if (idioma == 'it') return 'Ottenimento della posizione...';
    if (idioma == 'de') return 'Standort wird ermittelt...';
    if (idioma == 'ru') return 'Получение местоположения...';
    if (idioma == 'pt') return 'Obtendo localização...';
    if (idioma == 'ca') return 'Obtenint ubicació...';
    if (idioma == 'he') return 'מזהה מיקום...';
    if (idioma == 'uk') return 'Визначення місцезнаходження...';
    if (idioma == 'ar') return 'جاري تحديد الموقع...';
    if (idioma == 'zh') return '正在获取位置...';
    if (idioma == 'ko') return '위치 가져오는 중...';
    if (idioma == 'ja') return '位置情報を取得中...';
    return 'Obtaining location...';
  }

  static String stringChooseLanguageOnboardingText(String idioma) {
    if (idioma == 'es') return 'Elige tu idioma para continuar';
    if (idioma == 'fr') return 'Choisissez votre langue pour continuer';
    if (idioma == 'it') return 'Scegli la tua lingua per continuare';
    if (idioma == 'de') return 'Wählen Sie Ihre Sprache, um fortzufahren';
    if (idioma == 'ru') return 'Выберите язык, чтобы продолжить';
    if (idioma == 'pt') return 'Escolha o seu idioma para continuar';
    if (idioma == 'ca') return 'Tria el teu idioma per continuar';
    if (idioma == 'he') return 'בחר שפה כדי להמשיך';
    if (idioma == 'uk') return 'Виберіть мову, щоб продовжити';
    if (idioma == 'ar') return 'اختر لغتك للمتابعة';
    if (idioma == 'zh') return '选择语言以继续';
    if (idioma == 'ko') return '계속하려면 언어를 선택하세요';
    if (idioma == 'ja') return '続行するには言語を選択してください';
    return 'Choose your language to proceed';
  }

  static String obtenerIdiomaText(String idioma) {
    if (idioma == 'es') return 'Español';
    if (idioma == 'fr') return 'Français';
    if (idioma == 'it') return 'Italiano';
    if (idioma == 'de') return 'Deutsch';
    if (idioma == 'ru') return 'Русский';
    if (idioma == 'pt') return 'Português';
    if (idioma == 'ca') return 'Català';
    if (idioma == 'he') return 'עברית';
    if (idioma == 'uk') return 'Українська';
    if (idioma == 'ar') return 'العربية';
    if (idioma == 'zh') return '简体中文';
    if (idioma == 'ko') return '한국어';
    if (idioma == 'ja') return '日本語';
    return 'English';
  }

  static String stringLanguagesSettings(String idioma) {
    if (idioma == 'es') return 'Idioma de la app';
    if (idioma == 'fr') return 'Langue de l\'application';
    if (idioma == 'it') return 'Lingua dell\'app';
    if (idioma == 'de') return 'App-Sprache';
    if (idioma == 'ru') return 'Язык приложения';
    if (idioma == 'pt') return 'Idioma do app';
    if (idioma == 'ca') return 'Idioma de l\'app';
    if (idioma == 'he') return 'שפת האפליקציה';
    if (idioma == 'uk') return 'Язова оболонка';
    if (idioma == 'ar') return 'لغة التطبيق';
    if (idioma == 'zh') return '应用语言';
    if (idioma == 'ko') return '앱 언어';
    if (idioma == 'ja') return 'アプリの言語';
    return 'App language';
  }

  static String stringChooseLanguageText(String idioma) {
    if (idioma == 'es') return 'Elige el idioma (algunos pueden tener errores)';
    if (idioma == 'fr')
      return 'Choisissez la langue (certaines peuvent contenir des erreurs)';
    if (idioma == 'it')
      return 'Scegli la lingua (alcune potrebbero contenere errori)';
    if (idioma == 'de')
      return 'Sprache auswählen (einige können Fehler enthalten)';
    if (idioma == 'ru')
      return 'Выберите язык (некоторые могут содержать ошибки)';
    if (idioma == 'pt') return 'Escolha o idioma (alguns podem conter erros)';
    if (idioma == 'ca') return 'Tria l\'idioma (alguns poden tindre errades)';
    if (idioma == 'he') return '(בחר שפה (חלקן עשויות להכיל שגיאות';
    if (idioma == 'uk') return 'Оберіть мову (деякі можуть містити помилки)';
    if (idioma == 'ar') return 'اختر اللغة (قد تحتوي بعضها على أخطاء)';
    if (idioma == 'zh') return '选择语言（部分语言可能存在错误）'; // Chino Mandarín
    if (idioma == 'ko') return '언어 선택 (일부 언어에 오류가 있을 수 있습니다)';
    if (idioma == 'ja') return '言語を選択 (일부 언어에 오류가 있을 수 있습니다)';
    return 'Choose the language (some may contain errors)';
  }

  static String stringUpdatedAt(String idioma) {
    if (idioma == 'es') return 'Última actualización (hora local):';
    if (idioma == 'fr') return 'Dernière mise à jour (heure locale) :';
    if (idioma == 'it') return 'Ultimo aggiornamento (ora locale):';
    if (idioma == 'de') return 'Letzte Aktualisierung (Ortszeit):';
    if (idioma == 'ru') return 'Последнее обновление (местное время):';
    if (idioma == 'pt') return 'Última atualização (hora local):';
    if (idioma == 'ca') return 'Última actualització (hora local):';
    if (idioma == 'he') return 'עדכון אחרון (זמן מקומי):';
    if (idioma == 'uk') return 'Останнє оновлення (місцевий час):';
    if (idioma == 'ar') return 'آخر تحديث (بالتوقيت المحلي):';
    if (idioma == 'zh') return '最后更新（当地时间）：';
    if (idioma == 'ko') return '최근 업데이트 (현지 시간):';
    if (idioma == 'ja') return '最終更新（現地時間）:';
    return 'Last update (local time):';
  }

  static String stringErrorServerDown(String idioma) {
    if (idioma == 'es')
      return 'EL SERVICIO CLIMÁTICO SE ENCUENTRA CAIDO EN ESTOS MOMENTOS, SENTIMOS LAS MOLESTIAS :(';
    if (idioma == 'fr')
      return 'LE SERVICE MÉTÉOROLOGIQUE EST ACTUELLEMENT INDISPONIBLE, DÉSOLÉ POUR LE DÉRANGEMENT :(';
    if (idioma == 'it')
      return 'IL SERVIZIO METEOROLOGICO È ATTUALMENTE NON DISPONIBILE, CI SCUSIAMO PER IL DISAGIO :(';
    if (idioma == 'de')
      return 'DER WETTERDIENST IST ZURZEIT NICHT VERFÜGBAR, WIR ENTSCHULDIGEN UNS FÜR DIE UNANNEHMLICHKEITEN :(';
    if (idioma == 'ru')
      return 'МЕТЕОРОЛОГИЧЕСКАЯ СЛУЖБА СЕЙЧАС НЕДОСТУПНА, ПРИНОСИМ СВОИ ИСКРЕННИЕ ИЗВИНЕНИЯ :(';
    if (idioma == 'pt')
      return 'O SERVIÇO METEOROLÓGICO ESTÁ INDISPONÍVEL NO MOMENTO, DESCULPE PELO TRANSTORNO :(';
    if (idioma == 'ca')
      return 'EL SERVEI METEOROLÒGIC ESTÀ CAIGUT EN AQUESTS MOMENTS, SENTIM LES MOLESTIES :(';
    if (idioma == 'he')
      return 'שירות מזג האוויר אינו זמין כעת, אנו מתנצלים על האי-נוחות :(';
    if (idioma == 'uk')
      return 'МЕТЕОРОЛОГІЧНА СЛУЖБА НАРАЗІ НЕДОСТУПНА, ВИБАЧТЕ ЗА НЕЗРУЧНОСТІ :(';
    if (idioma == 'ar')
      return 'خدمة الطقس غير متوفرة حالياً، نعتذر عن الإزعاج :(';
    if (idioma == 'zh') return '气象服务目前无法使用，给您带来不便敬请谅解 :(';
    if (idioma == 'ko') return '기상 서비스가 현재 중단되었습니다. 불편을 드려 죄송합니다 :(';
    if (idioma == 'ja') return '気象サービスは現在ご利用いただけません。ご不便をおかけして申し訳ありません :(';
    return 'THE CLIMATIC SERVICE IS CURRENTLY UNAVAILABLE RIGHT NOW, SORRY FOR INCONVENIENCE :(';
  }

  static String stringErrorNoUbiPermission(String idioma) {
    if (idioma == 'es')
      return 'NO PUEDES UTILIZAR LA APP SIN EL PERMISO DE UBICACIÓN ACTIVADO, SENTIMOS LAS MOLESTIAS :(';
    if (idioma == 'fr')
      return 'VOUS NE POUVEZ PAS UTILISER L\'APPLICATION SANS ACTIVER L\'AUTORISATION DE LOCALISATION, DÉSOLÉ POUR LE DÉRANGEMENT :(';
    if (idioma == 'it')
      return 'NON PUOI UTILIZZARE L\'APP SENZA ATTIVARE L\'AUTORIZZAZIONE ALLA POSIZIONE, CI SCUSIAMO PER IL DISAGIO :(';
    if (idioma == 'de')
      return 'SIE KÖNNEN DIE APP NICHT OHNE DIE AKTIVIERTE STANDORTBERECHTIGUNG NUTZEN, WIR ENTSCHULDIGEN UNS FÜR DIE UNANNEHMLICHKEITEN :(';
    if (idioma == 'ru')
      return 'ВЫ НЕ МОЖЕТЕ ИСПОЛЬЗОВАТЬ ПРИЛОЖЕНИЕ БЕЗ РАЗРЕШЕНИЯ НА ДОСТУП К ГЕОПОЗИЦИИ, ПРИНОСИМ ИЗВИНЕНИЯ :(';
    if (idioma == 'pt')
      return 'VOCÊ NÃO PODE USAR O APP SEM A PERMISSÃO DE LOCALIZAÇÃO ATIVADA, DESCULPE PELO TRANSTORNO :(';
    if (idioma == 'ca')
      return 'NO POTS UTILITZAR L\'APP SENSE EL PERMÍS D\'UBICACIÓ ACTIVAT, SENTIM LES MOLESTIES :(';
    if (idioma == 'he')
      return 'לא ניתן להשתמש באפליקציה ללא אישור מיקום פעיל, אנו מתנצלים על האי-נוחות :(';
    if (idioma == 'uk')
      return 'ВИ НЕ МОЖЕТЕ КОРИСТУВАТИСЯ ДОДАТКОМ БЕЗ ДОЗВОЛУ НА ГЕОЛОКАЦІЮ, ВИБАЧТЕ ЗА НЕЗРУЧНОСТІ :(';
    if (idioma == 'ar')
      return 'لا يمكنك استخدام التطبيق دون تفعيل إذن الوصول إلى الموقع، نعتذر عن الإزعاج :(';
    if (idioma == 'zh') return '若未开启定位权限，您将无法使用此应用，给您带来不便敬请谅解 :(';
    if (idioma == 'ko') return '위치 권한을 허용하지 않으면 앱을 사용할 수 없습니다. 불편을 드려 죄송합니다 :(';
    if (idioma == 'ja')
      return '位置情報の権限を有効にしないとアプリを使用できません。ご不便をおかけして申し訳ありません :(';
    return 'YOU CANNOT USE THE APP WITHOUT THE LOCATION PERMISSION ENABLED, SORRY FOR INCONVENIENCE :(';
  }

  static String stringShowDetails(String idioma) {
    if (idioma == 'es') return 'Ver detalles';
    if (idioma == 'fr') return 'Voir les détails';
    if (idioma == 'it') return 'Mostra dettagli';
    if (idioma == 'de') return 'Details anzeigen';
    if (idioma == 'ru') return 'Подробнее';
    if (idioma == 'pt') return 'Ver detalhes';
    if (idioma == 'ca') return 'Veure detalls';
    if (idioma == 'he') return 'הצג פרטים';
    if (idioma == 'uk') return 'Детальніше';
    if (idioma == 'ar') return 'عرض التفاصيل';
    if (idioma == 'zh') return '查看详情';
    if (idioma == 'ko') return '자세히 보기';
    if (idioma == 'ja') return '詳細を表示';
    return 'Show details';
  }

  static String stringAt(String idioma) {
    if (idioma == 'es') return 'a las';
    if (idioma == 'fr') return 'à';
    if (idioma == 'it') return 'alle';
    if (idioma == 'de') return 'um';
    if (idioma == 'ru') return 'в';
    if (idioma == 'pt') return 'às';
    if (idioma == 'ca') return 'a les';
    if (idioma == 'he') return 'בשעה';
    if (idioma == 'uk') return 'о';
    if (idioma == 'ar') return 'في تمام الساعة';
    if (idioma == 'zh') return '在';
    if (idioma == 'ko') return '에';
    if (idioma == 'ja') return 'に';
    return 'at';
  }

  static String stringUVRays(String idioma) {
    if (idioma == 'es') return 'Índice de rayos uva☀️';
    if (idioma == 'fr') return 'Indice UV☀️';
    if (idioma == 'it') return 'Indice UV☀️';
    if (idioma == 'de') return 'UV-Index☀️';
    if (idioma == 'ru') return 'УФ-индекс☀️';
    if (idioma == 'pt') return 'Índice UV☀️';
    if (idioma == 'ca') return 'Índex ultraviolat☀️';
    if (idioma == 'he') return 'מדד קרינת UV☀️';
    if (idioma == 'uk') return 'УФ-індекс☀️';
    if (idioma == 'ar') return 'مؤشر الأشعة فوق البنفسجية☀️';
    if (idioma == 'zh') return '紫外线指数☀️';
    if (idioma == 'ko') return '자외선 지수☀️';
    if (idioma == 'ja') return '紫外線指数☀️';
    return 'UV Level☀️';
  }

  static String stringUVRaysScreen(String idioma) {
    if (idioma == 'es') return 'Rayos uva';
    if (idioma == 'fr') return 'Rayons UV';
    if (idioma == 'it') return 'Raggi UV';
    if (idioma == 'de') return 'UV-Strahlen';
    if (idioma == 'ru') return 'УФ-лучи';
    if (idioma == 'pt') return 'Raios UV';
    if (idioma == 'ca') return 'Rigs ultraviolats';
    if (idioma == 'he') return 'קרינת UV';
    if (idioma == 'uk') return 'УФ-промені';
    if (idioma == 'ar') return 'الأشعة فوق البنفسجية';
    if (idioma == 'zh') return '紫外线';
    if (idioma == 'ko') return '자외선';
    if (idioma == 'ja') return '紫外線';
    return 'UV Rays';
  }

  static String stringUvLevel(int uv, String idioma) {
    switch (idioma) {
      case 'es':
        if (uv <= 2) return 'Bajo';
        if (uv <= 5) return 'Moderado';
        if (uv <= 7) return 'Alto';
        if (uv <= 10) return 'Muy alto';
        return 'Extremo';
      case 'fr':
        if (uv <= 2) return 'Bas';
        if (uv <= 5) return 'Modéré';
        if (uv <= 7) return 'Élevé';
        if (uv <= 10) return 'Très élevé';
        return 'Extrême';
      case 'it':
        if (uv <= 2) return 'Basso';
        if (uv <= 5) return 'Moderato';
        if (uv <= 7) return 'Alto';
        if (uv <= 10) return 'Molto alto';
        return 'Estremo';
      case 'de':
        if (uv <= 2) return 'Niedrig';
        if (uv <= 5) return 'Mäßig';
        if (uv <= 7) return 'Hoch';
        if (uv <= 10) return 'Sehr hoch';
        return 'Extrem';
      case 'ru':
        if (uv <= 2) return 'Низкий';
        if (uv <= 5) return 'Умеренный';
        if (uv <= 7) return 'Высокий';
        if (uv <= 10) return 'Очень высокий';
        return 'Экстремальный';
      case 'pt':
        if (uv <= 2) return 'Baixo';
        if (uv <= 5) return 'Moderado';
        if (uv <= 7) return 'Alto';
        if (uv <= 10) return 'Muito alto';
        return 'Extremo';
      case 'ca':
        if (uv <= 2) return 'Baix';
        if (uv <= 5) return 'Moderat';
        if (uv <= 7) return 'Alt';
        if (uv <= 10) return 'Molt alt';
        return 'Extrem';
      case 'he':
        if (uv <= 2) return 'נמוך';
        if (uv <= 5) return 'מתון';
        if (uv <= 7) return 'גבוה';
        if (uv <= 10) return 'גבוה מאוד';
        return 'קיצוני';
      case 'uk':
        if (uv <= 2) return 'Низький';
        if (uv <= 5) return 'Помірний';
        if (uv <= 7) return 'Високий';
        if (uv <= 10) return 'Дуже високий';
        return 'Екстремальний';
      case 'ar':
        if (uv <= 2) return 'منخفض';
        if (uv <= 5) return 'متوسط';
        if (uv <= 7) return 'مرتفع';
        if (uv <= 10) return 'مرتفع جداً';
        return 'شديد';
      case 'zh':
        if (uv <= 2) return '低';
        if (uv <= 5) return '中等';
        if (uv <= 7) return '高';
        if (uv <= 10) return '很高';
        return '极强';
      case 'ko':
        if (uv <= 2) return '낮음';
        if (uv <= 5) return '보통';
        if (uv <= 7) return '높음';
        if (uv <= 10) return '매우 높음';
        return '위험';
      case 'ja':
        if (uv <= 2) return '弱い';
        if (uv <= 5) return '中程度';
        if (uv <= 7) return '強い';
        if (uv <= 10) return '非常に強い';
        return '極端に強い';
      default:
        if (uv <= 2) return 'Low';
        if (uv <= 5) return 'Moderate';
        if (uv <= 7) return 'High';
        if (uv <= 10) return 'Very high';
        return 'Extreme';
    }
  }

  static Color obtenerColorUV(int uv) {
    if (uv <= 2) return Colors.green;
    if (uv <= 5) return Colors.yellow.shade700;
    if (uv <= 7) return Colors.orange;
    if (uv <= 10) return Colors.red;
    return Colors.purple;
  }

  static String stringRainProbability(String idioma) {
    if (idioma == 'es') return 'Probabilidad de lluvia💧';
    if (idioma == 'fr') return 'Probabilité de pluie💧';
    if (idioma == 'it') return 'Probabilità di pioggia💧';
    if (idioma == 'de') return 'Regenwahrscheinlichkeit💧';
    if (idioma == 'ru') return 'Вероятность дождя💧';
    if (idioma == 'pt') return 'Probabilidade de chuva💧';
    if (idioma == 'ca') return 'Probabilitat de pluja💧';
    if (idioma == 'he') return 'הסתברות לגשם💧';
    if (idioma == 'uk') return 'Вірогідність дощу💧';
    if (idioma == 'ar') return 'احتمالية هطول الأمطار💧';
    if (idioma == 'zh') return '降水概率💧';
    if (idioma == 'ko') return '강수 확률💧';
    if (idioma == 'ja') return '降水確率💧';
    return 'Precipitation probability💧';
  }

  static String stringNewUpdate(String idioma, dynamic versionServer) {
    if (idioma == 'es') return '¡Nueva actualización $versionServer!';
    if (idioma == 'fr') return 'Nouvelle mise à jour $versionServer !';
    if (idioma == 'it') return 'Nuovo aggiornamento $versionServer!';
    if (idioma == 'de') return 'Neues Update $versionServer!';
    if (idioma == 'ru') return 'Новое обновление $versionServer!';
    if (idioma == 'pt') return 'Nova atualização $versionServer!';
    if (idioma == 'ca') return 'Nova actualització $versionServer!';
    if (idioma == 'he') return 'עדכון חדש $versionServer!';
    if (idioma == 'uk') return 'Нове оновлення $versionServer!';
    if (idioma == 'ar') return 'تحديث جديد $versionServer!';
    if (idioma == 'zh') return '新版本 $versionServer!';
    if (idioma == 'ko') return '새로운 업데이트 $versionServer!';
    if (idioma == 'ja') return '新しいアップデート $versionServer!';
    return 'New update $versionServer!';
  }

  static String stringUpdateWarningContent(String idioma) {
    if (idioma == 'es')
      return 'ManuleWeather tiene una nueva actualización, mejoras (sólo en español por el momento): ';
    if (idioma == 'fr')
      return 'ManuleWeather a été mis à jour ! Améliorations (uniquement en espagnol pour le moment) : ';
    if (idioma == 'it')
      return 'ManuleWeather ha un nuovo aggiornamento ! Miglioramenti (al momento solo in spagnolo): ';
    if (idioma == 'de')
      return 'ManuleWeather hat ein neues Update! Verbesserungen (vorerst nur auf Spanisch): ';
    if (idioma == 'ru')
      return 'Для ManuleWeather доступно новое обновление! Улучшения (пока только на испанском): ';
    if (idioma == 'pt')
      return 'O ManuleWeather tem uma nova atualização! Melhorias (apenas em espanhol no momento): ';
    if (idioma == 'ca')
      return 'ManuleWeather té una nova actualització, millores (només en espanyol de moment): ';
    if (idioma == 'he')
      return 'זמין עדכון חדש עבור ManuleWeather! שיפורים (כרגע בספרדית בלבד): ';
    if (idioma == 'uk')
      return 'Доступне нове оновлення для ManuleWeather! Покращення (наразі лише іспанською): ';
    if (idioma == 'ar')
      return 'يتوفر تحديث جديد لـ ManuleWeather، التحسينات (باللغة الإسبانية فقط حالياً): ';
    if (idioma == 'zh') return 'ManuleWeather 已发布新更新！改进（目前仅支持西班牙语）：';
    if (idioma == 'ko')
      return 'ManuleWeather의 새 업데이트가 있습니다! 변경 사항 (현재 스페인어만 지원): ';
    if (idioma == 'ja') return 'ManuleWeatherの新アップデートがあります！改善点（現時点ではスペイン語のみ）: ';
    return 'ManuleWeather has updated! Improvements (only spanish yet): ';
  }

  static String stringNotYet(String idioma) {
    if (idioma == 'es') return 'Mejor no';
    if (idioma == 'fr') return 'Pas maintenant';
    if (idioma == 'it') return 'Non ora';
    if (idioma == 'de') return 'Später';
    if (idioma == 'ru') return 'Не сейчас';
    if (idioma == 'pt') return 'Agora não';
    if (idioma == 'ca') return 'Ara no';
    if (idioma == 'he') return 'לא עכשיו';
    if (idioma == 'uk') return 'Не зараз';
    if (idioma == 'ar') return 'ليس الآن';
    if (idioma == 'zh') return '以后再说';
    if (idioma == 'ko') return '나중에';
    if (idioma == 'ja') return '後で';
    return 'Maybe later';
  }

  static String stringUpdate(String idioma) {
    if (idioma == 'es') return 'Actualizar';
    if (idioma == 'fr') return 'Mettre à jour';
    if (idioma == 'it') return 'Aggiorna';
    if (idioma == 'de') return 'Aktualisieren';
    if (idioma == 'ru') return 'Обновить';
    if (idioma == 'pt') return 'Atualizar';
    if (idioma == 'ca') return 'Actualitzar';
    if (idioma == 'he') return 'עדכן';
    if (idioma == 'uk') return 'Оновити';
    if (idioma == 'ar') return 'تحديث';
    if (idioma == 'zh') return '更新';
    if (idioma == 'ko') return '업데이트';
    if (idioma == 'ja') return 'アップデート';
    return 'Update';
  }

  static String stringDanger(String idioma) {
    if (idioma == 'es') return 'Atención';
    if (idioma == 'fr') return 'Attention';
    if (idioma == 'it') return 'Attenzione';
    if (idioma == 'de') return 'Achtung';
    if (idioma == 'ru') return 'Внимание';
    if (idioma == 'pt') return 'Atenção';
    if (idioma == 'ca') return 'Atenció';
    if (idioma == 'he') return 'אזהרה';
    if (idioma == 'uk') return 'Увага';
    if (idioma == 'ar') return 'تحذير';
    if (idioma == 'zh') return '注意';
    if (idioma == 'ko') return '경고';
    if (idioma == 'ja') return '注意';
    return 'Warning';
  }

  static String stringDarkTheme(String idioma) {
    if (idioma == 'es') return 'Modo oscuro';
    if (idioma == 'fr') return 'Mode sombre';
    if (idioma == 'it') return 'Modalità scura';
    if (idioma == 'de') return 'Dunkelmodus';
    if (idioma == 'ru') return 'Темный режим';
    if (idioma == 'pt') return 'Modo escuro';
    if (idioma == 'ca') return 'Mode fosc';
    if (idioma == 'he') return 'מצב כהה';
    if (idioma == 'uk') return 'Темний режим';
    if (idioma == 'ar') return 'الوضع الداكن';
    if (idioma == 'zh') return '深色模式';
    if (idioma == 'ko') return '다크 모드';
    if (idioma == 'ja') return 'ダークモード';
    return 'Dark mode';
  }

  static String stringShowSearchHistory(String idioma) {
    if (idioma == 'es') return 'Ver historial de búsqueda';
    if (idioma == 'fr') return 'Voir l\'historique de recherche';
    if (idioma == 'it') return 'Mostra cronologia delle ricerche';
    if (idioma == 'de') return 'Suchverlauf anzeigen';
    if (idioma == 'ru') return 'Показать историю поиска';
    if (idioma == 'pt') return 'Ver histórico de busca';
    if (idioma == 'ca') return 'Veure historial de cerca';
    if (idioma == 'he') return 'הצג היסטוריית חיפוש';
    if (idioma == 'uk') return 'Показати історію пошуку';
    if (idioma == 'ar') return 'عرض سجل البحث';
    if (idioma == 'zh') return '显示搜索历史';
    if (idioma == 'ko') return '검색 기록 보기';
    if (idioma == 'ja') return '検索履歴を表示';
    return 'Show search history';
  }

  static String stringSearchHistory(String idioma) {
    if (idioma == 'es') return 'Historial de búsqueda';
    if (idioma == 'fr') return 'Historique de recherche';
    if (idioma == 'it') return 'Cronologia delle ricerche';
    if (idioma == 'de') return 'Suchverlauf';
    if (idioma == 'ru') return 'История поиска';
    if (idioma == 'pt') return 'Histórico de busca';
    if (idioma == 'ca') return 'Historial de cerca';
    if (idioma == 'he') return 'היסטוריית חיפוש';
    if (idioma == 'uk') return 'Історія пошуку';
    if (idioma == 'ar') return 'سجل البحث';
    if (idioma == 'zh') return '搜索历史';
    if (idioma == 'ko') return '검색 기록';
    if (idioma == 'ja') return '検索履歴';
    return 'Search history';
  }

  static String stringNoSearchHistoryYet(String idioma) {
    if (idioma == 'es') return 'No has buscado ningún lugar aún';
    if (idioma == 'fr') return 'Vous n\'avez encore recherché aucun lieu';
    if (idioma == 'it') return 'Non hai ancora cercato nessun luogo';
    if (idioma == 'de') return 'Sie haben noch keinen Ort gesucht';
    if (idioma == 'ru') return 'Вы еще не искали ни одного места';
    if (idioma == 'pt') return 'Você ainda não buscou nenhum lugar';
    if (idioma == 'ca') return 'Encara no has cercat cap lloc';
    if (idioma == 'he') return 'טרם חיפשת מקומות כלשהם';
    if (idioma == 'uk') return 'Ви ще не шукали жодного місця';
    if (idioma == 'ar') return 'لم تقم بالبحث عن أي مكان بعد';
    if (idioma == 'zh') return '暂无搜索历史';
    if (idioma == 'ko') return '아직 검색한 위치가 없습니다';
    if (idioma == 'ja') return '検索履歴はまだありません';
    return 'You have not searched any place yet';
  }

  static String stringLimitSearchHistoryAdvisory(String idioma) {
    if (idioma == 'es') return "El historial está limitado a 5 lugares";
    if (idioma == 'fr') return "L'historique est limité à 5 lieux";
    if (idioma == 'it') return "La cronologia è limitata a 5 luoghi";
    if (idioma == 'de') return "Der Verlauf ist auf 5 Orte begrenzt";
    if (idioma == 'ru') return "История ограничена 5 местами";
    if (idioma == 'pt') return "O histórico está limitado a 5 lugares";
    if (idioma == 'ca') return "L'historial està limitat a 5 llocs";
    if (idioma == 'he') return "היסטוריית החיפוש מוגבלת ל-5 מקומות";
    if (idioma == 'uk') return "Історія обмежена 5 місцями";
    if (idioma == 'ar') return "سجل البحث محدود بـ 5 مواقع فقط";
    if (idioma == 'zh') return "历史记录最多限制为5个地点";
    if (idioma == 'ko') return "검색 기록은 5개 위치로 제한됩니다";
    if (idioma == 'ja') return "検索履歴は5件に制限されています";
    return "The search history is limited to 5 places";
  }

  static devolverCardAvisos(
    double screenWidth,
    WeatherProvider weatherProvider,
    String idioma,
  ) {
    List<double> uvData = weatherProvider.tiempoHoras!.uvIndex
        .take(24)
        .toList();
    List<double> amountRainData = weatherProvider.tiempoHoras!.precipitation
        .take(24)
        .toList();
    List<double> temperatureData = weatherProvider.tiempoHoras!.temperature2M
        .take(24)
        .toList();
    List<double> windSpeedData = weatherProvider.tiempoHoras!.windSpeed10M
        .take(24)
        .toList();
    List<double> windGustData = weatherProvider.tiempoHoras!.windGusts10M
        .take(24)
        .toList();

    // Calculamos el nivel más alto de cada categoría
    int nivelLluvia = 0;
    if (amountRainData.any((e) => e >= 60))
      nivelLluvia = 3;
    else if (amountRainData.any((e) => e >= 30))
      nivelLluvia = 2;
    else if (amountRainData.any((e) => e >= 15))
      nivelLluvia = 1;

    int nivelTempAlta = 0;
    if (temperatureData.any((e) => e > 44))
      nivelTempAlta = 3;
    else if (temperatureData.any((e) => e >= 39))
      nivelTempAlta = 2;
    else if (temperatureData.any((e) => e >= 36))
      nivelTempAlta = 1;

    int nivelTempBaja = 0;
    if (temperatureData.any((e) => e < -15))
      nivelTempBaja = 3;
    else if (temperatureData.any((e) => e < -10))
      nivelTempBaja = 2;
    else if (temperatureData.any((e) => e < -5))
      nivelTempBaja = 1;

    int nivelWindSpeed = 0;
    if (windSpeedData.any((e) => e >= 90))
      nivelWindSpeed = 3;
    else if (windSpeedData.any((e) => e >= 70))
      nivelWindSpeed = 2;
    else if (windSpeedData.any((e) => e >= 50))
      nivelWindSpeed = 1;

    int nivelWindGust = 0;
    if (windGustData.any((e) => e >= 120))
      nivelWindGust = 3;
    else if (windGustData.any((e) => e >= 90))
      nivelWindGust = 2;
    else if (windGustData.any((e) => e >= 70))
      nivelWindGust = 1;

    return Column(
      spacing: 10, //Nuevo de flutter, da espaciado entre elementos
      children: [
        //LÓGICA AVISOS RAYOS UVA
        if (uvData.any((e) => e >= 8))
          CardAlertWidget(
            text: Utils.stringAlertUV8(idioma),
            color: Colors.redAccent,
          ),
        //LÓGICA AVISOS NIVEL LLUVIA
        if (nivelLluvia == 1)
          CardAlertWidget(
            text: Utils.stringAlertRainAmount15to30(idioma),
            color: Colors.yellow,
            componentsColor: Colors.black87,
          ),
        if (nivelLluvia == 2)
          CardAlertWidget(
            text: Utils.stringAlertRainAmount30to60(idioma),
            color: Colors.orange,
          ),
        if (nivelLluvia == 3)
          CardAlertWidget(
            text: Utils.stringAlertRainAmount60ormore(idioma),
            color: Colors.redAccent,
          ),
        //LÓGICA AVISOS ALTAS TEMPERATURAS
        if (nivelTempAlta == 1)
          CardAlertWidget(
            text: Utils.stringAlertTemperature36to39(idioma),
            color: Colors.yellow,
            componentsColor: Colors.black87,
          ),
        if (nivelTempAlta == 2)
          CardAlertWidget(
            text: Utils.stringAlertTemperature40to44(idioma),
            color: Colors.orange,
          ),
        if (nivelTempAlta == 3)
          CardAlertWidget(
            text: Utils.stringAlertTemperature44ormore(idioma),
            color: Colors.redAccent,
          ),
        //LÓGICA AVISOS BAJAS TEMPERATURAS
        if (nivelTempBaja == 1)
          CardAlertWidget(
            text: Utils.stringAlertLowTemperature5to10(idioma),
            color: Colors.yellow,
            componentsColor: Colors.black87,
          ),
        if (nivelTempBaja == 2)
          CardAlertWidget(
            text: Utils.stringAlertLowTemperature10to15(idioma),
            color: Colors.orange,
          ),
        if (nivelTempBaja == 3)
          CardAlertWidget(
            text: Utils.stringAlertLowTemperature15ormore(idioma),
            color: Colors.redAccent,
          ),
        //LÓGICA AVISOS VELOCIDAD VIENTO
        if (nivelWindSpeed == 1)
          CardAlertWidget(
            text: Utils.stringAlertWindSpeedYellow(idioma),
            color: Colors.yellow,
            componentsColor: Colors.black87,
          ),
        if (nivelWindSpeed == 2)
          CardAlertWidget(
            text: Utils.stringAlertWindSpeedOrange(idioma),
            color: Colors.orange,
          ),
        if (nivelWindSpeed == 3)
          CardAlertWidget(
            text: Utils.stringAlertWindSpeedRed(idioma),
            color: Colors.redAccent,
          ),
        //LÓGICA AVISOS RACHAS MÁXIMAS DE VIENTO
        if (nivelWindGust == 1)
          CardAlertWidget(
            text: Utils.stringAlertWindGustsYellow(idioma),
            color: Colors.yellow,
            componentsColor: Colors.black87,
          ),
        if (nivelWindGust == 2)
          CardAlertWidget(
            text: Utils.stringAlertWindGustsOrange(idioma),
            color: Colors.orange,
          ),
        if (nivelWindGust == 3)
          CardAlertWidget(
            text: Utils.stringAlertWindGustsRed(idioma),
            color: Colors.redAccent,
          ),
      ],
    );
  }

  //Strings de los avisos

  static String stringAlertUV8(String idioma) {
    if (idioma == 'es')
      return "Se estiman valores de UV de 8 o más en las próximas 24 horas, no se exponga demasiado al sol y protéjase";
    if (idioma == 'fr')
      return "Des indices UV de 8 ou plus sont prévus dans les prochaines 24 heures. Évitez toute exposure prolongée au soleil et protégez-vous";
    if (idioma == 'it')
      return "Sono previsti livelli di indice UV pari a 8 o superiori nelle prossime 24 ore. Evitare l'esposizione prolungata al sole e proteggersi";
    if (idioma == 'de')
      return "In den nächsten 24 Stunden werden UV-Indexwerte von 8 oder höher erwartet. Vermeiden Sie längere Sonneneinstrahlung und schützen Sie sich";
    if (idioma == 'ru')
      return "В ближайшие 24 часа ожидается УФ-индекс 8 или выше. Избегайте длительного пребывания на солнце и защищайте себя";
    if (idioma == 'pt')
      return "Estimam-se valores de UV de 8 ou mais nas próximas 24 horas, evite exposição prolongada ao sol e proteja-se";
    if (idioma == 'ca')
      return "S'estimen valors d'UV de 8 o més en les pròximes 24 hores, no us exposeu massa al sol i protegiu-vos";
    if (idioma == 'he')
      return "צפוי מדד UV של 8 ומעלה ב-24 השעות הקרובות. הימנע מחשיפה ממושכת לשמש והגן על עצמך";
    if (idioma == 'uk')
      return "У найближчі 24 години очікується УФ-індекс 8 або вище. Уникайте тривалого перебування на сонці та захищайте себе";
    if (idioma == 'ar')
      return "يُتوقع أن تصل مستويات الأشعة فوق البنفسجية إلى 8 أو أكثر خلال الـ 24 ساعة القادمة. تجنب التعرض الطويل للشمس واحمِ نفسك";
    if (idioma == 'zh') return "预计未来24小时内紫外线指数将达到8或更高。请避免长时间暴晒并做好 text 防护";
    if (idioma == 'ko')
      return "향후 24시간 내에 자외선 지수가 8 이상으로 예상됩니다. 장시간 햇빛 노출을 피하고 자외선으로부터 보호하세요";
    if (idioma == 'ja')
      return "今後24時間以内に紫外線指数が8以上になると予想されます。長時間の長時間の外出を避け、日焼け対策をしてください";
    return "UV index levels of 8 or higher are expected in the next 24 hours. Avoid prolonged sun exposure and protect yourself.";
  }

  static String stringAlertTemperature36to39(String idioma) {
    if (idioma == 'es')
      return "Se esperan temperaturas de entre 36°C y 39°C en las próximas 24 horas. Lleva agua y evita el sol en las horas más calurosas.";
    if (idioma == 'fr')
      return "Des températures entre 36°C et 39°C sont attendues dans les prochaines 24 heures. Prenez de l'eau et évitez le soleil aux heures les plus chaudes.";
    if (idioma == 'it')
      return "Sono previste temperature tra 36°C e 39°C nelle prossime 24 ore. Porta dell'acqua ed evita l'esposizione al sole nelle ore più calde.";
    if (idioma == 'de')
      return "In den nächsten 24 Stunden werden Temperaturen zwischen 36°C und 39°C erwartet. Nehmen Sie Wasser mit und meiden Sie die Sonne während der heißesten Stunden.";
    if (idioma == 'ru')
      return "В ближайшие 24 часа ожидается температура от 36°C до 39°C. Берите с собой воду и избегайте солнца в самые жаркие часы.";
    if (idioma == 'pt')
      return "Esperam-se temperaturas entre 36°C e 39°C nas próximas 24 horas. Leve água e evite o sol nas horas mais quentes.";
    if (idioma == 'ca')
      return "S'esperen temperatures d'entre 36°C i 39°C en les pròximes 24 hores. Porta aigua i evita el sol a les hores més calentes.";
    if (idioma == 'he')
      return "צפויות טמפרטורות בין 36°C ל-39°C ב-24 השעות הקרובות. הצטייד במים והימנע מחשיפה לשמש בשעות החמות.";
    if (idioma == 'uk')
      return "У найближчі 24 години очікується температура від 36°C до 39°C. Беріть із собою воду та уникайте сонця у найспекотніші години.";
    if (idioma == 'ar')
      return "يُتوقع أن تتراوح درجات الحرارة بين 36 و39 درجة مئوية خلال الـ 24 ساعة القادمة. احمل معك الماء وتجنب الشمس في الساعات الأكثر حرارة";
    if (idioma == 'zh') return "预计未来24小时内气温将在36°C至39°C之间。请随身携带饮用水，并在最热的时段避免暴晒";
    if (idioma == 'ko')
      return "향후 24시간 내에 36°C에서 39°C 사이의 기온이 예상됩니다. 물을 지참하고 가장 더운 시간대에는 햇빛을 피하세요";
    if (idioma == 'ja')
      return "今後24時間以内に気温が36°Cから39°Cになると予想されます。水分を補給し、最も暑い時間帯の外出は避けてください";
    return "Temperatures between 36°C and 39°C are expected in the next 24 hours. Carry water and avoid sun exposure during the hottest hours.";
  }

  static String stringAlertTemperature40to44(String idioma) {
    if (idioma == 'es')
      return "Se esperan temperaturas de entre 40°C y 44°C en las próximas 24 horas. Intenta estar en lugares frescos y bebe mucha agua.";
    if (idioma == 'fr')
      return "Des températures entre 40°C et 44°C sont attendues dans les prochaines 24 heures. Restez dans des endroits frais et buvez beaucoup d'eau.";
    if (idioma == 'it')
      return "Sono previste temperature tra 40°C e 44°C nelle prossime 24 ore. Cerca di stare in luoghi freschi e bevi molta acqua.";
    if (idioma == 'de')
      return "In den nächsten 24 Stunden werden Temperaturen zwischen 40°C und 44°C erwartet. Versuchen Sie, an kühlen Orten zu bleiben und trinken Sie viel Wasser.";
    if (idioma == 'ru')
      return "В ближайшие 24 часа ожидается температура от 40°C до 44°C. Старайтесь находиться в прохладных местах и пейте много воды.";
    if (idioma == 'pt')
      return "Esperam-se temperaturas entre 40°C e 44°C nas próximas 24 horas. Procure ficar em lugares frescos e beba muita água.";
    if (idioma == 'ca')
      return "S'esperen temperatures d'entre 40°C i 44°C en les pròximes 24 hores. Intenta estar en llocs frescos i beu molta aigua.";
    if (idioma == 'he')
      return "צפויות טמפרטורות בין 40°C ל-44°C ב-24 השעות הקרובות. השתדל לשהות במקומות קרירים ושתה מים רבים.";
    if (idioma == 'uk')
      return "У найближчі 24 години очікується температура від 40°C до 44°C. Намагайтеся перебувати в прохолодних приміщеннях і пийте багато води.";
    if (idioma == 'ar')
      return "يُتوقع أن تتراوح درجات الحرارة بين 40 و44 درجة مئوية خلال الـ 24 ساعة القادمة. حاول البقاء في أماكن باردة واشرب الكثير من الماء";
    if (idioma == 'zh') return "预计未来24小时内气温将在40°C至44°C之间。请尽量待在凉爽的地方并大量补水";
    if (idioma == 'ko')
      return "향후 24시간 내에 40°C에서 44°C 사이의 기온이 예상됩니다. 시원한 곳에 머물도록 노력하고 물을 많이 마시세요";
    if (idioma == 'ja')
      return "今後24時間以内に気温が40°Cから44°Cになると予想されます。涼しい場所に滞在し、こまめに水分を補給してください";
    return "Temperatures between 40°C and 44°C are expected in the next 24 hours. Try to stay in cool places and drink plenty of water.";
  }

  static String stringAlertTemperature44ormore(String idioma) {
    if (idioma == 'es')
      return "Se esperan temperaturas superiores a 44°C en las próximas 24 horas. Ten especial cuidado si sales, hidrátate bien y evita el esfuerzo físico.";
    if (idioma == 'fr')
      return "Des températures supérieures à 44°C sont attendues dans les prochaines 24 heures. Soyez très vigilant si vous sortez, hydratez-vous bien et évitez les efforts physiques.";
    if (idioma == 'it')
      return "Sono previste temperature superiori a 44°C nelle prossime 24 ore. Presta massima attenzione se esci, idratati bene ed evita sforzi fisici.";
    if (idioma == 'de')
      return "In den nächsten 24 Stunden werden Temperaturen über 44°C erwartet. Seien Sie besonders vorsichtig, wenn Sie nach draußen gehen, trinken Sie ausreichend und vermeiden Sie körperliche Anstrengung.";
    if (idioma == 'ru')
      return "В ближайшие 24 часа ожидается температура выше 44°C. Будьте предельно осторожны при выходе на улицу, пейте воду и избегайте физических нагрузок.";
    if (idioma == 'pt')
      return "Esperam-se temperaturas superiores a 44°C nas próximas 24 horas. Tenha cuidado redobrado se sair, hidrate-se bem e evite esforço físico.";
    if (idioma == 'ca')
      return "S'esperen temperatures superiors a 44°C en les pròximes 24 hores. Tingues especial cura si surts, hidrata't bé i evita l'esforç físic.";
    if (idioma == 'he')
      return "צפויות טמפרטורות מעל 44°C ב-24 השעות הקרובות. נקוט משנה זהירות במידה ואתה יוצא, הקפד לשתות והימנע ממאמץ גופני.";
    if (idioma == 'uk')
      return "У найближчі 24 години очікується температура вище 44°C. Будьте особливо обережні при виході на вулицю, пийте достатньо води та уникайте фізичних навантажень.";
    if (idioma == 'ar')
      return "يُتوقع أن تتجاوز درجات الحرارة 44 درجة مئوية خلال الـ 24 ساعة القادمة. توخَ الحذر الشديد إذا خرجت، وحافظ على رطوبة جسمك وتجنب المجهود البدني";
    if (idioma == 'zh') return "预计未来24小时内气温将超过44°C。外出请务必格外小心，充分补水并避免剧烈运动";
    if (idioma == 'ko')
      return "향후 24시간 내에 44°C 이상의 기온이 예상됩니다. 외출 시 각별히 주의하고, 수분을 충분히 섭취하며 신체 활동을 자제하세요";
    if (idioma == 'ja')
      return "今後24時間以内に44°Cを超える猛暑が予想されます。外出の際は厳重に警戒し、水分を十分に摂り、運動は控えてください";
    return "Temperatures above 44°C are expected in the next 24 hours. Take extra care if you go out, stay well hydrated and avoid physical exercise.";
  }

  static String stringAlertLowTemperature5to10(String idioma) {
    if (idioma == 'es')
      return "Se esperan temperaturas de entre -5 y -10°C en las próximas 24 horas. Abrígate bien si sales a la calle.";
    if (idioma == 'fr')
      return "Des températures entre -5°C et -10°C sont attendues dans les prochaines 24 heures. Habillez-vous chaudement si vous sortez.";
    if (idioma == 'it')
      return "Sono previste temperature tra -5°C e -10°C nelle prossime 24 ore. Copriti bene se esci all'aperto.";
    if (idioma == 'de')
      return "In den nächsten 24 Stunden werden Temperaturen zwischen -5°C und -10°C erwartet. Ziehen Sie sich warm an, wenn Sie nach draußen gehen.";
    if (idioma == 'ru')
      return "В ближайшие 24 часа ожидается температура от -5 до -10°C. Одевайтесь теплее, если выходите на улицу.";
    if (idioma == 'pt')
      return "Esperam-se temperaturas entre -5°C e -10°C nas próximas 24 horas. Agasalhe-se bem se for à rua.";
    if (idioma == 'ca')
      return "S'esperen temperatures d'entre -5°C i -10°C en les pròximes 24 hores. Abriga't bé si surts al carrer.";
    if (idioma == 'he')
      return "צפויות טמפרטורות בין 5- ל-10- מעלות ב-24 השעות הקרובות. התלבש חם במידה ואתה יוצא.";
    if (idioma == 'uk')
      return "У найближчі 24 години очікується температура від -5°С до -10°С. Добре одягайтеся, якщо виходите на вулицю.";
    if (idioma == 'ar')
      return "يُتوقع أن تتراوح درجات الحرارة بين -5 و-10 درجات مئوية خلال الـ 24 ساعة القادمة. ارتَدِ ملابس دافئة جداً إذا خرجت";
    if (idioma == 'zh') return "预计未来24小时内气温将在-5°C至-10°C之间。外出请注意防寒保暖";
    if (idioma == 'ko')
      return "향후 24시간 내에 기온이 -5°C에서 -10°C 사이로 예상됩니다. 외출 시 옷을 따뜻하게 입으세요";
    if (idioma == 'ja')
      return "今後24時間以内に気温が-5°Cから-10°Cになると予想されます。外出の際は防寒対策を徹底してください";
    return "Temperatures between -5 and -10°C are expected in the next 24 hours. Dress warmly if you go outside.";
  }

  static String stringAlertLowTemperature10to15(String idioma) {
    if (idioma == 'es')
      return "Se esperan temperaturas de entre -10 y -15°C en las próximas 24 horas. Lleva ropa de abrigo y limita el tiempo en el exterior.";
    if (idioma == 'fr')
      return "Des températures entre -10°C et -15°C sont attendues dans les prochaines 24 heures. Portez des vêtements chauds et limitez le temps passé dehors.";
    if (idioma == 'it')
      return "Sono previste temperature tra -10°C e -15°C nelle prossime 24 ore. Indossa vestiti caldi e limita il tempo all'aperto.";
    if (idioma == 'de')
      return "In den nächsten 24 Stunden werden Temperaturen zwischen -10°C und -15°C erwartet. Tragen Sie warme Kleidung und beschränken Sie den Aufenthalt im Freien.";
    if (idioma == 'ru')
      return "В ближайшие 24 часа ожидается температура от -10 до -15°C. Носите теплую одежду и ограничьте время пребывания на улице.";
    if (idioma == 'pt')
      return "Esperam-se temperaturas entre -10°C e -15°C nas próximas 24 horas. Use roupas quentes e limite o tempo ao ar livre.";
    if (idioma == 'ca')
      return "S'esperen temperatures d'entre -10°C i -15°C en les pròximes 24 hores. Porta roba d'abric i limita el temps a l'exterior.";
    if (idioma == 'he')
      return "צפויות טמפרטורות בין 10- ל-15- מעלות ב-24 השעות הקרובות. לבש בגדים חמים והגבל את השהות בחוץ.";
    if (idioma == 'uk')
      return "У найближчі 24 години очікується температура від -10°С до -15°С. Вдягайте теплий одяг та обмежте час перебування на вулиці.";
    if (idioma == 'ar')
      return "يُتوقع أن تتراوح درجات الحرارة بين -10 و-15 درجة مئوية خلال الـ 24 ساعة القادمة. ارتدِ ملابس ثقيلة وقلل من وقت تواجدك في الخارج";
    if (idioma == 'zh') return "预计未来24小时内气温将在-10°C至-15°C之间。请穿戴厚重防寒衣物，并减少室外停留时间";
    if (idioma == 'ko')
      return "향후 24시간 내에 기온이 -10°C에서 -15°C 사이로 예상됩니다. 방한 의류를 착용하고 야외 활동 시간을 제한하세요";
    if (idioma == 'ja')
      return "今後24時間以内に気温が-10°Cから-15°Cになると予想されます。厚手の防寒着を着用し、屋外での滞在時間を制限してください";
    return "Temperatures between -10 and -15°C are expected in the next 24 hours. Wear warm clothing and limit time outdoors.";
  }

  static String stringAlertLowTemperature15ormore(String idioma) {
    if (idioma == 'es')
      return "Se esperan temperaturas inferiores a -15°C en las próximas 24 horas. Ten especial cuidado si sales, el frío extremo puede ser peligroso.";
    if (idioma == 'fr')
      return "Des températures inférieures à -15°C sont attendues dans les prochaines 24 heures. Soyez très vigilant si vous devez sortir, le froid extrême peut être dangereux.";
    if (idioma == 'it')
      return "Sono previste temperature inferiori a -15°C nelle prossime 24 ore. Presta massima attenzione se esci, il freddo estremo può essere pericoloso.";
    if (idioma == 'de')
      return "In den nächsten 24 Stunden werden Temperaturen unter -15°C erwartet. Seien Sie besonders vorsichtig, wenn Sie nach draußen gehen, extreme Kälte kann gefährlich sein.";
    if (idioma == 'ru')
      return "В ближайшие 24 часа ожидается температура ниже -15°C. Будьте особенно осторожны при выходе на улицу, экстремальный холод опасен для здоровья.";
    if (idioma == 'pt')
      return "Esperam-se temperaturas inferiores a -15°C nas próximas 24 horas. Tenha muito cuidado se sair, o frio extremo pode ser perigoso.";
    if (idioma == 'ca')
      return "S'esperen temperatures inferiors a -15°C en les pròximes 24 hores. Tingues especial cura si surts, el fred extrem pot ser perillós.";
    if (idioma == 'he')
      return "צפויות טמפרטורות מתחת ל-15- מעלות ב-24 השעות הקרובות. נקוט זהירות רבה אם אתה יוצא, קור קיצוני עלול להיות מסוכן.";
    if (idioma == 'uk')
      return "У найближчі 24 години очікується температура нижче -15°С. Будьте надзвичайно обережні у разі виходу на вулицю, екстремальний холод є небезпечним.";
    if (idioma == 'ar')
      return "يُتوقع أن تنخفض درجات الحرارة إلى أقل من -15 درجة مئوية خلال الـ 24 ساعة القادمة. توخَ الحذر الشديد، فالبرد القارس قد يكون خطيراً";
    if (idioma == 'zh') return "预计未来24小时内气温将低于-15°C。外出请格外小心，极寒天气可能非常危险";
    if (idioma == 'ko')
      return "향후 24시간 내에 기온이 -15°C 이하로 예상됩니다. 외출 시 각별히 주의하세요. 극심한 추위는 위험할 수 있습니다";
    if (idioma == 'ja')
      return "今後24時間以内に気温が-15°C以下の極寒になると予想されます。外出の際は厳重に警戒してください。極度の酷寒は危険を伴います";
    return "Temperatures below -15°C are expected in the next 24 hours. Take extra care if you go out, extreme cold can be dangerous.";
  }

  static String stringAlertRainAmount15to30(String idioma) {
    if (idioma == 'es')
      return "Se estima probabilidad de lluvias de entre 15 y 30 l/m² en una hora durante las próximas 24 horas, tenga cuidado";
    if (idioma == 'fr')
      return "De fortes pluies entre 15 et 30 l/m² par heure sont prévues dans les prochaines 24 heures. Soyez prudent.";
    if (idioma == 'it')
      return "Sono previste piogge intense tra 15 e 30 l/m² all'ora nelle prossime 24 ore. Si prega di prestare attenzione.";
    if (idioma == 'de')
      return "In den nächsten 24 Stunden wird starker Regen zwischen 15 und 30 l/m² pro Stunde erwartet. Bitte seien Sie vorsichtig.";
    if (idioma == 'ru')
      return "В ближайшие 24 часа ожидается сильный дождь от 15 до 30 л/м² в час. Пожалуйста, будьте осторожны.";
    if (idioma == 'pt')
      return "Previsão de chuva forte entre 15 e 30 l/m² por hora nas próximas 24 horas, tenha cuidado.";
    if (idioma == 'ca')
      return "S'estima probabilitat de pluges d'entre 15 i 30 l/m² en una hora durant les pròximes 24 hores, tingueu cura";
    if (idioma == 'he')
      return "צפוי גשם כבד בין 15 ל-30 ליטר/מ\"ר לשעה ב-24 השעות הקروבות. נא להישמר.";
    if (idioma == 'uk')
      return "У найближчі 24 години очікується сильний дощ від 15 до 30 л/м² за годину. Будьте обережні.";
    if (idioma == 'ar')
      return "يُتوقع هطول أمطار غزيرة بين 15 و30 لتر/متر مربع خلال ساعة واحدة في الـ 24 ساعة القادمة، يرجى توخي الحذر";
    if (idioma == 'zh') return "预计未来24小时内将出现每小时15至30升/平方米的强降雨。请注意安全";
    if (idioma == 'ko') return "향후 24시간 내에 시간당 15~30 l/m²의 강한 비가 예상됩니다. 주의하세요";
    if (idioma == 'ja') return "今後24時間以内に1時間に15〜30 l/m²の激しい雨が予想されます。警戒してください";
    return "Heavy rain between 15 and 30 l/m² per hour is expected in the next 24 hours. Please be careful.";
  }

  static String stringAlertRainAmount30to60(String idioma) {
    if (idioma == 'es')
      return "Se estima probabilidad de lluvias de entre 30 y 60 l/m² en una hora durante las próximas 24 horas, tenga mucho cuidado";
    if (idioma == 'fr')
      return "Des pluies torrentielles entre 30 et 60 l/m² par heure sont prévues dans les prochaines 24 heures. Prenez des précautions supplémentaires.";
    if (idioma == 'it')
      return "Sono previste piogge torrenziali tra 30 e 60 l/m² all'ora nelle prossime 24 ore. Prendere precauzioni extra.";
    if (idioma == 'de')
      return "In den nächsten 24 Stunden wird sintflutartiger Regen zwischen 30 und 60 l/m² pro Stunde erwartet. Treffen Sie zusätzliche Vorsichtsmaßnahmen.";
    if (idioma == 'ru')
      return "В ближайшие 24 часа ожидается проливной дождь от 30 до 60 л/м² в час. Примите дополнительные меры предосторожности.";
    if (idioma == 'pt')
      return "Previsão de chuva torrencial entre 30 e 60 l/m² por hora nas próximas 24 horas, tome precauções redobradas.";
    if (idioma == 'ca')
      return "S'estima probabilitat de pluges d'entre 30 i 60 l/m² en una hora durant les pròximes 24 hores, tingueu molta cura";
    if (idioma == 'he')
      return "צפוי גשם שוטף בין 30 ל-60 ליטר/מ\"ר לשעה ב-24 השעות הקروבות. נא לנקוט אמצעי זהירות משנה.";
    if (idioma == 'uk')
      return "У найближчі 24 години очікується проливний дощ від 30 до 60 л/м² за годину. Прийміть додаткові міри безпеки.";
    if (idioma == 'ar')
      return "يُتوقع هطول أمطار غزيرة جداً بين 30 و60 لتر/متر مربع خلال ساعة واحدة في الـ 24 ساعة القادمة، يرجى توخي الحذر الشديد";
    if (idioma == 'zh') return "预计未来24小时内将出现每小时30至60升/平方米的暴雨。请采取额外的防范措施";
    if (idioma == 'ko')
      return "향후 24시간 내에 시간당 30~60 l/m²의 폭우가 예상됩니다. 추가적인 예방 조치를 취하세요";
    if (idioma == 'ja')
      return "今後24時間以内に1時間に30〜60 l/m²の非常に激しい豪雨が予想されます。厳重に警戒してください";
    return "Torrential rain between 30 and 60 l/m² per hour is expected in the next 24 hours. Take extra precautions.";
  }

  static String stringAlertRainAmount60ormore(String idioma) {
    if (idioma == 'es')
      return "Se estima probabilidad de lluvias de 60 l/m² o más en una hora durante las próximas 24 horas, procure no salir de casa y protéjase";
    if (idioma == 'fr')
      return "Des pluies sévères de 60 l/m² ou plus par heure sont prévues dans les prochaines 24 heures. Restez à l'intérieur si possible et restez en sécurité.";
    if (idioma == 'it')
      return "Sono previste piogge violente di 60 l/m² o superiori all'ora nelle prossime 24 ore. Restare al chiuso se possibile e mettersi al sicuro.";
    if (idioma == 'de')
      return "In den nächsten 24 Stunden wird schwerer Regen von 60 l/m² oder mehr pro Stunde erwartet. Bleiben Sie nach Möglichkeit im Haus und schützen Sie sich.";
    if (idioma == 'ru')
      return "В ближайшие 24 часа ожидается опасный ливень от 60 л/м² и более в час. По возможности оставайтесь дома и будьте в безопасности.";
    if (idioma == 'pt')
      return "Previsão de chuva severa de 60 l/m² ou mais por hora nas próximas 24 horas, evite sair de casa e proteja-se.";
    if (idioma == 'ca')
      return "S'estima probabilitat de pluges de 60 l/m² o més en una hora durant les pròximes 24 hores, procureu no sortir de casa i protegiu-vos";
    if (idioma == 'he')
      return "צפוי גשם עז של 60 ליטר/מ\"ר ומעלה לשעה ב-24 השעות הקروבות. מומלץ להישאר במבנה מוגן.";
    if (idioma == 'uk')
      return "У найближчі 24 години очікується екстремальна злива від 60 л/м² і більше за годину. По можливості залишайтеся вдома.";
    if (idioma == 'ar')
      return "يُتوقع هطول أمطار كارثية تبلغ 60 لتر/متر مربع أو أكثر خلال ساعة واحدة في الـ 24 ساعة القادمة، يرجى البقاء في المنازل لحمايتكم";
    if (idioma == 'zh') return "预计未来24小时内将出现每小时60升/平方米或以上的特大暴雨。请尽量留在室内确保安全";
    if (idioma == 'ko')
      return "향후 24시간 내에 시간당 60 l/m² 이상의 극심한 폭우가 예상됩니다. 가능한 한 실내에 머무르고 안전을 확보하세요";
    if (idioma == 'ja')
      return "今後24時間以内に1時間に60 l/m²以上の猛烈な大雨が予想されます。不要不急 la 外出は避け、屋内で安全を確保してください";
    return "Severe rain of 60 l/m² or more per hour is expected in the next 24 hours. Stay indoors if possible and stay safe.";
  }

  static String stringAlertWindSpeedYellow(String idioma) {
    if (idioma == 'es')
      return "Se esperan vientos de entre 50 y 70 km/h en las próximas 24 horas. Ten precaución al circular en vehículos altos o motos y asegura objetos sueltos en exteriores.";
    if (idioma == 'fr')
      return "Des vents de 50 à 70 km/h sont attendus dans les prochaines 24 heures. Soyez prudent en conduisant des véhicules hauts ou des motos et fixez les objets légers à l'extérieur.";
    if (idioma == 'it')
      return "Sono previsti venti tra 50 e 70 km/h nelle prossime 24 ore. Prestare attenzione alla guida di veicoli alti o motocicli e assicurare oggetti sciolti all'aperto.";
    if (idioma == 'de')
      return "In den nächsten 24 Stunden werden Winde von 50 bis 70 km/h erwartet. Seien Sie vorsichtig beim Führen von hohen Fahrzeugen oder Motorrädern und sichern Sie lose Gegenstände im Freien.";
    if (idioma == 'ru')
      return "В ближайшие 24 часа ожидается ветер от 50 до 70 км/ч. Будьте осторожны при вождении высоких транспортных средств или мотоциклов и закрепите предметы на улице.";
    if (idioma == 'pt')
      return "Esperam-se ventos entre 50 e 70 km/h nas próximas 24 horas. Tenha cuidado ao conduzir veículos altos ou motos e fixe objetos soltos no exterior.";
    if (idioma == 'ca')
      return "S'esperen vents d'entre 50 i 70 km/h en les pròximes 24 hores. Tingues precaució en circular amb vehicles alts o motos i assegura objectes solts en exteriors.";
    if (idioma == 'he')
      return "צפויות רוחות במהירות 50 עד 70 קמ\"ש ב-24 השעות הקרובות. נהג בזהירות ברכב גבוה או באופנוع ואבטח חפצים רופפים בחוץ.";
    if (idioma == 'uk')
      return "У найближчі 24 години очікується вітер від 50 до 70 км/год. Будьте обережні під час керування високим транспортом чи мотоциклами та закріпіть речі на вулиці.";
    if (idioma == 'ar')
      return "يُتوقع هبوب رياح تتراوح سرعتها بين 50 و70 كم/ساعة خلال الـ 24 ساعة القادمة. توخَ الحذر عند قيادة المركبات المرتفعة أو الدراجات، وثبّت الأشياء غير المستقرة بالخارج";
    if (idioma == 'zh')
      return "预计未来24小时内将出现50至70公里/小时的风。驾驶高大车辆或摩托车时请注意安全，并固定好室外的易碎物品";
    if (idioma == 'ko')
      return "향후 24시간 내에 50~70 km/h의 바람이 예상됩니다. 대형 차량이나 오토바이 운전 시 주의하고 실외의 물건들을 고정하세요";
    if (idioma == 'ja')
      return "今後24時間以内に風速50〜70 km/hの風が予想されます。車高の高い車やバイクの運転には注意し、屋外の荷物を固定してください";
    return "Winds of 50 to 70 km/h are expected in the next 24 hours. Take care when driving tall vehicles or motorcycles and secure loose objects outdoors.";
  }

  static String stringAlertWindSpeedOrange(String idioma) {
    if (idioma == 'es')
      return "Se esperan vientos de entre 70 y 90 km/h en las próximas 24 horas. Evita actividades al aire libre en zonas expuestas, retira objetos sueltos y extrema la precaución al conducir.";
    if (idioma == 'fr')
      return "Des vents de 70 à 90 km/h sont attendus dans les prochaines 24 heures. Évitez les activités en plein air dans les zones exposées, rangez les objets légers et redoublez de prudence au volant.";
    if (idioma == 'it')
      return "Sono previsti venti tra 70 e 90 km/h nelle prossime 24 ore. Evitare attività all'aperto in zone esposte, rimuovere oggetti sciolti e prestare massima attenzione alla guida.";
    if (idioma == 'de')
      return "In den nächsten 24 Stunden werden Winde von 70 bis 90 km/h erwartet. Vermeiden Sie Aktivitäten im Freien in exponierten Bereichen, entfernen Sie lose Gegenstände und seien Sie besonders vorsichtig beim Fahren.";
    if (idioma == 'ru')
      return "В ближайшие 24 часа ожидается ветер от 70 до 90 км/ч. Избегайте пребывания на открытом воздухе, уберите незакрепленные предметы и будьте осторожны за рулем.";
    if (idioma == 'pt')
      return "Esperam-se ventos entre 70 e 90 km/h nas próximas 24 horas. Evite atividades ao ar livre em zonas expostas, retire objetos soltos e extreme os cuidados ao conduzir.";
    if (idioma == 'ca')
      return "S'esperen vents d'entre 70 i 90 km/h en les pròximes 24 hores. Evita activitats a l'aire lliure en zones exposades, retira objectes solts i extrema la precaució en conduir.";
    if (idioma == 'he')
      return "צפויות רוחות במהירות 70 עד 90 קמ\"ש ב-24 השעות הקרובות. הימנע מפעילות בשטחים פתוחים חשופים, פנה חפצים רופפים ונקוט זהירות יתרה בנהיגה.";
    if (idioma == 'uk')
      return "У найближчі 24 години очікується вітер від 70 до 90 км/год. Уникайте перебування на відкритому просторі, приберіть хиткі предмети та будьте максимально уважні за кермом.";
    if (idioma == 'ar')
      return "يُتوقع هبوب رياح تتراوح سرعتها بين 70 و90 كم/ساعة خلال الـ 24 ساعة القادمة. تجنب الأنشطة الخارجية في المناطق المفتوحة، وأزل الأشياء الطائرة، وتوخَ الحذر الشديد أثناء القيادة";
    if (idioma == 'zh')
      return "预计未来24小时内将出现70至90公里/小时的风。请避免在开阔区域进行户外活动，收回室外杂物，并在驾驶时特别小心";
    if (idioma == 'ko')
      return "향후 24시간 내에 70~90 km/h의 강풍이 예상됩니다. 노출된 장소에서의 야외 활동을 자제하고, 날아갈 수 있는 물건을 정리하며 운전 시 각별히 주의하세요";
    if (idioma == 'ja')
      return "今後24時間以内に風速70〜90 km/hの強風が予想されます。開けた場所での屋外活動は避け、飛散物を確認し、運転の際は厳重に警戒してください";
    return "Winds of 70 to 90 km/h are expected in the next 24 hours. Avoid outdoor activities in exposed areas, remove loose objects and take extra care when driving.";
  }

  static String stringAlertWindSpeedRed(String idioma) {
    if (idioma == 'es')
      return "Se esperan vientos superiores a 90 km/h en las próximas 24 horas. Evita salir si no es necesario, aléjate de árboles y estructuras inestables, y no conduzcas vehículos vulnerables al viento.";
    if (idioma == 'fr')
      return "Des vents supérieurs à 90 km/h sont attendus dans les prochaines 24 heures. Évitez de sortir sauf nécessité, éloignez-vous des arbres et des structures instables, et ne conduisez pas de véhicules vulnérables au vent.";
    if (idioma == 'it')
      return "Sono previsti venti superiori a 90 km/h nelle prossime 24 ore. Evitare di uscire se non necessario, stare lontani da alberi e strutture instabili e non guidare veicoli vulnerabili al vento.";
    if (idioma == 'de')
      return "In den nächsten 24 Stunden werden Winde über 90 km/h erwartet. Vermeiden Sie es nach Möglichkeit, nach draußen zu gehen, halten Sie sich von Bäumen und instabilen Strukturen fern und führen Sie keine windanfälligen Fahrzeuge.";
    if (idioma == 'ru')
      return "В ближайшие 24 часа ожидается ветер скоростью более 90 км/ч. Не выходите на улицу без необходимости, держитесь подальше от деревьев и неустойчивых конструкций.";
    if (idioma == 'pt')
      return "Esperam-se ventos superiores a 90 km/h nas próximas 24 horas. Evite sair desnecessariamente, afaste-se de árvores e estruturas instáveis e não conduza veículos vulneráveis.";
    if (idioma == 'ca')
      return "S'esperen vents superiors a 90 km/h en les pròximes 24 hores. Evita sortir si no és necessari, allunya't d'arbres i estructures inestables, i no condueixis vehicles vulnerables al vent.";
    if (idioma == 'he')
      return "צפויות רוחות מעل 90 קמ\"ש ב-24 השעות הקרובות. הימנע מיציאה מיותרת, התרחק מעצים ומבנים ארעיים, ואל תנהг בכלי רכב הרגישים לרוח.";
    if (idioma == 'uk')
      return "У найближчі 24 години очікується руйнівний вітер понад 90 км/год. Не виходьте на вулицю без нагальної потреби, тримайтеся подалі від дерев та нестійких конструкцій.";
    if (idioma == 'ar')
      return "يُتوقع هبوب رياح تتجاوز سرعتها 90 كم/ساعة خلال الـ 24 ساعة القادمة. تجنب الخروج إلا للضرورة القصوى، وابتعد عن الأشجار والمباني الهشة، ولا تَقُد مركبات معرضة للخطر";
    if (idioma == 'zh')
      return "预计未来24小时内将出现超过90公里/小时的强风。非必要请勿外出，远离树木和不稳固的建筑，请勿驾驶易受风力影响的车辆";
    if (idioma == 'ko')
      return "향후 24시간 내에 90 km/h 이상의 극심한 강풍이 예상됩니다. 불필요한 외출을 자제하고, 나무나 불안정한 구조물에서 멀리 떨어지며, 바람에 취약한 차량의 운행을 중단하세요";
    if (idioma == 'ja')
      return "今後24時間以内に風速90 km/h以上の猛烈な風が予想されます。不要不急の外出は避け、倒木や建造物の倒壊に警戒し、風に弱い車両の運転は控えてください";
    return "Winds above 90 km/h are expected in the next 24 hours. Avoid going out unless necessary, stay away from trees and unstable structures, and do not drive vehicles vulnerable to wind.";
  }

  static String stringAlertWindGustsYellow(String idioma) {
    if (idioma == 'es')
      return "Se esperan rachas máximas de entre 70 y 90 km/h en las próximas 24 horas. Ten cuidado con objetos sueltos en balcones, terrazas o exteriores.";
    if (idioma == 'fr')
      return "Des rafales maximales entre 70 et 90 km/h sont attendues dans les prochaines 24 heures. Faites attention aux objets non fixés sur les balcons, terrasses ou à l'extérieur.";
    if (idioma == 'it')
      return "Sono previste raffiche massime tra 70 e 90 km/h nelle prossime 24 ore. Fare attenzione agli oggetti sciolti su balconi, terrazze o aree esterne.";
    if (idioma == 'de')
      return "In den nächsten 24 Stunden werden maximale Böen von 70 bis 90 km/h erwartet. Achten Sie auf lose Gegenstände auf Balkonen, Terrassen oder im Freien.";
    if (idioma == 'ru')
      return "В ближайшие 24 часа ожидаются порывы ветра от 70 до 90 км/ч. Будьте осторожны с незакрепленными предметами на балконах, террасах и площадках.";
    if (idioma == 'pt')
      return "Esperam-se rajadas máximas entre 70 e 90 km/h nas próximas 24 horas. Atenção aos objetos soltos em varandas, terraços ou exteriores.";
    if (idioma == 'ca')
      return "S'esperen ràfegues màximes d'entre 70 i 90 km/h en les pròximes 24 hores. Tingues cura amb objectes solts en balcons, terrasses o exteriors.";
    if (idioma == 'he')
      return "צפויים משבי רוח מרביים של 70 עד 90 קמ\"ש ב-24 השעות הקרובות. שים לב לחפצים חופשיים במרפסות או בחצרות.";
    if (idioma == 'uk')
      return "У найближчі 24 години очікуються пориви вітру від 70 до 90 км/год. Стежте за незакріпленими речами на балконах, терасах та відкритих зонах.";
    if (idioma == 'ar')
      return "يُتوقع تسجيل هبات رياح قصوى بين 70 و90 كم/ساعة خلال الـ 24 ساعة القادمة. انتبه للأشياء الطائرة في الشرفات والأسطح";
    if (idioma == 'zh') return "预计未来24小时内最大阵风将达到70至90公里/小时。请注意阳台、露台或室外的易散落物品";
    if (idioma == 'ko')
      return "향후 24시간 내에 70~90 km/h의 최대 돌풍이 예상됩니다. 발코니, 테라스 또는 실외의 물건들이 날아가지 않도록 주의하세요";
    if (idioma == 'ja')
      return "今後24時間以内に最大瞬間風速70〜90 km/hの突風が予想されます。ベランダやテラス、屋外の荷物の飛散に注意してください";
    return "Maximum gusts of 70 to 90 km/h are expected in the next 24 hours. Be careful with loose objects on balconies, terraces or outdoor areas.";
  }

  static String stringAlertWindGustsOrange(String idioma) {
    if (idioma == 'es')
      return "Se esperan rachas máximas de entre 90 y 120 km/h en las próximas 24 horas. Evita zonas con árboles o construcciones inestables y refuerza puertas y ventanas.";
    if (idioma == 'fr')
      return "Des rafales maximales entre 90 et 120 km/h sont attendues dans les prochaines 24 heures. Évitez les zones arborées ou les structures instables, et renforcez les portes et fenêtres.";
    if (idioma == 'it')
      return "Sono previste raffiche massime tra 90 e 120 km/h nelle prossime 24 ore. Evitare aree con alberi o strutture instabili e rinforzare porte e finestre.";
    if (idioma == 'de')
      return "In den nächsten 24 Stunden werden maximale Böen von 90 bis 120 km/h erwartet. Meiden Sie Bereiche mit Bäumen oder instabilen Strukturen und sichern Sie Türen und Fenster.";
    if (idioma == 'ru')
      return "В ближайшие 24 часа ожидаются порывы ветра от 90 до 120 км/ч. Избегайте мест с деревьями или шаткими постройками, укрепите окна и двери.";
    if (idioma == 'pt')
      return "Esperam-se rajadas máximas entre 90 e 120 km/h nas próximas 24 horas. Evite zonas com árvores ou estruturas instáveis e reforce portas e janelas.";
    if (idioma == 'ca')
      return "S'esperen ràfegues màximes d'entre 90 i 120 km/h en les pròximes 24 hores. Evita zones amb arbres o construccions inestables i reforça portes i finestres.";
    if (idioma == 'he')
      return "צפויים משבי רוח מרביים של 90 עד 120 קמ\"ש ב-24 השעות הקרובות. התרחק מאזורי עצים או מבנים רעועים וחזק פתחים.";
    if (idioma == 'uk')
      return "У найближчі 24 години очікуються пориви вітру від 90 до 120 км/год. Уникайте ділянок із деревами чи хитками спорудами, зміцніть вікна та двері.";
    if (idioma == 'ar')
      return "يُتوقع تسجيل هبات رياح قصوى بين 90 و120 كم/ساعة خلال الـ 24 ساعة القادمة. تجنب التواجد قرب الأشجار أو الأبنية غير المستقرة، وحكّم إغلاق الأبواب والنوافذ";
    if (idioma == 'zh')
      return "预计未来24小时内最大阵风将达到90至120公里/小时。请远离树木或不稳固的建筑物，并加固门窗";
    if (idioma == 'ko')
      return "향후 24시간 내에 90~120 km/h의 최대 돌풍이 예상됩니다. 나무가 많은 곳이나 불안정한 건축물 주변을 피하고 문과 창문을 점검하세요";
    if (idioma == 'ja')
      return "今後24時間以内に最大瞬間風速90〜120 km/hの非常に強い突風が予想されます。樹木や不安定な建造物の近くには近づかず、窓やドアを補強してください";
    return "Maximum gusts of 90 to 120 km/h are expected in the next 24 hours. Avoid areas with trees or unstable structures and reinforce doors and windows.";
  }

  static String stringAlertWindGustsRed(String idioma) {
    if (idioma == 'es')
      return "Se esperan rachas máximas superiores a 120 km/h en las próximas 24 horas. Permanece en un lugar seguro, aléjate de ventanas y evita desplazamientos innecesarios.";
    if (idioma == 'fr')
      return "Des rafales maximales supérieures à 120 km/h sont attendues dans les prochaines 24 heures. Restez dans un endroit sûr, éloignez-vous des fenêtres et évitez les déplacements inutiles.";
    if (idioma == 'it')
      return "Sono previste raffiche massime superiori a 120 km/h nelle prossime 24 ore. Rimanere in un luogo sicuro, allontanarsi dalle finestre ed evitare spostamenti non necessari.";
    if (idioma == 'de')
      return "In den nächsten 24 Stunden werden maximale Böen von über 120 km/h erwartet. Bleiben Sie an einem sicheren Ort, halten Sie sich von Fenstern fern und vermeiden Sie unnötige Wege.";
    if (idioma == 'ru')
      return "В ближайшие 24 часа ожидаются порывы ветра более 120 км/ч. Оставайтесь в безопасном месте, держитесь подальше от окон и избегайте поездок.";
    if (idioma == 'pt')
      return "Esperam-se rajadas máximas superiores a 120 km/h nas próximas 24 horas. Permaneça em local seguro, afaste-se de janelas e evite deslocamentos.";
    if (idioma == 'ca')
      return "S'esperen ràfegues màximes superiors a 120 km/h en les pròximes 24 hores. Roman en un lloc segur, allunya't de finestres i evita desplaçaments innecessaris.";
    if (idioma == 'he')
      return "צפויים משבי רוח מרביים מעל 120 קמ\"ש ב-24 השעות הקרובות. שהה במרחב מוגן ובטוח, התרחק מחלונות ומנע נסיעות שאינן דחופות.";
    if (idioma == 'uk')
      return "У найближчі 24 години очікуються пориви вітру понад 120 км/год. Перебувайте в безпечному місці, тримайтеся подалі від вікон та скасуйте будь-які поїздки.";
    if (idioma == 'ar')
      return "يُتوقع تسجيل هبات رياح قصوى تتجاوز 120 كم/ساعة خلال الـ 24 ساعة القادمة. ابقَ في مكان آمن تماماً، وابتعد عن النوافذ وتجنب أي تنقلات غير ضرورية";
    if (idioma == 'zh')
      return "预计未来24小时内最大阵风将超过120公里/小时。请待 na 安全的地方，远离窗户，避免不必要的出行";
    if (idioma == 'ko')
      return "향후 24시간 내에 120 km/h를 초과하는 파괴적인 돌풍이 예상됩니다. 안전한 실내에 머무르고, 창문에서 멀리 떨어지며, 불필요한 이동을 전면 취소하세요";
    if (idioma == 'ja')
      return "今後24時間以内に最大瞬間風速120 km/h以上の猛烈な突風が予想されます。安全な場所に滞在し、窓から離れ、不要不急の移動は避けてください";
    return "Maximum gusts above 120 km/h are expected in the next 24 hours. Stay in a safe place, keep away from windows and avoid unnecessary travel.";
  }

  static String stringCheckYourConextion(String idioma) {
    if (idioma == 'es')
      return 'Comprueba tu conexión a internet e inténtalo de nuevo';
    if (idioma == 'fr')
      return 'Veuillez vérifier votre connexion Internet et réessayer';
    if (idioma == 'it')
      return 'Controlla la tua connessione Internet e riprova';
    if (idioma == 'de')
      return 'Bitte überprüfen Sie Ihre Internetverbindung und versuchen Sie es erneut';
    if (idioma == 'ru')
      return 'Проверьте подключение к интернету и повторите попытку';
    if (idioma == 'pt')
      return 'Verifique sua conexão com a internet e tente novamente';
    if (idioma == 'ca')
      return 'Comprova la teva connexió a internet i torna-ho a intentar';
    if (idioma == 'he') return 'אנא בדוק את חיבור האינטרנט ונסה שנית';
    if (idioma == 'uk')
      return 'Перевірте підключення до інтернету та спробуйте ще раз';
    if (idioma == 'ar')
      return 'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى';
    if (idioma == 'zh') return '请检查您的网络连接并重试';
    if (idioma == 'ko') return '인터넷 연결을 확인하고 다시 시도하세요';
    if (idioma == 'ja') return 'インターネット接続を確認して、もう一度お試しください';
    return 'Check your internet connection and try again';
  }

  static String stringHour(String idioma) {
    if (idioma == 'es') return 'Hora';
    if (idioma == 'fr') return 'Heure';
    if (idioma == 'it') return 'Ora';
    if (idioma == 'de') return 'Stunde';
    if (idioma == 'ru') return 'Час';
    if (idioma == 'pt') return 'Hora';
    if (idioma == 'ca') return 'Hora';
    if (idioma == 'he') return 'שעה';
    if (idioma == 'uk') return 'Година';
    if (idioma == 'ar') return 'ساعة';
    if (idioma == 'zh') return '小时'; // Chino Mandarín
    if (idioma == 'ko') return '시간';
    if (idioma == 'ja') return '時間';
    return 'Hour';
  }

  static List<FlSpot> getPuntosRayosUva(WeatherProvider weatherProvider) {
    List<FlSpot> puntosRayosUva = [];

    // Pillamos las próximas 24 horas exactas de tu API
    final totalHoras = weatherProvider.tiempoHoras!.time.take(24).length;

    for (var i = 0; i < totalHoras; i++) {
      if (i == 0) {
        puntosRayosUva.add(
          FlSpot(i.toDouble(), weatherProvider.tiempoActual!.current.uvIndex),
        );
      } else {
        puntosRayosUva.add(
          FlSpot(i.toDouble(), weatherProvider.tiempoHoras!.uvIndex[i]),
        );
      }
    }
    return puntosRayosUva;
  }

  static List<double> getAmountRainData12hrs(WeatherProvider? weatherProvider, TiempoHoras? tiempoHoras) {
    return weatherProvider != null ? weatherProvider.tiempoHoras!.precipitation
        .take(12)
        .toList() : tiempoHoras!.precipitation.take(12).toList();
  }

  static List<LluviaLevelModel> getRainLevelData(WeatherProvider? weatherProvider, TiempoHoras? tiempoHoras){
    int i = 0;
    List<LluviaLevelModel> listaADevolver = [];
    List<double> amountRainData = getAmountRainData12hrs(weatherProvider, tiempoHoras);
    List<String> hours = weatherProvider != null ? weatherProvider.tiempoHoras!.time.take(12).toList() : tiempoHoras!.time.take(12).toList();

    amountRainData.forEach((rainData) {
      if (rainData >= 60) {
        listaADevolver.add(LluviaLevelModel(nivelLluvia: 5, hora: hours[i]));
      } else if (rainData >= 30) {
        listaADevolver.add(LluviaLevelModel(nivelLluvia: 4, hora: hours[i]));
      } else if (rainData >= 10) {
        listaADevolver.add(LluviaLevelModel(nivelLluvia: 3, hora: hours[i]));
      } else if (rainData >= 2) {
        listaADevolver.add(LluviaLevelModel(nivelLluvia: 2, hora: hours[i]));
      } else if (rainData >= 0.1) {
        listaADevolver.add(LluviaLevelModel(nivelLluvia: 1, hora: hours[i]));
      }else{
        listaADevolver.add(LluviaLevelModel(nivelLluvia: 0, hora: hours[i]));
      }
      i++;
    });

    return listaADevolver;
  }

  static Widget devolverPrevisionGraficaLluvia(
    double screenWidth,
    WeatherProvider weatherProvider,
    String idioma,
  ) {
    List<LluviaLevelModel> rainBarCharData = getRainLevelData(weatherProvider,null);

    if (rainBarCharData.isEmpty || !rainBarCharData.any((rainData) => rainData.nivelLluvia >= 1)) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            children: [
              Text(Utils.mensajeLluviaDinamico(rainBarCharData, idioma), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
              SizedBox(
                height: 200,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: rainBarCharData.length * 60.0, // Subido un poco para dar aire a las etiquetas
                    child: BarChart(
                      BarChartData(
                        minY: 0,
                        maxY: 6,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (group) => Colors.black87,
                            tooltipMargin: 10,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final index = group.x;
                              if (index < 0 || index >= rainBarCharData.length) return null;
              
                              final horaReal = rainBarCharData[index].hora.substring(11, 13);
              
                              return BarTooltipItem(
                                '${Utils.stringHour(idioma)}: $horaReal:00\n',
                                const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${Utils.stringRain(idioma)}: ${getAmountRainData12hrs(weatherProvider,null)[index]} l/m²',
                                    style: const TextStyle(
                                      color: Colors.lightBlueAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          
                          // 👇 AQUÍ SE CONFIGURA EL EJE CON TUS NUEVOS TEXTOS TRADUCIDOS
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 65, // Aumentado para que los textos largos no se corten
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                String textoNivel = '';
                                
                                switch (value.toInt()) {
                                  case 1:
                                    if (idioma == 'es') textoNivel = 'Débil';
                                    else if (idioma == 'fr') textoNivel = 'Légère';
                                    else if (idioma == 'it') textoNivel = 'Leggera';
                                    else if (idioma == 'de') textoNivel = 'Leicht';
                                    else if (idioma == 'ru') textoNivel = 'Слабый';
                                    else if (idioma == 'pt') textoNivel = 'Fraca';
                                    else if (idioma == 'ca') textoNivel = 'Feble';
                                    else if (idioma == 'he') textoNivel = 'קל';
                                    else if (idioma == 'uk') textoNivel = 'Слабкий';
                                    else if (idioma == 'ar') textoNivel = 'خفيف';
                                    else if (idioma == 'zh') textoNivel = '小雨';
                                    else if (idioma == 'ko') textoNivel = '약함';
                                    else if (idioma == 'ja') textoNivel = '弱い';
                                    else textoNivel = 'Light';
                                    break;
                                  case 2:
                                    if (idioma == 'es') textoNivel = 'Moderada';
                                    else if (idioma == 'fr') textoNivel = 'Modérée';
                                    else if (idioma == 'it') textoNivel = 'Moderata';
                                    else if (idioma == 'de') textoNivel = 'Mäßig';
                                    else if (idioma == 'ru') textoNivel = 'Умеренный';
                                    else if (idioma == 'pt') textoNivel = 'Moderada';
                                    else if (idioma == 'ca') textoNivel = 'Moderat';
                                    else if (idioma == 'he') textoNivel = 'מתון';
                                    else if (idioma == 'uk') textoNivel = 'Помірний';
                                    else if (idioma == 'ar') textoNivel = 'متوسط';
                                    else if (idioma == 'zh') textoNivel = '中雨';
                                    else if (idioma == 'ko') textoNivel = '보통';
                                    else if (idioma == 'ja') textoNivel = 'やや強い';
                                    else textoNivel = 'Moderate';
                                    break;
                                  case 3:
                                    if (idioma == 'es') textoNivel = 'Fuerte';
                                    else if (idioma == 'fr') textoNivel = 'Forte';
                                    else if (idioma == 'it') textoNivel = 'Forte';
                                    else if (idioma == 'de') textoNivel = 'Stark';
                                    else if (idioma == 'ru') textoNivel = 'Сильный';
                                    else if (idioma == 'pt') textoNivel = 'Forte';
                                    else if (idioma == 'ca') textoNivel = 'Fort';
                                    else if (idioma == 'he') textoNivel = 'חזק';
                                    else if (idioma == 'uk') textoNivel = 'Сильний';
                                    else if (idioma == 'ar') textoNivel = 'قوي';
                                    else if (idioma == 'zh') textoNivel = '大雨';
                                    else if (idioma == 'ko') textoNivel = '강함';
                                    else if (idioma == 'ja') textoNivel = '強い';
                                    else textoNivel = 'Heavy';
                                    break;
                                  case 4:
                                    if (idioma == 'es') textoNivel = 'Intensa';
                                    else if (idioma == 'fr') textoNivel = 'Intense';
                                    else if (idioma == 'it') textoNivel = 'Molto forte';
                                    else if (idioma == 'de') textoNivel = 'Heftig';
                                    else if (idioma == 'ru') textoNivel = 'Интенсив.';
                                    else if (idioma == 'pt') textoNivel = 'Intensa';
                                    else if (idioma == 'ca') textoNivel = 'Intens';
                                    else if (idioma == 'he') textoNivel = 'עז';
                                    else if (idioma == 'uk') textoNivel = 'Інтенсив.';
                                    else if (idioma == 'ar') textoNivel = 'شديد';
                                    else if (idioma == 'zh') textoNivel = '暴雨';
                                    else if (idioma == 'ko') textoNivel = '매우강함';
                                    else if (idioma == 'ja') textoNivel = '激しい';
                                    else textoNivel = 'Intense';
                                    break;
                                  case 5:
                                    if (idioma == 'es') textoNivel = 'Extrema';
                                    else if (idioma == 'fr') textoNivel = 'Violente';
                                    else if (idioma == 'it') textoNivel = 'Estrema';
                                    else if (idioma == 'de') textoNivel = 'Extrem';
                                    else if (idioma == 'ru') textoNivel = 'Экстрем.';
                                    else if (idioma == 'pt') textoNivel = 'Extrema';
                                    else if (idioma == 'ca') textoNivel = 'Extrem';
                                    else if (idioma == 'he') textoNivel = 'קיצוני';
                                    else if (idioma == 'uk') textoNivel = 'Екстрем.';
                                    else if (idioma == 'ar') textoNivel = 'عنيف';
                                    else if (idioma == 'zh') textoNivel = '特大暴雨';
                                    else if (idioma == 'ko') textoNivel = '극심함';
                                    else if (idioma == 'ja') textoNivel = '猛烈な';
                                    else textoNivel = 'Extreme';
                                    break;
                                  default:
                                    return const SizedBox.shrink(); // Para el nivel 0 no pintamos texto en el eje
                                }
              
                                return Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Text(
                                    textoNivel,
                                    style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.end,
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 35,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index < 0 || index >= rainBarCharData.length) {
                                  return const SizedBox.shrink();
                                }
              
                                final horaReal = rainBarCharData[index].hora.substring(11, 13) + ":00";
              
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    horaReal,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.grey.withOpacity(0.1),
                            strokeWidth: 1,
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: List.generate(rainBarCharData.length, (index) {
                          final item = rainBarCharData[index];
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: item.nivelLluvia.toDouble(),
                                color: Colors.blue.withOpacity(0.7),
                                width: 14,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  static String mensajeLluviaDinamico(List<LluviaLevelModel> rainBarCharData, String idioma) {
  if (rainBarCharData.isEmpty) return "";

  String mensajeADevolver = "";
  
  // Contamos cuántas horas de margen plano
  int horasHastaLluvia = rainBarCharData.takeWhile((rainData) => rainData.nivelLluvia == 0).length;
  
  // Contamos el total de horas que van a tener lluvia en la predicción
  int horasDeLluvia = rainBarCharData.takeWhile((rainData) => rainData.nivelLluvia >= 1).length;

  if (horasHastaLluvia > 0) {
    if (horasHastaLluvia == 1) {
      if (idioma == 'es') mensajeADevolver = 'La lluvia comenzará en menos de una hora';
      if (idioma == 'fr') mensajeADevolver = 'La pluie commencera dans moins d\'une heure';
      if (idioma == 'it') mensajeADevolver = 'La pioggia inizierà in meno di un\'ora';
      if (idioma == 'de') mensajeADevolver = 'Der Regen beginnt in weniger als einer Stunde';
      if (idioma == 'ru') mensajeADevolver = 'Дождь начнется меньше чем через час';
      if (idioma == 'pt') mensajeADevolver = 'A chuva começará em menos de uma hora';
      if (idioma == 'ca') mensajeADevolver = 'La pluja començarà en menys d\'una hora';
      if (idioma == 'he') mensajeADevolver = 'הגשם יתחיל בעוד פחות משעה';
      if (idioma == 'uk') mensajeADevolver = 'Дощ почнеться менш ніж через годину';
      if (idioma == 'ar') mensajeADevolver = 'سيبدأ المطر خلال أقل من ساعة';
      if (idioma == 'zh') mensajeADevolver = '降雨将在不到一小时内开始';
      if (idioma == 'ko') mensajeADevolver = '한 시간 이내에 비가 시작될 예정입니다';
      if (idioma == 'ja') mensajeADevolver = '1時間以内に雨が降り始める見込みです';
      if (mensajeADevolver.isEmpty) mensajeADevolver = 'Rain will start in less than an hour';
    } else {
      // Si quedan 2 o más horas
      if (idioma == 'es') mensajeADevolver = 'La lluvia comenzará en $horasHastaLluvia horas';
      if (idioma == 'fr') mensajeADevolver = 'La pluie commencera dans $horasHastaLluvia heures';
      if (idioma == 'it') mensajeADevolver = 'La pioggia inizierà tra $horasHastaLluvia ore';
      if (idioma == 'de') mensajeADevolver = 'Der Regen beginnt in $horasHastaLluvia Stunden';
      if (idioma == 'ru') mensajeADevolver = 'Дождь начнется через $horasHastaLluvia ч.';
      if (idioma == 'pt') mensajeADevolver = 'A chuva começará em $horasHastaLluvia horas';
      if (idioma == 'ca') mensajeADevolver = 'La pluja començarà en $horasHastaLluvia hores';
      if (idioma == 'he') mensajeADevolver = 'הגשם יתחיל בעוד $horasHastaLluvia שעות';
      if (idioma == 'uk') mensajeADevolver = 'Дощ почнеться через $horasHastaLluvia год.';
      if (idioma == 'ar') mensajeADevolver = 'سيبدأ المطر خلال $horasHastaLluvia ساعات';
      if (idioma == 'zh') mensajeADevolver = '降雨将在 $horasHastaLluvia 小时内开始';
      if (idioma == 'ko') mensajeADevolver = '$horasHastaLluvia时间后开始下雨';
      if (idioma == 'ja') mensajeADevolver = '$horasHastaLluvia時間後に雨が降り始める見込みです';
      if (mensajeADevolver.isEmpty) mensajeADevolver = 'Rain will start in $horasHastaLluvia hours';
    }
  } 
  else if (horasDeLluvia > 0) {
    if (horasDeLluvia == 1) {
      // CUANDO SOLO QUEDA UNA HORA DE LLUVIA
      if (idioma == 'es') mensajeADevolver = 'La lluvia continuará durante la próxima hora';
      if (idioma == 'fr') mensajeADevolver = 'La pluie continuera pendant la prochaine heure';
      if (idioma == 'it') mensajeADevolver = 'La pioggia continuerà nella prossima ora';
      if (idioma == 'de') mensajeADevolver = 'Der Regen wird in der nächsten Stunde anhalten';
      if (idioma == 'ru') mensajeADevolver = 'Дождь продолжится в ближайший час';
      if (idioma == 'pt') mensajeADevolver = 'A chuva continuará na próxima hora';
      if (idioma == 'ca') mensajeADevolver = 'La pluja continuarà durant la pròxima hora';
      if (idioma == 'he') mensajeADevolver = 'הגشם יימשך במהלך השעה הקרובה';
      if (idioma == 'uk') mensajeADevolver = 'Дощ триватиме протягом наступної години';
      if (idioma == 'ar') mensajeADevolver = 'سيستمر المطر خلال الساعة القادمة';
      if (idioma == 'zh') mensajeADevolver = '降雨将持续接下来的一个小时';
      if (idioma == 'ko') mensajeADevolver = '앞으로 한 시간 동안 비가 계속될 예정입니다';
      if (idioma == 'ja') mensajeADevolver = '今後1時間、雨が降り続く見込みです';
      if (mensajeADevolver.isEmpty) mensajeADevolver = 'Rain will continue for the next hour';
    } else {
      // CUANDO QUEDAN DOS O MÁS HORAS
      if (idioma == 'es') mensajeADevolver = 'La lluvia continuará durante las próximas $horasDeLluvia horas';
      if (idioma == 'fr') mensajeADevolver = 'La pluie continuera pendant les $horasDeLluvia prochaines heures'; // Corregido "próximas" en español que se había colado
      if (idioma == 'it') mensajeADevolver = 'La pioggia continuerà nelle prossime $horasDeLluvia ore';
      if (idioma == 'de') mensajeADevolver = 'Der Regen wird in den nächsten $horasDeLluvia Stunden anhalten'; // Corregido el return intruso
      if (idioma == 'ru') mensajeADevolver = 'Дождь продолжится в ближайшие $horasDeLluvia ч.';
      if (idioma == 'pt') mensajeADevolver = 'A chuva continuará nas próximas $horasDeLluvia horas';
      if (idioma == 'ca') mensajeADevolver = 'La pluja continuarà durant les pròximes $horasDeLluvia hores';
      if (idioma == 'he') mensajeADevolver = 'הגשם יימשך במהלך $horasDeLluvia השעות הקרובות';
      if (idioma == 'uk') mensajeADevolver = 'Дощ триватиме протягом наступних $horasDeLluvia год.';
      if (idioma == 'ar') mensajeADevolver = 'سيستمر المطر خلال الـ $horasDeLluvia ساعة القادمة';
      if (idioma == 'zh') mensajeADevolver = '降雨将持续接下来的 $horasDeLluvia 小时';
      if (idioma == 'ko') mensajeADevolver = '앞으로 $horasDeLluvia시간 동안 비가 계속될 예정입니다';
      if (idioma == 'ja') mensajeADevolver = '今後$horasDeLluvia時間、雨が降り続く見込みです';
      if (mensajeADevolver.isEmpty) mensajeADevolver = 'Rain will continue for the next $horasDeLluvia hours';
    }
  }

  if (rainBarCharData.any((rainData) => rainData.nivelLluvia >= 4)) {
    String avisoAguaceros = "";
    if (idioma == 'es') avisoAguaceros = '. Se esperan fuertes aguaceros';
    if (idioma == 'fr') avisoAguaceros = '. De fortes averses sont attendues';
    if (idioma == 'it') avisoAguaceros = '. Sono previsti forti rovesci';
    if (idioma == 'de') avisoAguaceros = '. Es werden starke Regenschauer erwartet';
    if (idioma == 'ru') avisoAguaceros = '. Ожидаются сильные ливни';
    if (idioma == 'pt') avisoAguaceros = '. Esperam-se fortes aguaceiros';
    if (idioma == 'ca') avisoAguaceros = '. S\'esperen forts ruixats';
    if (idioma == 'he') avisoAguaceros = '. צפויים ממטרים עזים';
    if (idioma == 'uk') avisoAguaceros = '. Очікуються сильні зливи';
    if (idioma == 'ar') avisoAguaceros = '. يُتوقع هطول زخات مطر غزيرة';
    if (idioma == 'zh') avisoAguaceros = '。预计会有强阵雨';
    if (idioma == 'ko') avisoAguaceros = '. 강한 소나기가 예상됩니다';
    if (idioma == 'ja') avisoAguaceros = '。激しい大雨が予想されます';
    if (avisoAguaceros.isEmpty) avisoAguaceros = '. Heavy downpours are expected';
    
    mensajeADevolver += avisoAguaceros;
  }

  return mensajeADevolver;
}

  static String stringRain(String idioma) {
    if (idioma == 'es') return 'Lluvia';
    if (idioma == 'fr') return 'Pluie';
    if (idioma == 'it') return 'Pioggia';
    if (idioma == 'de') return 'Regen';
    if (idioma == 'ru') return 'Дождь';
    if (idioma == 'pt') return 'Chuva';
    if (idioma == 'ca') return 'Pluja';
    if (idioma == 'he') return 'גשם';
    if (idioma == 'uk') return 'Дощ';
    if (idioma == 'ar') return 'مطر';
    if (idioma == 'zh') return '降雨'; // Chino Mandarín
    if (idioma == 'ko') return '비';
    if (idioma == 'ja') return '雨';
    return 'Rain';
  }
}
