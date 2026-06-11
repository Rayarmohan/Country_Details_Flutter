import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = StreamProvider<bool>((ref) {
  final connectivity = Connectivity();
  return connectivity.onConnectivityChanged.map(
    (result) => !result.contains(ConnectivityResult.none),
  );
});

final isOnlineProvider = FutureProvider<bool>((ref) async {
  final connectivity = Connectivity();
  final result = await connectivity.checkConnectivity();
  return !result.contains(ConnectivityResult.none);
});
