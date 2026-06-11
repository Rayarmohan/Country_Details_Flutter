import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../core/network/connectivity_service.dart';
import '../../data/datasources/country_local_datasource.dart';
import '../../data/datasources/country_remote_datasource.dart';
import '../../data/repositories/country_repository_impl.dart';
import '../../domain/entities/country.dart';
import '../../domain/repositories/country_repository.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());
final remoteDataSourceProvider = Provider<CountryRemoteDataSource>((ref) {
  return CountryRemoteDataSource(ref.watch(apiClientProvider));
});
final localDataSourceProvider = Provider<CountryLocalDataSource>((ref) {
  return CountryLocalDataSource();
});

final countryRepositoryProvider = Provider<CountryRepository>((ref) {
  return CountryRepositoryImpl(
    remoteDataSource: ref.watch(remoteDataSourceProvider),
    localDataSource: ref.watch(localDataSourceProvider),
  );
});

class CountryListNotifier extends AsyncNotifier<List<Country>> {
  @override
  Future<List<Country>> build() async {
    final repo = ref.read(countryRepositoryProvider);
    final isOnline = await ref.read(isOnlineProvider.future);

    try {
      if (isOnline) {
        return await repo.getCountries();
      } else {
        final cached = await repo.getCachedCountries();
        if (cached.isNotEmpty) return cached;
        throw Exception('No internet connection and no cached data available.');
      }
    } catch (e, stackTrace) {
      debugPrint('=== RUNTIME EXCEPTION ===');
      debugPrint('Exception Type: $e');
      debugPrint('Stack Trace:\n$stackTrace');
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(countryRepositoryProvider);
      return await repo.getCountries();
    });
  }

  Future<void> syncFromOffline() async {
    final isOnline = await ref.read(isOnlineProvider.future);
    if (!isOnline) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(countryRepositoryProvider);
      return await repo.getCountries();
    });
  }
}

final countryListProvider =
    AsyncNotifierProvider<CountryListNotifier, List<Country>>(
  CountryListNotifier.new,
);
