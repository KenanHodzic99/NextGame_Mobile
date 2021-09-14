import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:nextgame_mobile/models/Adresa.dart';
import 'package:nextgame_mobile/models/Kontakt.dart';

class Korisnik {
  final Id;
  final List<int> Slika;
  final String Username;
  final String? Password;
  final String? datumRodenja;
  final Kontakt? kontakt;
  final Adresa? adresa;
  final String? Opis;
//public List<ListaIgrica> ListaIgrica

  Korisnik(
      {required this.Id,
      required this.Username,
      this.Password,
      required this.Slika,
      this.kontakt,
      this.adresa,
      this.datumRodenja,
      this.Opis});

  factory Korisnik.fromJson(Map<String, dynamic> json) {
    String stringByte = json["slika"] as String;
    List<int> bytes = base64.decode(stringByte);
    return Korisnik(
        Id: int.parse(json["id"].toString()),
        Username: json["username"],
        Slika: bytes,
        datumRodenja: json["datumRođenja"].toString(),
        kontakt: json["kontakt"] != null
            ? Kontakt.fromJson(json["kontakt"])
            : json["kontakt"],
        adresa: json["adresa"] != null
            ? Adresa.fromJson(json["adresa"])
            : json["adresa"],
        Opis: json["opis"]);
  }

  Map<String, dynamic> toJson() => {
        "id" : Id,
        "username": Username,
        "password": Password,
        "slika": base64Encode(Slika)
      };

  Map<String, dynamic> toJsonSearch() => {"username": Username};

  Map<String, dynamic> toJsonUpdate() => {
        "slika": base64Encode(Slika),
        "password": Password,
        "datumRođenja": datumRodenja != null
            ? new DateFormat("dd/MM/yyy").parse(datumRodenja!).toIso8601String()
            : datumRodenja,
        "adresa": adresa!.toJson(),
        "kontakt": kontakt!.toJson(),
        "opis": Opis
      };
}
