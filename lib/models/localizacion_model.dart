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
    String? text;
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
        this.text,
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
        text: json["text"],
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
        "text": text,
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
    String? text;

    Context({
        this.id,
        this.mapboxId,
        this.wikidata,
        this.shortCode,
        this.text,
    });

    factory Context.fromJson(Map<String, dynamic> json) => Context(
        id: json["id"],
        mapboxId: json["mapbox_id"],
        wikidata: json["wikidata"],
        shortCode: json["short_code"],
        text: json["text"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "mapbox_id": mapboxId,
        "wikidata": wikidata,
        "short_code": shortCode,
        "text": text,
    };
}

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