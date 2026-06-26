import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_tracker/core/database/app_database.dart';
import 'package:task_tracker/core/network/connectivity_service.dart';
import 'package:task_tracker/features/task/data/models/task_model.dart';
import 'package:task_tracker/features/task/data/sources/task_remote_source.dart';
import 'package:task_tracker/features/task/domain/repositories/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl(
    ref.watch(taskRemoteSourceProvider),
    ref.watch(connectivityServiceProvider),
  );
});

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteSource _remoteSource;
  final ConnectivityService _connectivity;

  TaskRepositoryImpl(this._remoteSource, this._connectivity);

  @override
  Future<PaginatedTasksResponse> getTasks({
    String? search,
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _remoteSource.getTasks(
        search: search,
        status: status,
        page: page,
        limit: limit,
      );
      await AppDatabase.insertTasks(response.tasks);
      return response;
    } catch (e) {
      if (await _connectivity.checkStatus() == ConnectivityStatus.offline) {
        final localTasks = await AppDatabase.getAllTasks();
        return PaginatedTasksResponse(
          tasks: localTasks,
          pagination: PaginationMeta(
            page: 1,
            limit: localTasks.length,
            total: localTasks.length,
            totalPages: 1,
          ),
        );
      }
      rethrow;
    }
  }

  @override
  Future<Task> getTaskById(String id) async {
    try {
      final task = await _remoteSource.getTaskById(id);
      await AppDatabase.insertTask(task);
      return task;
    } catch (e) {
      if (await _connectivity.checkStatus() == ConnectivityStatus.offline) {
        final localTask = await AppDatabase.getTaskById(id);
        if (localTask != null) return localTask;
      }
      rethrow;
    }
  }

  @override
  Future<Task> createTask({
    required String title,
    required String description,
  }) async {
    final task = await _remoteSource.createTask(
      title: title,
      description: description,
    );
    await AppDatabase.insertTask(task);
    return task;
  }

  @override
  Future<Task> updateTask({
    required String id,
    required String title,
    required String description,
  }) async {
    final task = await _remoteSource.updateTask(
      id: id,
      title: title,
      description: description,
    );
    await AppDatabase.updateTask(task);
    return task;
  }

  @override
  Future<void> deleteTask(String id) async {
    await _remoteSource.deleteTask(id);
    await AppDatabase.deleteTask(id);
  }

  @override
  Future<Task> updateTaskStatus({
    required String id,
    required String status,
  }) async {
    final task = await _remoteSource.updateTaskStatus(id: id, status: status);
    await AppDatabase.updateTask(task);
    return task;
  }
}
