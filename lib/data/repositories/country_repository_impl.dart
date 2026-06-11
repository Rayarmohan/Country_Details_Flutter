import '../../domain/entities/country.dart';
import '../../domain/repositories/country_repository.dart';
import '../datasources/country_local_datasource.dart';
import '../datasources/country_remote_datasource.dart';

class CountryRepositoryImpl implements CountryRepository {
  final CountryRemoteDataSource remoteDataSource;
  final CountryLocalDataSource localDataSource;

  CountryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Country>> getCountries() async {
    final remote = await remoteDataSource.getAllCountries();
    await localDataSource.cacheCountries(remote);
    return remote;
  }

  @override
  Future<List<Country>> getCachedCountries() async {
    return localDataSource.getCachedCountries();
  }

  @override
  Future<void> cacheCountries(List<Country> countries) async {
    await localDataSource.cacheCountries(countries);
  }

  @override
  Future<DateTime?> getLastSyncTime() async {
    return localDataSource.getLastSyncTime();
  }

  @override
  Future<void> setLastSyncTime(DateTime time) async {}
}
