import 'package:nextgame_mobile/models/Igra.dart';

class Objava {
  final Id;
  final String naslov;
  final String sadrzaj;
  final String autor;
  final String datumObjave;
  final Igra? igrica;

  Objava(
      {required this.Id,
      required this.sadrzaj,
      this.igrica,
      required this.autor,
      required this.datumObjave,
      required this.naslov});

  factory Objava.fromJson(Map<String, dynamic> json) {
    return Objava(
        Id: int.parse(json["id"].toString()),
        sadrzaj: json["sadrzaj"],
        naslov: json["naslov"],
        autor: json["autor"],
        datumObjave: json["datumObjave"].toString(),
        igrica: Igra.fromJson(json["igrica"]));
  }

  factory Objava.getBasicFromJson(Map<String, dynamic> json) {
    return Objava(
      Id: int.parse(json["id"].toString()),
      sadrzaj: json["sadrzaj"],
      naslov: json["naslov"],
      autor: json["autor"],
      datumObjave: json["datumObjave"].toString(),
    );
  }
}
