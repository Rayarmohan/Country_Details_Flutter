import 'dart:convert';
import '../../domain/entities/country.dart';

class CountryModel extends Country {
  const CountryModel({
    required super.name,
    super.capital,
    required super.region,
    super.subregion,
    required super.flagUrl,
    super.coatOfArmsUrl,
    required super.population,
    super.area,
    super.currencies,
    super.languages,
    super.timezones,
    super.continents,
    super.googleMapsUrl,
    super.nativeNames,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    final names = json['names'] as Map<String, dynamic>? ?? {};
    final nativeRaw = names['native'] is Map<String, dynamic>
        ? names['native'] as Map<String, dynamic>
        : null;
    final capitalsRaw = json['capitals'] as List<dynamic>?;
    final flag = json['flag'] as Map<String, dynamic>?;
    final area = json['area'] as Map<String, dynamic>?;
    final currenciesRaw = json['currencies'] as List<dynamic>?;
    final languagesRaw = json['languages'] as List<dynamic>?;
    final linksRaw = json['links'] as Map<String, dynamic>?;

    return CountryModel(
      name: names['common'] as String? ?? '',
      capital: capitalsRaw != null && capitalsRaw.isNotEmpty
          ? (capitalsRaw.first as Map<String, dynamic>)['name'] as String?
          : null,
      region: json['region'] as String? ?? '',
      subregion: json['subregion'] as String?,
      flagUrl: flag?['url_png'] as String? ?? '',
      coatOfArmsUrl: _parseCoatOfArms(json),
      population: (json['population'] as num?)?.toInt() ?? 0,
      area: (area?['kilometers'] as num?)?.toDouble(),
      currencies: currenciesRaw != null
          ? {
              for (final c in currenciesRaw)
                if (c is Map<String, dynamic>)
                  (c['code'] as String? ?? ''): (c['name'] as String? ?? '')
            }
          : {},
      languages: languagesRaw != null
          ? languagesRaw
              .whereType<Map<String, dynamic>>()
              .map((l) => l['name'] as String?)
              .whereType<String>()
              .toList()
          : [],
      timezones: json['timezones'] is List
          ? (json['timezones'] as List).cast<String>()
          : [],
      continents: json['continents'] is List
          ? (json['continents'] as List).cast<String>()
          : [],
      googleMapsUrl: linksRaw?['google_maps'] as String? ?? _parseMaps(json),
      nativeNames: nativeRaw != null
          ? nativeRaw.map((key, value) {
              if (value is Map<String, dynamic>) {
                return MapEntry(key.toString(), value['common'] as String? ?? '');
              }
              return MapEntry(key.toString(), '');
            })
          : {},
    );
  }

  static String? _parseCoatOfArms(Map<String, dynamic> json) {
    final coat = json['coatOfArms'] as Map<String, dynamic>?;
    if (coat != null) {
      return coat['url_png'] as String? ?? coat['png'] as String?;
    }
    return json['coatOfArmsPng'] as String?;
  }

  static String? _parseMaps(Map<String, dynamic> json) {
    final maps = json['maps'] as Map<String, dynamic>?;
    if (maps != null) {
      return maps['googleMaps'] as String?;
    }
    return json['googleMapsUrl'] as String?;
  }

  Map<String, dynamic> toJson() => {
        'names': {'common': name},
        'capitals': capital != null ? [{'name': capital}] : [],
        'region': region,
        'subregion': subregion,
        'flag': {'url_png': flagUrl},
        'area': area != null ? {'kilometers': area} : null,
        'population': population,
        'currencies': currencies.entries
            .map((e) => {'code': e.key, 'name': e.value})
            .toList(),
        'languages': languages.map((l) => {'name': l}).toList(),
        'timezones': timezones,
        'continents': continents,
        'links': {'google_maps': googleMapsUrl},
      };

  factory CountryModel.fromEntity(Country country) {
    return CountryModel(
      name: country.name,
      capital: country.capital,
      region: country.region,
      subregion: country.subregion,
      flagUrl: country.flagUrl,
      coatOfArmsUrl: country.coatOfArmsUrl,
      population: country.population,
      area: country.area,
      currencies: country.currencies,
      languages: country.languages,
      timezones: country.timezones,
      continents: country.continents,
      googleMapsUrl: country.googleMapsUrl,
      nativeNames: country.nativeNames,
    );
  }

  static String encodeList(List<Country> countries) {
    final models = countries.map((c) => CountryModel.fromEntity(c).toJson()).toList();
    return jsonEncode(models);
  }

  static List<Country> decodeList(String jsonString) {
    final dynamic decoded = jsonDecode(jsonString);

    List<dynamic> targetList;
    if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
      targetList = (decoded['data'] as Map<String, dynamic>)['objects'] as List;
    } else if (decoded is List) {
      targetList = decoded;
    } else {
      return [];
    }

    return targetList
        .map((e) => CountryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
