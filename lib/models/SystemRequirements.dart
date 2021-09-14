class SystemRequirements {
  final String operativniSistem;
  final String procesor;
  final String ram;
  final String grafickaKartica;
  final String memorija;

  SystemRequirements({
    required this.operativniSistem,
    required this.procesor,
    required this.ram,
    required this.grafickaKartica,
    required this.memorija,
  });

  factory SystemRequirements.fromJson(Map<String, dynamic> json) {
    return SystemRequirements(
        operativniSistem: json["operativniSistem"],
        procesor: json["procesor"],
        ram: json["ram"],
        grafickaKartica: json["grafickaKartica"],
        memorija: json["memorija"]);
  }
}
