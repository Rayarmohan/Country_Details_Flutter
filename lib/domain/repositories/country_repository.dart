import '../entities/country.dart';

abstract class CountryRepository {
  Future<List<Country>> getCountries();
  Future<void> cacheCountries(List<Country> countries);
  Future<List<Country>> getCachedCountries();
  Future<DateTime?> getLastSyncTime();
  Future<void> setLastSyncTime(DateTime time);
}
