// To parse this JSON data, do
//
//     final localizacionReverseResponse = localizacionReverseResponseFromJson(jsonString);

import 'dart:convert';

LocalizacionReverseResponse localizacionReverseResponseFromJson(String str) => LocalizacionReverseResponse.fromJson(json.decode(str));


class LocalizacionReverseResponse {
    String type;
    List<LocalizacionReverse> localizacionReverse;
    String attribution;

    LocalizacionReverseResponse({
        required this.type,
        required this.localizacionReverse,
        required this.attribution,
    });

    factory LocalizacionReverseResponse.fromJson(Map<String, dynamic> json) => LocalizacionReverseResponse(
        type: json["type"],
        localizacionReverse: List<LocalizacionReverse>.from(json["features"].map((x) => LocalizacionReverse.fromJson(x))),
        attribution: json["attribution"],
    );
}

class LocalizacionReverse {
    String type;
    String id;
    Geometry geometry;
    Properties properties;

    LocalizacionReverse({
        required this.type,
        required this.id,
        required this.geometry,
        required this.properties,
    });

    factory LocalizacionReverse.fromJson(Map<String, dynamic> json) => LocalizacionReverse(
        type: json["type"],
        id: json["id"],
        geometry: Geometry.fromJson(json["geometry"]),
        properties: Properties.fromJson(json["properties"]),
    );
}

class Geometry {
    String type;
    List<double> coordinates;

    Geometry({
        required this.type,
        required this.coordinates,
    });

    factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: json["type"],
        coordinates: List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
    };
}

class Properties {
    String mapboxId;
    String featureType;
    String fullAddress;
    String name;
    String namePreferred;
    Coordinates coordinates;
    String placeFormatted;
    List<double> bbox;
    Context context;

    Properties({
        required this.mapboxId,
        required this.featureType,
        required this.fullAddress,
        required this.name,
        required this.namePreferred,
        required this.coordinates,
        required this.placeFormatted,
        required this.bbox,
        required this.context,
    });

    factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        mapboxId: json["mapbox_id"],
        featureType: json["feature_type"],
        fullAddress: json["full_address"],
        name: json["name"],
        namePreferred: json["name_preferred"],
        coordinates: Coordinates.fromJson(json["coordinates"]),
        placeFormatted: json["place_formatted"],
        bbox: List<double>.from(json["bbox"].map((x) => x?.toDouble())),
        context: Context.fromJson(json["context"]),
    );
}

class Context {
    District? district;
    Region region;
    Country country;
    District place;

    Context({
        required this.district,
        required this.region,
        required this.country,
        required this.place,
    });

    factory Context.fromJson(Map<String, dynamic> json) => Context(
        district: json["district"] != null
    ? District.fromJson(json["district"])
    : null,
        region: Region.fromJson(json["region"]),
        country: Country.fromJson(json["country"]),
        place: District.fromJson(json["place"]),
    );
}

class Country {
    String mapboxId;
    String name;
    String wikidataId;
    String countryCode;
    String countryCodeAlpha3;

    Country({
        required this.mapboxId,
        required this.name,
        required this.wikidataId,
        required this.countryCode,
        required this.countryCodeAlpha3,
    });

    factory Country.fromJson(Map<String, dynamic> json) => Country(
        mapboxId: json["mapbox_id"],
        name: json["name"],
        wikidataId: json["wikidata_id"],
        countryCode: json["country_code"],
        countryCodeAlpha3: json["country_code_alpha_3"],
    );

    Map<String, dynamic> toJson() => {
        "mapbox_id": mapboxId,
        "name": name,
        "wikidata_id": wikidataId,
        "country_code": countryCode,
        "country_code_alpha_3": countryCodeAlpha3,
    };
}



class District {
    String? mapboxId;
    String? name;
    String? wikidataId;

    District({
        required this.mapboxId,
        required this.name,
        required this.wikidataId,
    });

    factory District.fromJson(Map<String, dynamic> json) => District(
  mapboxId: json["mapbox_id"] as String?, // puede ser null
  name: json["name"] as String?,          // puede ser null
  wikidataId: json["wikidata_id"] as String?, // puede ser null // si no hay traducciones, se asigna null
);

}

class Region {
    String? mapboxId;
    String? name;
    String? wikidataId;
    String? regionCode;
    String? regionCodeFull;

    Region({
        required this.mapboxId,
        required this.name,
        required this.wikidataId,
        required this.regionCode,
        required this.regionCodeFull,
    });

    factory Region.fromJson(Map<String, dynamic> json) => Region(
        mapboxId: json["mapbox_id"],
        name: json["name"],
        wikidataId: json["wikidata_id"],
        regionCode: json["region_code"],
        regionCodeFull: json["region_code_full"],
        // IMPORTANTE: Validación para que no pete si translations es null en el JSON
    );
}

class Coordinates {
    double longitude;
    double latitude;

    Coordinates({
        required this.longitude,
        required this.latitude,
    });

    factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        longitude: json["longitude"]?.toDouble(),
        latitude: json["latitude"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "longitude": longitude,
        "latitude": latitude,
    };
}
