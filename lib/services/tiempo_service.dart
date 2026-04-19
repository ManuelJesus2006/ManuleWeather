import 'package:http/http.dart';
import 'package:manule_weather/models/tiempo_dias_response_model.dart';
import 'package:manule_weather/models/tiempo_horas_model.dart';
import 'package:manule_weather/models/tiempo_model.dart';

class TiempoService {
  String _urlBase = 'https://api.openweathermap.org/data/2.5/weather';

  String _urlBaseOpenMeteo = 'https://api.open-meteo.com/v1/forecast?';
  String _otrosTiempoHoras = '&hourly=temperature_2m,weather_code,precipitation_probability,uv_index,wind_speed_10m,cloud_cover';

  String _otrosTiempoDias = '&daily=temperature_2m_max,temperature_2m_min,weather_code,wind_speed_10m_max,wind_gusts_10m_max,precipitation_sum,sunrise,sunset&timezone=auto';
  String _otrosTiempoActual = "&current=temperature_2m,apparent_temperature,weather_code,wind_speed_10m,wind_direction_10m,wind_gusts_10m,relative_humidity_2m,precipitation,cloud_cover,pressure_msl,is_day,visibility,temperature&timezone=auto";
  Future<Tiempo?> getTiempoLatLon(double lat, double lon) async {
    Uri uri = Uri.parse(
      '${_urlBaseOpenMeteo}latitude=$lat&longitude=$lon$_otrosTiempoActual',
    );
    Response response = await get(uri);

    if (response.statusCode != 200) return null;
    Tiempo tiempoADevolver = tiempoFromJson(response.body);
    return tiempoADevolver;
  }

  //   0	Despejado (Cielo limpio)
  // 1, 2, 3	Principalmente despejado, parcialmente nublado y nublado
  // 45, 48	Niebla
  // 51, 53, 55	Llovizna
  // 61, 63, 65	Lluvia (ligera, moderada y fuerte)
  // 71, 73, 75	Nieve
  // 95	Tormenta
  Future<TiempoHoras?> getTiempoPorHoras(double lat, double lon) async {
    Uri uri = Uri.parse(
      '${_urlBaseOpenMeteo}latitude=$lat&longitude=$lon$_otrosTiempoHoras',
    );
    print(uri);
    Response response = await get(uri);

    if (response.statusCode != 200) return null;
    TiempoHoraResponse tiempoHoraResponse = tiempoHoraResponseFromJson(
      response.body,
    );
    return tiempoHoraResponse.tiempoHoras;
  }

  Future<TiempoDias?> getTiempoPorDias(double lat, double lon)async{
    Uri uri = Uri.parse(
      '${_urlBaseOpenMeteo}latitude=$lat&longitude=$lon$_otrosTiempoDias',
    );
    print(uri);
    Response response = await get(uri);

    if (response.statusCode != 200) return null;
    TiempoDiasResponse tiempoDiasResponse = tiempoDiasResponseFromJson(
      response.body,
    );
    return tiempoDiasResponse.tiempoDias;
  }
}
