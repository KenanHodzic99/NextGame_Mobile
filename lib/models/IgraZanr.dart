class IgraZanr{
  final igraId;
  final zanrId;

  IgraZanr({
    required this.igraId,
    required this.zanrId
  });

  factory IgraZanr.fromJson(Map<String, dynamic> json) {
    return IgraZanr(
        igraId: int.parse(json["igricaId"].toString()),
        zanrId: int.parse(json["zanrId"].toString()));
  }

  Map<String, dynamic> toJsonSearch() => {
    "igricaId": igraId.toString(),
    "zanrId": zanrId.toString()
  };
}

