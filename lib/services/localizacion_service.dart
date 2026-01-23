import 'package:http/http.dart';
import 'package:manule_weather/models/localizacion_model.dart';
import 'package:manule_weather/models/localizacion_reverse_model.dart';

class LocalizacionService {
  String _urlBase = 'https://api.mapbox.com/geocoding/v5/mapbox.places/';
  String _apiKey =
      'pk.eyJ1IjoibWFudWxlZGV2MzY3IiwiYSI6ImNtaWhteWVyejBqYm4zZHNmdDIzZnBib2EifQ.bkN4om1L6c0LcG6Fid-51Q';
  String lenguaje = '&language=es';

  String _urlBase2 = 'https://api.mapbox.com/search/geocode/v6/reverse';
  String _apiKey2YOtros =
      '&types=place&access_token=pk.eyJ1IjoibWFudWxlZGV2MzY3IiwiYSI6ImNtaWhteWVyejBqYm4zZHNmdDIzZnBib2EifQ.bkN4om1L6c0LcG6Fid-51Q&language=es';

  Future<List<Localizacion>> getResultadosBusqueda(String ciudad) async {
  try {
    Uri uri = Uri.parse(
      '$_urlBase$ciudad.json?access_token=$_apiKey$lenguaje',
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
      '$_urlBase2?longitude=$lon&latitude=$lat$_apiKey2YOtros',
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
