import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_tracker/features/task/data/models/task_model.dart';
import 'package:task_tracker/features/task/data/sources/task_remote_source.dart';
import 'package:task_tracker/features/task/domain/repositories/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl(ref.watch(taskRemoteSourceProvider));
});

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteSource _remoteSource;

  TaskRepositoryImpl(this._remoteSource);

  @override
  Future<PaginatedTasksResponse> getTasks({
    String? search,
    String? status,
    int page = 1,
    int limit = 10,
  }) {
    return _remoteSource.getTasks(
      search: search,
      status: status,
      page: page,
      limit: limit,
    );
  }

  @override
  Future<Task> getTaskById(String id) {
    return _remoteSource.getTaskById(id);
  }

  @override
  Future<Task> createTask({
    required String title,
    required String description,
  }) {
    return _remoteSource.createTask(title: title, description: description);
  }

  @override
  Future<Task> updateTask({
    required String id,
    required String title,
    required String description,
  }) {
    return _remoteSource.updateTask(id: id, title: title, description: description);
  }

  @override
  Future<void> deleteTask(String id) {
    return _remoteSource.deleteTask(id);
  }

  @override
  Future<Task> updateTaskStatus({
    required String id,
    required String status,
  }) {
    return _remoteSource.updateTaskStatus(id: id, status: status);
  }
}
