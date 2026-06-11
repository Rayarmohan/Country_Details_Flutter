import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'country_providers.dart';

class SyncState {
  final bool isSyncing;
  final DateTime? lastSyncTime;
  final String? error;

  const SyncState({
    this.isSyncing = false,
    this.lastSyncTime,
    this.error,
  });

  SyncState copyWith({bool? isSyncing, DateTime? lastSyncTime, String? error}) {
    return SyncState(
      isSyncing: isSyncing ?? this.isSyncing,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      error: error,
    );
  }
}

class SyncNotifier extends Notifier<SyncState> {
  @override
  SyncState build() {
    _loadLastSync();
    return const SyncState();
  }

  Future<void> _loadLastSync() async {
    final localDataSource = ref.read(localDataSourceProvider);
    final lastSync = await localDataSource.getLastSyncTime();
    if (lastSync != null) {
      state = SyncState(lastSyncTime: lastSync);
    }
  }

  Future<void> syncNow() async {
    state = state.copyWith(isSyncing: true, error: null);
    try {
      await ref.read(countryListProvider.notifier).syncFromOffline();
      final now = DateTime.now();
      final localDataSource = ref.read(localDataSourceProvider);
      await localDataSource.cacheCountries(
        ref.read(countryListProvider).valueOrNull ?? [],
      );
      state = state.copyWith(isSyncing: false, lastSyncTime: now);
    } catch (e) {
      state = state.copyWith(isSyncing: false, error: e.toString());
    }
  }
}

final syncProvider = NotifierProvider<SyncNotifier, SyncState>(
  SyncNotifier.new,
);

final lastSyncTimeProvider = Provider<DateTime?>((ref) {
  return ref.watch(syncProvider).lastSyncTime;
});
