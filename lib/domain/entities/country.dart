class Country {
  final String name;
  final String? capital;
  final String region;
  final String? subregion;
  final String flagUrl;
  final String? coatOfArmsUrl;
  final int population;
  final double? area;
  final Map<String, String> currencies;
  final List<String> languages;
  final List<String> timezones;
  final List<String> continents;
  final String? googleMapsUrl;
  final Map<String, String> nativeNames;

  const Country({
    required this.name,
    this.capital,
    required this.region,
    this.subregion,
    required this.flagUrl,
    this.coatOfArmsUrl,
    required this.population,
    this.area,
    this.currencies = const {},
    this.languages = const [],
    this.timezones = const [],
    this.continents = const [],
    this.googleMapsUrl,
    this.nativeNames = const {},
  });
}
