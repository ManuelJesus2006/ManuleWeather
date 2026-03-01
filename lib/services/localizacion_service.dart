import 'package:http/http.dart';
import 'package:manule_weather/environment.dart';
import 'package:manule_weather/models/localizacion_model.dart';
import 'package:manule_weather/models/localizacion_reverse_model.dart';

class LocalizacionService {
  String _urlBase = 'https://api.mapbox.com/geocoding/v5/mapbox.places/';
  String lenguaje = '&language=es';

  String _urlBaseReverse = 'https://api.mapbox.com/search/geocode/v6/reverse';

  Future<List<Localizacion>> getResultadosBusqueda(String ciudad) async {
  try {
    Uri uri = Uri.parse(
      '$_urlBase$ciudad.json?access_token=${Environment.apiKeyNormal}$lenguaje',
    );
    Response response = await get(uri);

    if (response.statusCode != 200) return []; // Retorno directo si falla la red

    LocalizacionResponse localizacionResponse = localizacionResponseFromJson(
      response.body,
    );
    
    // Retornamos directamente los datos obtenidos
    return localizacionResponse.localizaciones!; 
    
  } catch (error) {
    print(error);
    return []; // Retorno de emergencia si explota el código
  }
}

  Future<String?> getNombreCiudadByCords(double lon, double lat) async {
    Uri uri = Uri.parse(
      '$_urlBaseReverse?longitude=$lon&latitude=$lat${Environment.apiKeyReverseYOtros}',
    );
    Response response = await get(uri);

    if (response.statusCode != 200) return null;
    LocalizacionReverseResponse localizacionReverseResponse =
        localizacionReverseResponseFromJson(response.body);
    return localizacionReverseResponse
        .localizacionReverse[0]
        .properties
        .fullAddress;
  }
}
