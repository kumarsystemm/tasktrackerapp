import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectivityStatus { online, offline }

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
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
