import 'package:intl/intl.dart';
import 'package:nextgame_mobile/models/Korisnik.dart';
import 'package:nextgame_mobile/models/Objava.dart';

class Komentar {
  final Id;
  final Korisnik? korisnik;
  final String? sadrzaj;
  final String? datumPostavljanja;
  final Objava? objava;
  final brojLajkova;

  Komentar(
      {required this.Id,
      this.sadrzaj,
      this.datumPostavljanja,
      this.korisnik,
      this.brojLajkova,
      this.objava});

  factory Komentar.fromJson(Map<String, dynamic> json) {
    return Komentar(
        Id: int.parse(json["id"].toString()),
        korisnik: Korisnik.fromJson(json["korisnik"]),
        sadrzaj: json["sadrzaj"],
        datumPostavljanja: json["datumPostavljanja"].toString(),
        objava: Objava.getBasicFromJson(json["objava"]),
        brojLajkova: int.parse(json["brojLajkova"].toString()));
  }

  Map<String, dynamic> toJson() => {
        "korisnikId": korisnik!.Id,
        "sadrzaj": sadrzaj,
        "datumPostavljanja": datumPostavljanja != null
            ? new DateFormat("yyyy-MM-dd")
                .parse(datumPostavljanja!)
                .toIso8601String()
            : datumPostavljanja,
        "objavaId": objava!.Id,
        "brojLajkova": brojLajkova
      };

  Map<String, dynamic> toJsonUpdate() => {
        "sadrzaj": sadrzaj,
        "datumPostavljanja": datumPostavljanja != null
            ? new DateFormat("yyyy-MM-dd")
                .parse(datumPostavljanja!)
                .toIso8601String()
            : datumPostavljanja,
        "brojLajkova": brojLajkova
      };

  Map<String, dynamic> toJsonSearch() => {"objavaId": objava!.Id.toString()};
}
