import 'package:nextgame_mobile/models/IgraPlatforma.dart';
import 'package:nextgame_mobile/models/IgraZanr.dart';
import 'dart:convert';
import 'package:nextgame_mobile/models/IzdavackaKuca.dart';
import 'package:nextgame_mobile/models/SystemRequirements.dart';
import 'package:nextgame_mobile/models/Tip.dart';

class Igra {
  final igraId;
  final List<int> slika;
  final String naziv;
  final String ocjena;
  final String opis;
  final SystemRequirements? sysReq;
  final DateTime? datumIzdavanja;
  final IzdavackaKuca? izdavackaKuca;
  final Tip? tip;
  final String cijena;
  final List<IgraZanr>? zanrovi;
  final List<IgraPlatforma>? platforme;

  Igra({
    required this.igraId,
    required this.naziv,
    required this.ocjena,
    required this.opis,
    required this.slika,
    this.sysReq,
    this.datumIzdavanja,
    this.izdavackaKuca,
    this.tip,
    required this.cijena,
    this.zanrovi,
    this.platforme
  });

  factory Igra.fromJson(Map<String, dynamic> json) {
    String stringByte = json["slika"] as String;
    List<int> bytes = base64.decode(stringByte);
    final List<IgraZanr> zanrovi;
    final List<IgraPlatforma> platforme;
    if(json["zanrovi"] != null) {
      var listaZanrova = json["zanrovi"] as List;
      zanrovi = listaZanrova.map((e) => IgraZanr.fromJson(e)).toList();
    }
    else{
      zanrovi = List.empty();
    }
    if(json["platforme"] != null) {
      var listaPlatformi = json["platforme"] as List;
      platforme = listaPlatformi.map((e) => IgraPlatforma.fromJson(e)).toList();
    }
    else{
      platforme = List.empty();
    }

    return Igra(
        igraId: int.parse(json["id"].toString()),
        naziv: json["naziv"],
        ocjena: json["ocjena"].toString(),
        opis: json["opis"],
        slika: bytes,
        sysReq: json["systemRequirements"] == null ? json["systemRequirements"] : SystemRequirements.fromJson(json["systemRequirements"]),
        datumIzdavanja: DateTime.parse(json["datumIzdavanja"]),
        izdavackaKuca: json["izdavackaKuca"] == null ? json["izdavackaKuca"] : IzdavackaKuca.fromJson(json["izdavackaKuca"]),
        tip: json["tip"] == null ? json["tip"] : Tip.fromJson(json["tip"]),
        cijena: json["cijena"].toString(),
        zanrovi: zanrovi,
        platforme: platforme);
  }

  Map<String, dynamic> toJsonSearch() => {
        "naziv": naziv.isEmpty? null : naziv,
        "ocjena": ocjena.isEmpty? null : ocjena,
        "godinaIzdavanja": datumIzdavanja == null ? null : datumIzdavanja!.year,
        "izdavackaKuca": izdavackaKuca == null? null : izdavackaKuca!.naziv,
        "tip": tip == null ? null : tip!.naziv,
        "cijena": cijena.isEmpty? null : cijena,
      };
}
