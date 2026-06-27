import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectivityStatus { online, offline }

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

/// Real-time connectivity status as a StreamProvider.
final connectivityStreamProvider = StreamProvider<ConnectivityStatus>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.onConnectivityChanged.map((results) {
    if (results.any((r) => r == ConnectivityResult.none)) {
      return ConnectivityStatus.offline;
    }
    return ConnectivityStatus.online;
  });
});

/// Current connectivity status (starts as online, updates via stream).
final connectivityStatusProvider = StateProvider<ConnectivityStatus>((ref) {
  return ConnectivityStatus.online;
});

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Future<ConnectivityStatus> checkStatus() async {
    final results = await _connectivity.checkConnectivity();
    if (results.any((r) => r == ConnectivityResult.none)) {
      return ConnectivityStatus.offline;
    }
    return ConnectivityStatus.online;
  }

  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }
}
