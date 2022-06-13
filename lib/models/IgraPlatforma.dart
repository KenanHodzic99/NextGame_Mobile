class IgraPlatforma{
  final igraId;
  final platformaId;

  IgraPlatforma({
    required this.igraId,
    required this.platformaId
  });

  factory IgraPlatforma.fromJson(Map<String, dynamic> json) {
    return IgraPlatforma(
        igraId: int.parse(json["igricaId"].toString()),
        platformaId: int.parse(json["platformaId"].toString())
    );
  }

  Map<String, dynamic> toJsonSearch() => {
    "igricaId": igraId.toString(),
    "platformaId": platformaId.toString()
  };
}