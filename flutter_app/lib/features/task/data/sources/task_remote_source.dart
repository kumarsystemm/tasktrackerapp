import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_tracker/core/constants/api_constants.dart';
import 'package:task_tracker/core/network/dio_client.dart';
import 'package:task_tracker/features/task/data/models/task_model.dart';

final taskRemoteSourceProvider = Provider<TaskRemoteSource>((ref) {
  return TaskRemoteSource(ref.watch(dioProvider));
});

class TaskRemoteSource {
  final Dio _dio;

  TaskRemoteSource(this._dio);

  Future<PaginatedTasksResponse> getTasks({
    String? search,
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }

    final response = await _dio.get(
      ApiConstants.tasks,
      queryParameters: queryParams,
    );

    return PaginatedTasksResponse.fromJson(response.data);
  }

  Future<Task> getTaskById(String id) async {
    final response = await _dio.get('${ApiConstants.tasks}/$id');
    return Task.fromJson(response.data['data']);
  }

  Future<Task> createTask({
    required String title,
    required String description,
  }) async {
    final response = await _dio.post(
      ApiConstants.tasks,
      data: {
        'title': title,
        'description': description,
      },
    );
    return Task.fromJson(response.data['data']);
  }

  Future<Task> updateTask({
    required String id,
    required String title,
    required String description,
  }) async {
    final response = await _dio.put(
      '${ApiConstants.tasks}/$id',
      data: {
        'title': title,
        'description': description,
      },
    );
    return Task.fromJson(response.data['data']);
  }

  Future<void> deleteTask(String id) async {
    await _dio.delete('${ApiConstants.tasks}/$id');
  }

  Future<Task> updateTaskStatus({
    required String id,
    required String status,
  }) async {
    final response = await _dio.patch(
      '${ApiConstants.tasks}/$id/status',
      data: {'status': status},
    );
    return Task.fromJson(response.data['data']);
  }
}
