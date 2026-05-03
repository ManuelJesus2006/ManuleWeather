// To parse this JSON data, do
//
//     final tiempoHoraResponse = tiempoHoraResponseFromJson(jsonString);

import 'dart:convert';

TiempoHoraResponse tiempoHoraResponseFromJson(String str) => TiempoHoraResponse.fromJson(json.decode(str));

String tiempoHoraResponseToJson(TiempoHoraResponse data) => json.encode(data.toJson());

class TiempoHoraResponse {
    double latitude;
    double longitude;
    double generationtimeMs;
    int utcOffsetSeconds;
    String timezone;
    String timezoneAbbreviation;
    double elevation;
    TiempoHoras tiempoHoras;

    TiempoHoraResponse({
        required this.latitude,
        required this.longitude,
        required this.generationtimeMs,
        required this.utcOffsetSeconds,
        required this.timezone,
        required this.timezoneAbbreviation,
        required this.elevation,
        required this.tiempoHoras,
    });

    factory TiempoHoraResponse.fromJson(Map<String, dynamic> json) => TiempoHoraResponse(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        generationtimeMs: json["generationtime_ms"]?.toDouble(),
        utcOffsetSeconds: json["utc_offset_seconds"],
        timezone: json["timezone"],
        timezoneAbbreviation: json["timezone_abbreviation"],
        elevation: json["elevation"],
        tiempoHoras: TiempoHoras.fromJson(json["hourly"]),
    );

    Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "generationtime_ms": generationtimeMs,
        "utc_offset_seconds": utcOffsetSeconds,
        "timezone": timezone,
        "timezone_abbreviation": timezoneAbbreviation,
        "elevation": elevation,
        "hourly": tiempoHoras.toJson(),
    };
}

class TiempoHoras {
    List<String> time;
    List<double> temperature2M;
    List<int> weatherCode;
    List<int> precipitationProbability;
    List<double> uvIndex;
    List<double> windSpeed10M;
    List<int> cloudCover;
    List<double> precipitation;
    List<int> relativeHumidity2M;

    TiempoHoras({
        required this.time,
        required this.temperature2M,
        required this.weatherCode,
        required this.precipitationProbability,
        required this.uvIndex,
        required this.windSpeed10M,
        required this.cloudCover,
        required this.precipitation,
        required this.relativeHumidity2M,
    });

    factory TiempoHoras.fromJson(Map<String, dynamic> json) => TiempoHoras(
        time: List<String>.from(json["time"].map((x) => x)),
        temperature2M: List<double>.from(json["temperature_2m"].map((x) => x?.toDouble())),
        weatherCode: List<int>.from(json["weather_code"].map((x) => x)),
        precipitationProbability: List<int>.from(json["precipitation_probability"].map((x) => x)),
        uvIndex: List<double>.from(json["uv_index"].map((x) => x?.toDouble())),
        windSpeed10M: List<double>.from(json["wind_speed_10m"].map((x) => x?.toDouble())),
        cloudCover: List<int>.from(json["cloud_cover"].map((x) => x)),
        precipitation: List<double>.from(json["precipitation"].map((x) => x?.toDouble())),
        relativeHumidity2M: List<int>.from(json["relative_humidity_2m"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "time": List<dynamic>.from(time.map((x) => x)),
        "temperature_2m": List<dynamic>.from(temperature2M.map((x) => x)),
        "weather_code": List<dynamic>.from(weatherCode.map((x) => x)),
        "precipitation_probability": List<dynamic>.from(precipitationProbability.map((x) => x)),
        "uv_index": List<dynamic>.from(uvIndex.map((x) => x)),
        "wind_speed_10m": List<dynamic>.from(windSpeed10M.map((x) => x)),
        "cloud_cover": List<dynamic>.from(cloudCover.map((x) => x)),
        "precipitation": List<dynamic>.from(precipitation.map((x) => x)),
        "relative_humidity_2m": List<dynamic>.from(relativeHumidity2M.map((x) => x)),
    };
}
