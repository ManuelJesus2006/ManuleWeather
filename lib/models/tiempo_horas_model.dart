// To parse this JSON data, do
//
//     final tiempoHoraResponse = tiempoHoraResponseFromJson(jsonString);

import 'dart:convert';

TiempoHoraResponse tiempoHoraResponseFromJson(String str) => TiempoHoraResponse.fromJson(json.decode(str));

class TiempoHoraResponse {
    double latitude;
    double longitude;
    double generationtimeMs;
    int utcOffsetSeconds;
    String timezone;
    String timezoneAbbreviation;
    double elevation;
    HourlyUnits hourlyUnits;
    TiempoHoras tiempoHoras;

    TiempoHoraResponse({
        required this.latitude,
        required this.longitude,
        required this.generationtimeMs,
        required this.utcOffsetSeconds,
        required this.timezone,
        required this.timezoneAbbreviation,
        required this.elevation,
        required this.hourlyUnits,
        required this.tiempoHoras,
    });

    factory TiempoHoraResponse.fromJson(Map<String, dynamic> json) => TiempoHoraResponse(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        generationtimeMs: json["generationtime_ms"]?.toDouble(),
        utcOffsetSeconds: json["utc_offset_seconds"],
        timezone: json["timezone"],
        timezoneAbbreviation: json["timezone_abbreviation"],
        elevation: json["elevation"]?.toDouble(),
        hourlyUnits: HourlyUnits.fromJson(json["hourly_units"]),
        tiempoHoras: TiempoHoras.fromJson(json["hourly"]),
    );
}

class TiempoHoras {
    List<String> time;
    List<double> temperature2M;
    List<int> weatherCode;

    TiempoHoras({
        required this.time,
        required this.temperature2M,
        required this.weatherCode,
    });

    factory TiempoHoras.fromJson(Map<String, dynamic> json) => TiempoHoras(
        time: List<String>.from(json["time"].map((x) => x)),
        temperature2M: List<double>.from(json["temperature_2m"].map((x) => x?.toDouble())),
        weatherCode: List<int>.from(json["weather_code"].map((x) => x)),
    );
}

class HourlyUnits {
    String time;
    String temperature2M;
    String weatherCode;

    HourlyUnits({
        required this.time,
        required this.temperature2M,
        required this.weatherCode,
    });

    factory HourlyUnits.fromJson(Map<String, dynamic> json) => HourlyUnits(
        time: json["time"],
        temperature2M: json["temperature_2m"],
        weatherCode: json["weather_code"],
    );
}