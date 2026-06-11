import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/country.dart';
import '../models/country_model.dart';

class CountryLocalDataSource {
  Future<Box<String>> _getBox() async {
    return await Hive.openBox<String>(AppConstants.hiveBoxName);
  }

  Future<void> cacheCountries(List<Country> countries) async {
    final box = await _getBox();
    final jsonString = CountryModel.encodeList(countries);
    await box.put(AppConstants.hiveCountriesKey, jsonString);
    await box.put(
      AppConstants.hiveLastSyncKey,
      DateTime.now().toIso8601String(),
    );
  }

  Future<List<Country>> getCachedCountries() async {
    final box = await _getBox();
    final jsonString = box.get(AppConstants.hiveCountriesKey);
    if (jsonString == null || jsonString.isEmpty) return [];
    return CountryModel.decodeList(jsonString);
  }

  Future<DateTime?> getLastSyncTime() async {
    final box = await _getBox();
    final lastSync = box.get(AppConstants.hiveLastSyncKey);
    if (lastSync == null) return null;
    return DateTime.tryParse(lastSync);
  }
}
