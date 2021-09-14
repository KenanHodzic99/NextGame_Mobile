import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:nextgame_mobile/models/IzdavackaKuca.dart';
import 'package:nextgame_mobile/models/SystemRequirements.dart';

class Igra {
  final igraId;
  final List<int> slika;
  final String naziv;
  final String ocjena;
  final String opis;
  final SystemRequirements? sysReq;
  final DateTime? datumIzdavanja;
  final IzdavackaKuca? izdavackaKuca;
  final String tip;
  final String cijena;
  final String zanrovi;

  Igra({
    required this.igraId,
    required this.naziv,
    required this.ocjena,
    required this.opis,
    required this.slika,
    this.sysReq,
    this.datumIzdavanja,
    this.izdavackaKuca,
    required this.tip,
    required this.cijena,
    required this.zanrovi,
  });

  factory Igra.fromJson(Map<String, dynamic> json) {
    String stringByte = json["slika"] as String;
    List<int> bytes = base64.decode(stringByte);
    return Igra(
        igraId: int.parse(json["id"].toString()),
        naziv: json["naziv"],
        ocjena: json["ocjena"].toString(),
        opis: json["opis"],
        slika: bytes,
        sysReq: json["systemRequirements"] == null ? json["systemRequirements"] : SystemRequirements.fromJson(json["systemRequirements"]),
        datumIzdavanja: DateTime.parse(json["datumIzdavanja"]),
        izdavackaKuca: json["izdavackaKuca"] == null ? json["izdavackaKuca"] : IzdavackaKuca.fromJson(json["izdavackaKuca"]),
        tip: json["tip"],
        cijena: json["cijena"].toString(),
        zanrovi: json["zanrovi"]);
  }

  Map<String, dynamic> toJsonSearch() => {
        "naziv": naziv.isEmpty? null : naziv,
        "ocjena": ocjena.isEmpty? null : ocjena,
        "godinaIzdavanja": datumIzdavanja == null ? null : datumIzdavanja!.year,
        "izdavackaKuca": izdavackaKuca == null? null : izdavackaKuca!.naziv,
        "tip": null,
        "cijena": cijena.isEmpty? null : cijena
      };
}
