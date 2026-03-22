// To parse this JSON data, do
//
//     final tiempo = tiempoFromJson(jsonString);

import 'dart:convert';

Tiempo tiempoFromJson(String str) => Tiempo.fromJson(json.decode(str));

String tiempoToJson(Tiempo data) => json.encode(data.toJson());

class Tiempo {
    double latitude;
    double longitude;
    double generationtimeMs;
    int utcOffsetSeconds;
    String timezone;
    String timezoneAbbreviation;
    double elevation;
    Current current;

    Tiempo({
        required this.latitude,
        required this.longitude,
        required this.generationtimeMs,
        required this.utcOffsetSeconds,
        required this.timezone,
        required this.timezoneAbbreviation,
        required this.elevation,
        required this.current,
    });

    factory Tiempo.fromJson(Map<String, dynamic> json) => Tiempo(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        generationtimeMs: json["generationtime_ms"]?.toDouble(),
        utcOffsetSeconds: json["utc_offset_seconds"],
        timezone: json["timezone"],
        timezoneAbbreviation: json["timezone_abbreviation"],
        elevation: json["elevation"]?.toDouble(),
        current: Current.fromJson(json["current"]),
    );

    Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "generationtime_ms": generationtimeMs,
        "utc_offset_seconds": utcOffsetSeconds,
        "timezone": timezone,
        "timezone_abbreviation": timezoneAbbreviation,
        "elevation": elevation,
        "current": current.toJson(),
    };
}

class Current {
    String time;
    int interval;
    double temperature2M;
    double apparentTemperature;
    int weatherCode;
    double windSpeed10M;
    int windDirection10M;
    double windGusts10M;
    int relativeHumidity2M;
    double precipitation;
    int cloudCover;
    double pressureMsl;
    int isDay;
    double visibility;
    double temperature;

    Current({
        required this.time,
        required this.interval,
        required this.temperature2M,
        required this.apparentTemperature,
        required this.weatherCode,
        required this.windSpeed10M,
        required this.windDirection10M,
        required this.windGusts10M,
        required this.relativeHumidity2M,
        required this.precipitation,
        required this.cloudCover,
        required this.pressureMsl,
        required this.isDay,
        required this.visibility,
        required this.temperature,
    });

    factory Current.fromJson(Map<String, dynamic> json) => Current(
        time: json["time"],
        interval: json["interval"],
        temperature2M: json["temperature_2m"]?.toDouble(),
        apparentTemperature: json["apparent_temperature"]?.toDouble(),
        weatherCode: json["weather_code"],
        windSpeed10M: json["wind_speed_10m"]?.toDouble(),
        windDirection10M: json["wind_direction_10m"],
        windGusts10M: json["wind_gusts_10m"]?.toDouble(),
        relativeHumidity2M: json["relative_humidity_2m"],
        precipitation: json["precipitation"],
        cloudCover: json["cloud_cover"],
        pressureMsl: json["pressure_msl"]?.toDouble(),
        isDay: json["is_day"],
        visibility: json["visibility"],
        temperature: json["temperature"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "time": time,
        "interval": interval,
        "temperature_2m": temperature2M,
        "apparent_temperature": apparentTemperature,
        "weather_code": weatherCode,
        "wind_speed_10m": windSpeed10M,
        "wind_direction_10m": windDirection10M,
        "wind_gusts_10m": windGusts10M,
        "relative_humidity_2m": relativeHumidity2M,
        "precipitation": precipitation,
        "cloud_cover": cloudCover,
        "pressure_msl": pressureMsl,
        "is_day": isDay,
        "visibility": visibility,
        "temperature": temperature,
    };
}
