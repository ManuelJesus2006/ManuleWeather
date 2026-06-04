import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
      default:
        return '🌐';
    }
  }

  static String obtenerDiaSemana(int weekday, String idioma) {
    if (idioma == 'es') {
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
    } else {
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
    if (idioma == 'es') {
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
    } else {
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

  static String obtenerTiempoText(int weatherCode, String idioma) {
    if (idioma == 'es') {
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
    } else {
      if (weatherCode == 0) return 'Clear sky';
      if (weatherCode == 1) return 'Mainly clear';
      if (weatherCode == 2) return 'Partly cloudy';
      if (weatherCode == 3) return 'Overcast';
      if (weatherCode == 45) return 'Fog';
      if (weatherCode == 48) return 'Icy fog';
      if (weatherCode == 51) return 'Light drizzle';
      if (weatherCode == 53) return 'Moderate drizzle';
      if (weatherCode == 55) return 'Heavy drizzle';
      if (weatherCode == 56) return 'Light freezing drizzle';
      if (weatherCode == 57) return 'Heavy freezing drizzle';
      if (weatherCode == 61) return 'Light rain';
      if (weatherCode == 63) return 'Moderate rain';
      if (weatherCode == 65) return 'Heavy rain';
      if (weatherCode == 66) return 'Light freezing rain';
      if (weatherCode == 67) return 'Heavy freezing rain';
      if (weatherCode == 71) return 'Light snowfall';
      if (weatherCode == 73) return 'Moderate snowfall';
      if (weatherCode == 75) return 'Heavy snowfall';
      if (weatherCode == 77) return 'Snow grains';
      if (weatherCode == 80) return 'Light showers';
      if (weatherCode == 81) return 'Moderate showers';
      if (weatherCode == 82) return 'Violent showers';
      if (weatherCode == 85) return 'Light snow showers';
      if (weatherCode == 86) return 'Heavy snow showers';
      if (weatherCode == 95) return 'Thunderstorm';
      if (weatherCode == 96) return 'Thunderstorm with light hail';
      if (weatherCode == 99) return 'Thunderstorm with heavy hail';
    }

    return 'Desconocido';
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

  static String stringSunrise(String idioma) {
    if (idioma == 'es')
      return 'Amanecer🌅';
    else
      return 'Sunrise🌅';
  }

  static String stringSunset(String idioma) {
    if (idioma == 'es')
      return 'Anochecer🌄';
    else
      return 'Sunset🌄';
  }

  static String stringWind(String idioma) {
    if (idioma == 'es')
      return 'Viento🍃';
    else
      return 'Wind🍃';
  }

  static String stringMaxGust(String idioma) {
    if (idioma == 'es')
      return 'Rachas máximas de viento🪁';
    else
      return 'Max wind gusts🪁';
  }

  static String stringWindOrientation(String idioma) {
    if (idioma == 'es')
      return 'Orientación del viento🧭';
    else
      return 'Wind orientation🧭';
  }

  static String stringNubosity(String idioma) {
    if (idioma == 'es')
      return 'Nubosidad☁️';
    else
      return 'Cloudiness☁️';
  }

  static String stringHumidity(String idioma) {
    if (idioma == 'es')
      return 'Humedad💧';
    else
      return 'Humidity💧';
  }

  static String stringVisibility(String idioma) {
    if (idioma == 'es')
      return 'Visibilidad👁️';
    else
      return 'Visibility👁️';
  }

  static String stringPressure(String idioma) {
    if (idioma == 'es')
      return 'Presión atmosférica🌍';
    else
      return 'Atmospheric pressure🌍';
  }

  static String stringFeelsLike(String idioma) {
    if (idioma == 'es')
      return 'Sensación térmica:';
    else
      return 'Feels like:';
  }

  static String stringAmountOfRainSnow(String idioma) {
    if (idioma == 'es')
      return 'Cantidad de precipitación/nieve🌧️❄️';
    else
      return 'Amount of rain/snow🌧️❄️';
  }

  static String stringMaxWindSpeed(String idioma) {
    if (idioma == 'es')
      return 'Velocidad de viento máxima🍃';
    else
      return 'Max wind speed🍃';
  }

  static String stringOf(String idioma) {
    if (idioma == 'es')
      return 'de';
    else
      return '';
  }

  static String stringLicenses(String idioma) {
    if (idioma == 'es')
      return 'Licencias de software';
    else
      return 'Software licenses';
  }

  static String stringWelcome(String idioma) {
    if (idioma == 'es')
      return '¡Bienvenido a ManuleWeather!';
    else
      return 'Welcome to ManuleWeather!';
  }

  static String stringConfiguration(String idioma) {
    if (idioma == 'es')
      return 'Configuración';
    else
      return 'Settings';
  }

  //Bottom navigation bar
  static String stringHome(String idioma) {
    if (idioma == 'es')
      return 'Inicio';
    else
      return 'Home';
  }

  static String stringDaily(String idioma) {
    if (idioma == 'es')
      return 'Por días';
    else
      return 'Daily';
  }

  static String stringHourly(String idioma) {
    if (idioma == 'es')
      return 'Por horas';
    else
      return 'Hourly';
  }

  static String? stringInputSearch(String idioma) {
    if (idioma == 'es')
      return 'Busque un lugar';
    else
      return 'Search for a place';
  }

  static String stringCurrentLocation(String idioma) {
    if (idioma == 'es')
      return 'Ubicación actual';
    else
      return 'Current location';
  }

  static String stringObtainingLocation(String idioma) {
    if (idioma == 'es')
      return 'Obteniendo ubicación...';
    else
      return 'Obtaining location...';
  }

  static String stringChooseLanguageOnboardingText(String idioma) {
    if (idioma == 'es')
      return 'Elige tu idioma para continuar';
    else
      return 'Choose your language to proceed';
  }

  static String obtenerIdiomaText(String idioma) {
    if (idioma == 'es')
      return 'Español';
    else
      return 'English';
  }

  static String stringLanguagesSettings(String idioma) {
    if (idioma == 'es')
      return 'Idioma de la app';
    else
      return 'App language';
  }

  static String stringChooseLanguageText(String idioma) {
    if (idioma == 'es')
      return 'Elige el idioma';
    else
      return 'Choose the language';
  }

  static String stringUpdatedAt(String idioma) {
    if (idioma == 'es')
      return 'Última actualización (hora local):';
    else
      return 'Last update (local time):';
  }

  static String stringErrorServerDown(String idioma) {
    if (idioma == 'es')
      return 'EL SERVICIO CLIMÁTICO SE ENCUENTRA CAIDO EN ESTOS MOMENTOS, SENTIMOS LAS MOLESTIAS :(';
    else
      return 'THE CLIMATIC SERVICE IS CURRENTLY UNAVAIBLE RIGHT NOW, SORRY FOR INCONVENIENCE :(';
  }

  static String stringErrorNoUbiPermission(String idioma) {
    if (idioma == 'es')
      return 'NO PUEDES UTILIZAR LA APP SIN EL PERMISO DE UBICACIÓN ACTIVADO, SENTIMOS LAS MOLESTIAS :(';
    else
      return 'YOU CANNOT USE THE APP WITHOUT THE LOCATION PERMISSION ENABLED, SORRY FOR INCONVENIENCE :(';
  }

  static String stringShowDetails(String idioma) {
    if (idioma == 'es')
      return 'Ver detalles';
    else
      return 'Show details';
  }

  static stringAt(String idioma) {
    if (idioma == 'es')
      return 'a las';
    else
      return 'at';
  }

  static String stringUVRays(String idioma) {
    if (idioma == 'es')
      return 'Índice de rayos uva☀️';
    else
      return 'UV Level☀️';
  }

  static String stringUvLevel(int uv, String idioma) {
    if (idioma == 'es') {
      if (uv <= 2) return 'Bajo';
      if (uv <= 5) return 'Moderado';
      if (uv <= 7) return 'Alto';
      if (uv <= 10) return 'Muy alto';
      return 'Extremo';
    } else {
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
    if (idioma == 'es')
      return 'Probabilidad de lluvia💧';
    else
      return 'Precipitation probability💧';
  }

  static stringNewUpdate(String idioma, dynamic versionServer) {
    if (idioma == 'es')
      return '¡Nueva actualización $versionServer!';
    else
      return '¡New update $versionServer!';
  }

  static stringUpdateWarningContent(String idioma) {
    if (idioma == 'es')
      return 'ManuleWeather tiene una nueva actualización, mejoras: ';
    else
      return 'ManuleWeather has updated! Improvements (only spanish yet): ';
  }

  static String stringNotYet(String idioma) {
    if (idioma == 'es')
      return "Mejor no";
    else
      return 'Maybe later';
  }

  static String stringUpdate(String idioma) {
    if (idioma == 'es') {
      return "Actualizar";
    } else {
      return "Update";
    }
  }

  static String stringDanger(String idioma) {
    if (idioma == 'es') {
      return "Atención";
    } else {
      return "Warning";
    }
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
    else if (temperatureData.any((e) => e > 40))
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

    return Column(
      spacing: 10, //Nuevo de flutter, da espaciado entre elementos
      children: [
        if (uvData.any((e) => e >= 8))
          CardAlertWidget(
            text: Utils.stringAlertUV8(idioma),
            color: Colors.redAccent,
          ),
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
        if (nivelTempAlta == 1)
          CardAlertWidget(
            text: Utils.stringAlertTemperature36to40(idioma),
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
      ],
    );
  }

  static String stringAlertUV8(String idioma) {
    if (idioma == 'es') {
      return "Se estiman valores de UV de 8 o más en las próximas 24 horas, no se exponga demasiado al sol y protéjase";
    } else {
      return "UV index levels of 8 or higher are expected in the next 24 hours. Avoid prolonged sun exposure and protect yourself.";
    }
  }

  static String stringAlertTemperature36to40(String idioma) {
    if (idioma == 'es') {
      return "Se esperan temperaturas de entre 36 y 40°C en las próximas 24 horas. Lleva agua y evita el sol en las horas más calurosas.";
    } else {
      return "Temperatures between 36 and 40°C are expected in the next 24 hours. Carry water and avoid sun exposure during the hottest hours.";
    }
  }

  static String stringAlertTemperature40to44(String idioma) {
    if (idioma == 'es') {
      return "Se esperan temperaturas de entre 40 y 44°C en las próximas 24 horas. Intenta estar en lugares frescos y bebe mucha agua.";
    } else {
      return "Temperatures between 40 and 44°C are expected in the next 24 hours. Try to stay in cool places and drink plenty of water.";
    }
  }

  static String stringAlertTemperature44ormore(String idioma) {
    if (idioma == 'es') {
      return "Se esperan temperaturas superiores a 44°C en las próximas 24 horas. Ten especial cuidado si sales, hidrátate bien y evita el esfuerzo físico.";
    } else {
      return "Temperatures above 44°C are expected in the next 24 hours. Take extra care if you go out, stay well hydrated and avoid physical exercise.";
    }
  }

  static String stringAlertLowTemperature5to10(String idioma) {
    if (idioma == 'es') {
      return "Se esperan temperaturas de entre -5 y -10°C en las próximas 24 horas. Abrígate bien si sales a la calle.";
    } else {
      return "Temperatures between -5 and -10°C are expected in the next 24 hours. Dress warmly if you go outside.";
    }
  }

  static String stringAlertLowTemperature10to15(String idioma) {
    if (idioma == 'es') {
      return "Se esperan temperaturas de entre -10 y -15°C en las próximas 24 horas. Lleva ropa de abrigo y limita el tiempo en el exterior.";
    } else {
      return "Temperatures between -10 and -15°C are expected in the next 24 hours. Wear warm clothing and limit time outdoors.";
    }
  }

  static String stringAlertLowTemperature15ormore(String idioma) {
    if (idioma == 'es') {
      return "Se esperan temperaturas inferiores a -15°C en las próximas 24 horas. Ten especial cuidado si sales, el frío extremo puede ser peligroso.";
    } else {
      return "Temperatures below -15°C are expected in the next 24 hours. Take extra care if you go out, extreme cold can be dangerous.";
    }
  }

  static String stringAlertRainAmount15to30(String idioma) {
    if (idioma == 'es') {
      return "Se estima probabilidad de lluvias de entre 15 y 30 l/m² en una hora durante las próximas 24 horas, tenga cuidado";
    } else {
      return "Heavy rain between 15 and 30 l/m² per hour is expected in the next 24 hours. Please be careful.";
    }
  }

  static String stringAlertRainAmount30to60(String idioma) {
    if (idioma == 'es') {
      return "Se estima probabilidad de lluvias de entre 30 y 60 l/m² en una hora durante las próximas 24 horas, tenga mucho cuidado";
    } else {
      return "Torrential rain between 30 and 60 l/m² per hour is expected in the next 24 hours. Take extra precautions.";
    }
  }

  static String stringAlertRainAmount60ormore(String idioma) {
    if (idioma == 'es') {
      return "Se estima probabilidad de lluvias de 60 l/m² o más en una hora durante las próximas 24 horas, procure no salir de casa y protéjase";
    } else {
      return "Severe rain of 60 l/m² or more per hour is expected in the next 24 hours. Stay indoors if possible and stay safe.";
    }
  }

  static String stringCheckYourConextion(String idioma) {
    if (idioma == 'es') {
      return 'Comprueba tu conexión a internet e inténtalo de nuevo';
    } else {
      return 'Check your internet connection and try again';
    }
  }
}
