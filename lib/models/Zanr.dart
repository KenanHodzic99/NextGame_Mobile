class Zanr{
  final id;
  final String naziv;

  Zanr({
    required this.id,
    required this.naziv
  });

  factory Zanr.fromJson(Map<String, dynamic> json) {
    return Zanr(
        id: int.parse(json["id"].toString()),
        naziv: json["naziv"].toString()
    );
  }

  Map<String, dynamic> toJsonSearch() => {
    "id": id.toString(),
    "naziv": naziv
  };
}