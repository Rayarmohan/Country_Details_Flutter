import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../models/country_model.dart';

class CountryRemoteDataSource {
  final ApiClient _apiClient;

  CountryRemoteDataSource(this._apiClient);

  Future<List<CountryModel>> getAllCountries() async {
    final response = await _apiClient.get(
      AppConstants.allCountriesEndpoint,
    );

    final body = response.data as Map<String, dynamic>;
    final innerData = body['data'] as Map<String, dynamic>;
    final objects = innerData['objects'] as List<dynamic>;

    debugPrint('v5 API returned ${objects.length} objects');
    if (objects.isNotEmpty) {
      debugPrint('First object keys: ${(objects.first as Map<String, dynamic>).keys}');
      debugPrint('Raw first object:\n${const JsonEncoder.withIndent('  ').convert(objects.first as Map<String, dynamic>)}');
    }

    return objects
        .map((e) => CountryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
