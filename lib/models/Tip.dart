class Tip{
  final id;
  final String naziv;

  Tip({
    required this.id,
    required this.naziv
  });

  factory Tip.fromJson(Map<String, dynamic> json) {
    return Tip(
        id: int.parse(json["id"].toString()),
        naziv: json["naziv"].toString()
    );
  }

  Map<String, dynamic> toJsonSearch() => {
    "id": id.toString(),
    "naziv": naziv
  };
}