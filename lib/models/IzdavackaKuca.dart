import 'dart:convert';

class IzdavackaKuca {
  final Id;
  final List<int> slika;
  final String naziv;
  final String brojZaposlenika;
  final String datumOsnivanja;
  final String osnivaci;
  final String mjestoOsnivanja;
  final String sjediste;
  final String opis;

  IzdavackaKuca({
    required this.Id,
    required this.slika,
    required this.naziv,
    required this.brojZaposlenika,
    required this.datumOsnivanja,
    required this.osnivaci,
    required this.mjestoOsnivanja,
    required this.sjediste,
    required this.opis,
  });

  factory IzdavackaKuca.fromJson(Map<String, dynamic> json) {
    String stringByte = json["slika"] as String;
    List<int> bytes = base64.decode(stringByte);
    return IzdavackaKuca(
        Id: int.parse(json["id"].toString()),
        slika: bytes,
        naziv: json["naziv"],
        brojZaposlenika: json["brojZaposlenika"].toString(),
        datumOsnivanja: json["datumOsnivanja"].toString(),
        osnivaci: json["osnivaci"],
        mjestoOsnivanja: json["mjestoOsnivanja"],
        sjediste: json["sjediste"],
        opis: json["opis"]);
  }
}
