import 'package:nextgame_mobile/models/Igra.dart';
import 'package:nextgame_mobile/models/Korisnik.dart';

class ListaIgrica {
  final Id;
  final Korisnik? korisnik;
  final Igra? igrica;
  final double? ocjena;
  final String? sati;

  ListaIgrica(
      {required this.Id, this.korisnik, this.igrica, this.ocjena, this.sati});

  factory ListaIgrica.fromJson(Map<String, dynamic> json) {
    return ListaIgrica(
        Id: int.parse(json["id"].toString()),
        korisnik: Korisnik.fromJson(json["korisnik"]),
        igrica: Igra.fromJson(json["igrica"]),
        ocjena: double.parse(json["ocjena"].toString()),
        sati: json["sati"].toString());
  }

  Map<String, dynamic> toJson() => {
        "korisnikId": korisnik!.Id,
        "igricaId": igrica!.igraId,
        "ocjena": ocjena,
        "sati": int.parse(sati!)
      };

  Map<String, dynamic> toJsonSearch() => {"korisnikId": korisnik!.Id.toString()};

  Map<String, dynamic> toJsonUpdate() =>
      {"ocjena": ocjena, "sati": int.parse(sati!)};
}
