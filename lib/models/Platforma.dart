class Platforma{
  final id;
  final String naziv;

  Platforma({
    required this.id,
    required this.naziv
  });

  factory Platforma.fromJson(Map<String, dynamic> json) {
    return Platforma(
        id: int.parse(json["id"].toString()),
        naziv: json["naziv"].toString()
    );
  }

  Map<String, dynamic> toJsonSearch() => {
    "id": id.toString(),
    "naziv": naziv
  };
}