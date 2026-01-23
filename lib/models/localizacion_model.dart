import 'dart:convert';

LocalizacionResponse localizacionResponseFromJson(String str) => LocalizacionResponse.fromJson(json.decode(str));

String localizacionResponseToJson(LocalizacionResponse data) => json.encode(data.toJson());

class LocalizacionResponse {
    String? type;
    List<String>? query;
    List<Localizacion>? localizaciones;
    String? attribution;

    LocalizacionResponse({
        this.type,
        this.query,
        this.localizaciones,
        this.attribution,
    });

    factory LocalizacionResponse.fromJson(Map<String, dynamic> json) => LocalizacionResponse(
        type: json["type"],
        query: json["query"] == null ? null : List<String>.from(json["query"].map((x) => x)),
        localizaciones: json["features"] == null ? null : List<Localizacion>.from(json["features"].map((x) => Localizacion.fromJson(x))),
        attribution: json["attribution"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "query": query == null ? null : List<dynamic>.from(query!.map((x) => x)),
        "features": localizaciones == null ? null : List<dynamic>.from(localizaciones!.map((x) => x.toJson())),
        "attribution": attribution,
    };
}

class Localizacion {
    String? id;
    String? type;
    List<String>? placeType;
    int? relevance;
    Properties? properties;
    String? textEs;
    Language? languageEs;
    String? placeNameEs;
    String? text;
    Language? language;
    String? placeName;
    List<double>? bbox;
    List<double>? center;
    Geometry? geometry;
    List<Context>? context;

    Localizacion({
        this.id,
        this.type,
        this.placeType,
        this.relevance,
        this.properties,
        this.textEs,
        this.languageEs,
        this.placeNameEs,
        this.text,
        this.language,
        this.placeName,
        this.bbox,
        this.center,
        this.geometry,
        this.context,
    });

    factory Localizacion.fromJson(Map<String, dynamic> json) => Localizacion(
        id: json["id"],
        type: json["type"],
        placeType: json["place_type"] == null ? null : List<String>.from(json["place_type"].map((x) => x)),
        relevance: json["relevance"] is int ? json["relevance"] as int? : null,
        properties: json["properties"] == null ? null : Properties.fromJson(json["properties"]),
        textEs: json["text_es"],
        languageEs: json["language_es"] == null ? null : languageValues.map[json["language_es"]],
        placeNameEs: json["place_name_es"],
        text: json["text"],
        language: json["language"] == null ? null : languageValues.map[json["language"]],
        placeName: json["place_name"],
        bbox: json["bbox"] == null ? null : List<double>.from(json["bbox"].map((x) => x?.toDouble())),
        center: json["center"] == null ? null : List<double>.from(json["center"].map((x) => x?.toDouble())),
        geometry: json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]),
        context: json["context"] == null ? null : List<Context>.from(json["context"].map((x) => Context.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "place_type": placeType == null ? null : List<dynamic>.from(placeType!.map((x) => x)),
        "relevance": relevance,
        "properties": properties?.toJson(),
        "text_es": textEs,
        "language_es": languageValues.reverse[languageEs],
        "place_name_es": placeNameEs,
        "text": text,
        "language": languageValues.reverse[language],
        "place_name": placeName,
        "bbox": bbox == null ? null : List<dynamic>.from(bbox!.map((x) => x)),
        "center": center == null ? null : List<dynamic>.from(center!.map((x) => x)),
        "geometry": geometry?.toJson(),
        "context": context == null ? null : List<dynamic>.from(context!.map((x) => x.toJson())),
    };
}

class Context {
    String? id;
    String? mapboxId;
    String? wikidata;
    String? shortCode;
    String? textEs;
    Language? languageEs;
    String? text;
    Language? language;

    Context({
        this.id,
        this.mapboxId,
        this.wikidata,
        this.shortCode,
        this.textEs,
        this.languageEs,
        this.text,
        this.language,
    });

    factory Context.fromJson(Map<String, dynamic> json) => Context(
        id: json["id"],
        mapboxId: json["mapbox_id"],
        wikidata: json["wikidata"],
        shortCode: json["short_code"],
        textEs: json["text_es"],
        languageEs: json["language_es"] == null ? null : languageValues.map[json["language_es"]],
        text: json["text"],
        language: json["language"] == null ? null : languageValues.map[json["language"]],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "mapbox_id": mapboxId,
        "wikidata": wikidata,
        "short_code": shortCode,
        "text_es": textEs,
        "language_es": languageValues.reverse[languageEs],
        "text": text,
        "language": languageValues.reverse[language],
    };
}

enum Language { ES }

final languageValues = EnumValues({
    "es": Language.ES
});

class Geometry {
    String? type;
    List<double>? coordinates;

    Geometry({
        this.type,
        this.coordinates,
    });

    factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: json["type"],
        coordinates: json["coordinates"] == null ? null : List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates == null ? null : List<dynamic>.from(coordinates!.map((x) => x)),
    };
}

class Properties {
    String? mapboxId;
    String? wikidata;
    String? shortCode;

    Properties({
        this.mapboxId,
        this.wikidata,
        this.shortCode,
    });

    factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        mapboxId: json["mapbox_id"],
        wikidata: json["wikidata"],
        shortCode: json["short_code"],
    );

    Map<String, dynamic> toJson() => {
        "mapbox_id": mapboxId,
        "wikidata": wikidata,
        "short_code": shortCode,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}