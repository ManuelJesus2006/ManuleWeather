// To parse this JSON data, do
//
//     final tiempoDiasResponse = tiempoDiasResponseFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

TiempoDiasResponse tiempoDiasResponseFromJson(String str) =>
    TiempoDiasResponse.fromJson(json.decode(str));

String tiempoDiasResponseToJson(TiempoDiasResponse data) =>
    json.encode(data.toJson());

class TiempoDiasResponse {
  double latitude;
  double longitude;
  double generationtimeMs;
  int utcOffsetSeconds;
  String timezone;
  String timezoneAbbreviation;
  double elevation;
  DailyUnits dailyUnits;
  TiempoDias tiempoDias;

  TiempoDiasResponse({
    required this.latitude,
    required this.longitude,
    required this.generationtimeMs,
    required this.utcOffsetSeconds,
    required this.timezone,
    required this.timezoneAbbreviation,
    required this.elevation,
    required this.dailyUnits,
    required this.tiempoDias,
  });

  factory TiempoDiasResponse.fromJson(Map<String, dynamic> json) =>
      TiempoDiasResponse(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        generationtimeMs: json["generationtime_ms"]?.toDouble(),
        utcOffsetSeconds: json["utc_offset_seconds"],
        timezone: json["timezone"],
        timezoneAbbreviation: json["timezone_abbreviation"],
        elevation: json["elevation"],
        dailyUnits: DailyUnits.fromJson(json["daily_units"]),
        tiempoDias: TiempoDias.fromJson(json["daily"]),
      );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
    "generationtime_ms": generationtimeMs,
    "utc_offset_seconds": utcOffsetSeconds,
    "timezone": timezone,
    "timezone_abbreviation": timezoneAbbreviation,
    "elevation": elevation,
    "daily_units": dailyUnits.toJson(),
    "daily": tiempoDias.toJson(),
  };
}

class TiempoDias {
  List<DateTime> time;
  List<double> temperature2MMax;
  List<double> temperature2MMin;
  List<int> weatherCode;
  List<double> windSpeed10MMax;
  List<double> windGusts10MMax;
  List<double> precipitationSum;
  List<String> sunrise;
  List<String> sunset;
  List<IconData> iconosGenerales = [];
  List<String> descripcionesCortas = [];

  TiempoDias({
    required this.time,
    required this.temperature2MMax,
    required this.temperature2MMin,
    required this.weatherCode,
    required this.windSpeed10MMax,
    required this.windGusts10MMax,
    required this.precipitationSum,
    required this.sunrise,
    required this.sunset,
  });

  factory TiempoDias.fromJson(Map<String, dynamic> json) => TiempoDias(
    time: List<DateTime>.from(json["time"].map((x) => DateTime.parse(x))),
    temperature2MMax: List<double>.from(
      json["temperature_2m_max"].map((x) => x?.toDouble()),
    ),
    temperature2MMin: List<double>.from(
      json["temperature_2m_min"].map((x) => x?.toDouble()),
    ),
    weatherCode: List<int>.from(json["weather_code"].map((x) => x)),
    windSpeed10MMax: List<double>.from(
      json["wind_speed_10m_max"].map((x) => x?.toDouble()),
    ),
    windGusts10MMax: List<double>.from(
      json["wind_gusts_10m_max"].map((x) => x?.toDouble()),
    ),
    precipitationSum: List<double>.from(json["precipitation_sum"].map((x) => x)),
    sunrise: List<String>.from(json["sunrise"].map((x) => x)),
    sunset: List<String>.from(json["sunset"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "time": List<dynamic>.from(
      time.map(
        (x) =>
            "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}",
      ),
    ),
    "temperature_2m_max": List<dynamic>.from(temperature2MMax.map((x) => x)),
    "temperature_2m_min": List<dynamic>.from(temperature2MMin.map((x) => x)),
    "weather_code": List<dynamic>.from(weatherCode.map((x) => x)),
    "wind_speed_10m_max": List<dynamic>.from(windSpeed10MMax.map((x) => x)),
    "wind_gusts_10m_max": List<dynamic>.from(windGusts10MMax.map((x) => x)),
    "precipitation_sum": List<dynamic>.from(precipitationSum.map((x) => x)),
    "sunrise": List<dynamic>.from(sunrise.map((x) => x)),
    "sunset": List<dynamic>.from(sunset.map((x) => x)),
  };
}

class DailyUnits {
  String time;
  String temperature2MMax;
  String temperature2MMin;
  String weatherCode;
  String windSpeed10MMax;
  String windGusts10MMax;
  String precipitationSum;
  String sunrise;
  String sunset;

  DailyUnits({
    required this.time,
    required this.temperature2MMax,
    required this.temperature2MMin,
    required this.weatherCode,
    required this.windSpeed10MMax,
    required this.windGusts10MMax,
    required this.precipitationSum,
    required this.sunrise,
    required this.sunset,
  });

  factory DailyUnits.fromJson(Map<String, dynamic> json) => DailyUnits(
    time: json["time"],
    temperature2MMax: json["temperature_2m_max"],
    temperature2MMin: json["temperature_2m_min"],
    weatherCode: json["weather_code"],
    windSpeed10MMax: json["wind_speed_10m_max"],
    windGusts10MMax: json["wind_gusts_10m_max"],
    precipitationSum: json["precipitation_sum"],
    sunrise: json["sunrise"],
    sunset: json["sunset"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "temperature_2m_max": temperature2MMax,
    "temperature_2m_min": temperature2MMin,
    "weather_code": weatherCode,
    "wind_speed_10m_max": windSpeed10MMax,
    "wind_gusts_10m_max": windGusts10MMax,
    "precipitation_sum": precipitationSum,
    "sunrise": sunrise,
    "sunset": sunset,
  };
}
