import 'package:intl/intl.dart';
import 'package:nextgame_mobile/models/Igra.dart';
import 'package:nextgame_mobile/models/Korisnik.dart';

class Recenzija {
  final Id;
  final Korisnik? korisnik;
  final Igra? igrica;
  final bool? isPrijavljena;
  final double? ocjena;
  final String? datumPostavljanja;
  final String? sadrzaj;
  final String? vrijemeIgranja;

  Recenzija(
      {required this.Id,
      this.korisnik,
       this.ocjena,
       this.datumPostavljanja,
      this.igrica,
       this.isPrijavljena,
       this.sadrzaj,
       this.vrijemeIgranja});

  factory Recenzija.fromJson(Map<String, dynamic> json) {
    return Recenzija(
        Id: int.parse(json["id"].toString()),
        korisnik: Korisnik.fromJson(json["korisnik"]),
        igrica: Igra.fromJson(json["igrica"]),
        isPrijavljena: json["isPrijavljena"],
        ocjena: double.parse(json["ocjena"].toString()),
        datumPostavljanja: json["datumPostavljanja"],
        sadrzaj: json["sadrzaj"],
        vrijemeIgranja: json["vrijemeIgranja"].toString());
  }
  Map<String, dynamic> toJson() => {
        "korisnikId": korisnik!.Id,
        "igricaId": igrica!.igraId,
        "isPrijavljena": isPrijavljena,
        "ocjena": ocjena,
        "datumPostavljanja": datumPostavljanja == null ? datumPostavljanja : new DateFormat("yyyy-MM-dd").parse(datumPostavljanja!).toIso8601String(),
        "sadrzaj": sadrzaj,
        "vrijemeIgranja": int.parse(vrijemeIgranja!)
      };

  Map<String, dynamic> toJsonUpdate() => {
        "isPrijavljena": isPrijavljena,
        "ocjena": ocjena ,
        "datumPostavljanja": datumPostavljanja == null ? datumPostavljanja : new DateFormat("yyyy-MM-dd").parse(datumPostavljanja!).toIso8601String(),
        "sadrzaj": sadrzaj,
        "vrijemeIgranja": vrijemeIgranja == null ? vrijemeIgranja : int.parse(vrijemeIgranja!)
      };

  Map<String, dynamic> toJsonSearch() => {
    "igricaId" : igrica == null ? 0.toString() : igrica!.igraId.toString(),
    "korisnikId" : korisnik == null ? 0.toString() : korisnik!.Id.toString()
  };
}
