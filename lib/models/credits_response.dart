// To parse this JSON data, do
//
//     final credistResponse = credistResponseFromMap(jsonString);

import 'dart:convert';

import 'cast.dart';

class CredistResponse {
    CredistResponse({
        required this.id,
        required this.cast,
        required this.crew,
    });

    int id;
    List<Cast> cast;
    List<Cast> crew;

    factory CredistResponse.fromJson(String str) => CredistResponse.fromMap(json.decode(str));

    factory CredistResponse.fromMap(Map<String, dynamic> json) => CredistResponse(
        id: json["id"],
        cast: List<Cast>.from(json["cast"].map((x) => Cast.fromMap(x))),
        crew: List<Cast>.from(json["crew"].map((x) => Cast.fromMap(x))),
    );
}


