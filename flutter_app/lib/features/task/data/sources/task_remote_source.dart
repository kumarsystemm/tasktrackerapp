import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_tracker/api/export.dart' as api;
import 'package:task_tracker/core/network/dio_client.dart';

final tasksClientProvider = Provider<api.TasksClient>((ref) {
  return api.TasksClient(ref.watch(dioProvider));
});

/// Remote source backed by the generated Retrofit client.
final taskRemoteSourceProvider = Provider<TaskRemoteSource>((ref) {
  return TaskRemoteSource(ref.watch(tasksClientProvider));
});

class TaskRemoteSource {
  TaskRemoteSource(this._client);

  final api.TasksClient _client;

  Future<api.TaskListResponse> getTasks({
    String? search,
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    return _client.getTasks(
      search: search,
      status: status != null && status.isNotEmpty
          ? api.Status.fromJson(status)
          : null,
      page: page,
      limit: limit,
    );
  }

  Future<api.Task> getTaskById(String id) async {
    final response = await _client.getTaskById(id: id);
    return response.data;
  }

  Future<api.Task> createTask({
    required String title,
    required String description,
  }) async {
    final response = await _client.createTask(
      body: api.CreateTaskRequest(title: title, description: description),
    );
    return response.data;
  }

  Future<api.Task> updateTask({
    required String id,
    required String title,
    required String description,
  }) async {
    final response = await _client.updateTask(
      id: id,
      body: api.UpdateTaskRequest(title: title, description: description),
    );
    return response.data;
  }

  Future<void> deleteTask(String id) async {
    await _client.deleteTask(id: id);
  }

  Future<api.Task> updateTaskStatus({
    required String id,
    required String status,
  }) async {
    final response = await _client.updateTaskStatus(
      id: id,
      body: api.UpdateStatusRequest(
        status: api.UpdateStatusRequestStatus.fromJson(status),
      ),
    );
    return response.data;
  }
}
