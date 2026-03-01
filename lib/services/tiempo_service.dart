import 'package:http/http.dart';
import 'package:manule_weather/environment.dart';
import 'package:manule_weather/models/tiempo_horas_model.dart';
import 'package:manule_weather/models/tiempo_model.dart';

class TiempoService {
  String _urlBase = 'https://api.openweathermap.org/data/2.5/weather';


  String _urlTiempoHoras = 'https://api.open-meteo.com/v1/forecast?';
  String _otrosTiempoHoras = '&hourly=temperature_2m,weather_code';

  Future<Tiempo?> getTiempoLatLon(double lat, double lon) async{
    Uri uri = Uri.parse('$_urlBase?lat=$lat&lon=$lon${Environment.apiKeyMetricLang}');
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
  Future<TiempoHoras?> getTiempoPorHoras(double lat, double lon) async{
    Uri uri = Uri.parse('${_urlTiempoHoras}latitude=$lat&longitude=$lon$_otrosTiempoHoras');
    Response response = await get(uri);

    if (response.statusCode != 200) return null;
    TiempoHoraResponse tiempoHoraResponse = tiempoHoraResponseFromJson(response.body);
    return tiempoHoraResponse.tiempoHoras;
  }
}