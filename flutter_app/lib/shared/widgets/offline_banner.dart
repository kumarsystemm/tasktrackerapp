import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_tracker/core/database/app_database.dart';
import 'package:task_tracker/core/network/connectivity_service.dart';

/// Persistent banner that shows when device is offline.
/// Wraps the app and conditionally displays a yellow warning bar.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(connectivityStatusProvider);

    return Column(
      children: [
        if (status == ConnectivityStatus.offline)
          Material(
            color: Colors.orange.shade700,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.wifi_off, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FutureBuilder<int>(
                        future: AppDatabase.getSyncQueueCount(),
                        builder: (context, snapshot) {
                          final count = snapshot.data ?? 0;
                          final text = count > 0
                              ? 'Offline — $count perubahan menunggu sync'
                              : 'Tidak ada koneksi internet';
                          return Text(
                            text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                    Icon(
                      Icons.cloud_off,
                      color: Colors.white.withOpacity(0.7),
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        Expanded(child: child),
      ],
    );
  }
}
