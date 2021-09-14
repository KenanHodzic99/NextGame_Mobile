class Adresa {
  final Id;
  final String? kontinent;
  final String? drzava;
  final String? grad;
  final String? postanskiBroj;

  Adresa({this.Id, this.kontinent, this.drzava, this.grad, this.postanskiBroj});

  factory Adresa.fromJson(Map<String, dynamic> json) {
    return Adresa(
        kontinent: json["kontinent"],
        drzava: json["drzava"],
        grad: json["grad"],
        postanskiBroj: json["postanskiBroj"]);
  }

  Map<String, dynamic> toJson() => {
        "kontinent": kontinent,
        "drzava": drzava,
        "grad": grad,
        "postanskiBroj": postanskiBroj
      };
}
