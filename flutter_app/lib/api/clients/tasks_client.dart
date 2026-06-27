// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_task_request.dart';
import '../models/delete_response.dart';
import '../models/status.dart';
import '../models/task_list_response.dart';
import '../models/task_response.dart';
import '../models/update_status_request.dart';
import '../models/update_task_request.dart';

part 'tasks_client.g.dart';

@RestApi()
abstract class TasksClient {
  factory TasksClient(Dio dio, {String? baseUrl}) = _TasksClient;

  /// Get all tasks.
  ///
  /// Retrieve a paginated list of tasks with optional search and status filter.
  ///
  /// [search] - Search keyword for title/description.
  ///
  /// [status] - Filter by task status.
  ///
  /// [page] - Page number.
  ///
  /// [limit] - Items per page.
  @GET('/tasks')
  Future<TaskListResponse> getTasks({
    @Query('search') String? search,
    @Query('status') Status? status,
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  /// Create a new task.
  ///
  /// Create a new task with title and description. Status defaults to "pending".
  @POST('/tasks')
  Future<TaskResponse> createTask({
    @Body() required CreateTaskRequest body,
  });

  /// Get task by ID.
  ///
  /// Retrieve a single task by its UUID.
  ///
  /// [id] - Task UUID.
  @GET('/tasks/{id}')
  Future<TaskResponse> getTaskById({
    @Path('id') required String id,
  });

  /// Update task.
  ///
  /// Update task title and description.
  ///
  /// [id] - Task UUID.
  @PUT('/tasks/{id}')
  Future<TaskResponse> updateTask({
    @Path('id') required String id,
    @Body() required UpdateTaskRequest body,
  });

  /// Delete task.
  ///
  /// Delete a task by its UUID.
  ///
  /// [id] - Task UUID.
  @DELETE('/tasks/{id}')
  Future<DeleteResponse> deleteTask({
    @Path('id') required String id,
  });

  /// Update task status.
  ///
  /// Update only the status of a task (pending or done).
  ///
  /// [id] - Task UUID.
  @PATCH('/tasks/{id}/status')
  Future<TaskResponse> updateTaskStatus({
    @Path('id') required String id,
    @Body() required UpdateStatusRequest body,
  });
}
