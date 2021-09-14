class Kontakt {
  final Id;
  final String? ime;
  final String? prezime;
  final String? email;
  final String? brojTelefona;

  Kontakt({this.Id, this.brojTelefona, this.email, this.ime, this.prezime});

  factory Kontakt.fromJson(Map<String, dynamic> json) {
    return Kontakt(
        ime: json["ime"],
        prezime: json["prezime"],
        email: json["email"],
        brojTelefona: json["brojTelefona"]);
  }

  Map<String, dynamic> toJson() => {
        "ime": ime,
        "prezime": prezime,
        "email": email,
        "brojTelefona": brojTelefona
      };
}
