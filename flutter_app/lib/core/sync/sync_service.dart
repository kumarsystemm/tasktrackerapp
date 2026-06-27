import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_tracker/core/database/app_database.dart';
import 'package:task_tracker/core/network/connectivity_service.dart';
import 'package:task_tracker/features/task/data/sources/task_remote_source.dart';

/// Provider for SyncService.
final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    ref.watch(taskRemoteSourceProvider),
    ref.watch(connectivityServiceProvider),
  );
});

/// Provider that tracks pending sync count.
final pendingSyncCountProvider = StateProvider<int>((ref) => 0);

class SyncService {
  SyncService(this._remoteSource, this._connectivity);

  final TaskRemoteSource _remoteSource;
  final ConnectivityService _connectivity;

  /// Process all pending operations in the sync queue.
  /// Returns the number of successfully synced items.
  Future<int> processQueue() async {
    final isOnline = await _connectivity.checkStatus() == ConnectivityStatus.online;
    if (!isOnline) return 0;

    final queue = await AppDatabase.getSyncQueue();
    var syncedCount = 0;

    for (final item in queue) {
      final operation = item['operation'] as String;
      final entityId = item['entity_id'] as String?;
      final payload = jsonDecode(item['payload'] as String) as Map<String, dynamic>;
      final queueId = item['id'] as int;

      try {
        switch (operation) {
          case 'create':
            await _remoteSource.createTask(
              title: payload['title'] as String,
              description: payload['description'] as String,
            );
          case 'update':
            if (entityId != null) {
              await _remoteSource.updateTask(
                id: entityId,
                title: payload['title'] as String,
                description: payload['description'] as String,
              );
            }
          case 'delete':
            if (entityId != null) {
              await _remoteSource.deleteTask(entityId);
            }
          case 'update_status':
            if (entityId != null) {
              await _remoteSource.updateTaskStatus(
                id: entityId,
                status: payload['status'] as String,
              );
            }
        }
        await AppDatabase.removeSyncQueueItem(queueId);
        syncedCount++;
      } catch (_) {
        // Stop processing on first failure — retry on next sync.
        break;
      }
    }

    // Update pending count.
    final remaining = await AppDatabase.getSyncQueueCount();
    return syncedCount;
  }

  /// Get current pending sync count.
  Future<int> getPendingCount() async {
    return AppDatabase.getSyncQueueCount();
  }
}
