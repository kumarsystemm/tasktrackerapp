import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_tracker/api/models/task.dart' as api;
import 'package:task_tracker/api/models/task_status.dart' as api_status;
import 'package:task_tracker/core/database/app_database.dart';
import 'package:task_tracker/core/errors/failures.dart';
import 'package:task_tracker/core/errors/result.dart';
import 'package:task_tracker/core/network/connectivity_service.dart';
import 'package:task_tracker/features/task/data/mappers/task_mapper.dart';
import 'package:task_tracker/features/task/data/sources/task_remote_source.dart';
import 'package:task_tracker/features/task/domain/entities/task_entity.dart';
import 'package:task_tracker/features/task/domain/repositories/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl(
    ref.watch(taskRemoteSourceProvider),
    ref.watch(connectivityServiceProvider),
  );
});

class TaskRepositoryImpl implements TaskRepository {

  TaskRepositoryImpl(this._remoteSource, this._connectivity);
  final TaskRemoteSource _remoteSource;
  final ConnectivityService _connectivity;

  @override
  Future<Result<PaginatedTasks>> getTasks({
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
      await AppDatabase.insertTasks(response.data.tasks);
      return Result.success(TaskMapper.toPaginatedEntity(response));
    } catch (e) {
      if (await _connectivity.checkStatus() == ConnectivityStatus.offline) {
        try {
          final localTasks = await AppDatabase.getAllTasks();
          final entities = TaskMapper.toEntityList(localTasks);
          return Result.success(PaginatedTasks(
            tasks: entities,
            pagination: PaginationInfo(
              page: 1,
              limit: entities.length,
              total: entities.length,
              totalPages: 1,
            ),
          ),);
        } catch (_) {
          return Result.failure(const NetworkFailure());
        }
      }
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<TaskEntity>> getTaskById(String id) async {
    try {
      final task = await _remoteSource.getTaskById(id);
      await AppDatabase.insertTask(task);
      return Result.success(TaskMapper.toEntity(task));
    } catch (e) {
      if (await _connectivity.checkStatus() == ConnectivityStatus.offline) {
        try {
          final localTask = await AppDatabase.getTaskById(id);
          if (localTask != null) {
            return Result.success(TaskMapper.toEntity(localTask));
          }
        } catch (_) {
          return Result.failure(const NetworkFailure());
        }
      }
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<TaskEntity>> createTask({
    required String title,
    required String description,
  }) async {
    try {
      final task = await _remoteSource.createTask(
        title: title,
        description: description,
      );
      await AppDatabase.insertTask(task);
      return Result.success(TaskMapper.toEntity(task));
    } catch (e) {
      if (await _connectivity.checkStatus() == ConnectivityStatus.offline) {
        return _createTaskOffline(title: title, description: description);
      }
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<TaskEntity>> updateTask({
    required String id,
    required String title,
    required String description,
  }) async {
    try {
      final task = await _remoteSource.updateTask(
        id: id,
        title: title,
        description: description,
      );
      await AppDatabase.updateTask(task);
      return Result.success(TaskMapper.toEntity(task));
    } catch (e) {
      if (await _connectivity.checkStatus() == ConnectivityStatus.offline) {
        return _updateTaskOffline(id: id, title: title, description: description);
      }
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<void>> deleteTask(String id) async {
    try {
      await _remoteSource.deleteTask(id);
      await AppDatabase.deleteTask(id);
      return Result.success(null);
    } catch (e) {
      if (await _connectivity.checkStatus() == ConnectivityStatus.offline) {
        return _deleteTaskOffline(id);
      }
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<TaskEntity>> updateTaskStatus({
    required String id,
    required TaskStatus status,
  }) async {
    try {
      final task = await _remoteSource.updateTaskStatus(
        id: id,
        status: status.value,
      );
      await AppDatabase.updateTask(task);
      return Result.success(TaskMapper.toEntity(task));
    } catch (e) {
      if (await _connectivity.checkStatus() == ConnectivityStatus.offline) {
        return _updateTaskStatusOffline(id: id, status: status);
      }
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  // --- Offline helpers ---

  Future<Result<TaskEntity>> _createTaskOffline({
    required String title,
    required String description,
  }) async {
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();

    // Create a local api.Task to insert into DB.
    final localTask = api.Task(
      id: tempId,
      title: title,
      description: description,
      status: api_status.TaskStatus.pending,
      createdAt: now,
      updatedAt: now,
    );

    await AppDatabase.insertTask(localTask);
    await AppDatabase.addToSyncQueue(
      operation: 'create',
      tempId: tempId,
      payload: {'title': title, 'description': description},
    );

    return Result.success(TaskMapper.toEntity(localTask));
  }

  Future<Result<TaskEntity>> _updateTaskOffline({
    required String id,
    required String title,
    required String description,
  }) async {
    final existing = await AppDatabase.getTaskById(id);
    if (existing == null) {
      return Result.failure(const NotFoundFailure());
    }

    final updated = existing.copyWith(
      title: title,
      description: description,
      updatedAt: DateTime.now(),
    );

    await AppDatabase.updateTask(updated);
    await AppDatabase.addToSyncQueue(
      operation: 'update',
      entityId: id,
      payload: {'title': title, 'description': description},
    );

    return Result.success(TaskMapper.toEntity(updated));
  }

  Future<Result<void>> _deleteTaskOffline(String id) async {
    await AppDatabase.deleteTask(id);
    await AppDatabase.addToSyncQueue(
      operation: 'delete',
      entityId: id,
      payload: {},
    );

    return Result.success(null);
  }

  Future<Result<TaskEntity>> _updateTaskStatusOffline({
    required String id,
    required TaskStatus status,
  }) async {
    final existing = await AppDatabase.getTaskById(id);
    if (existing == null) {
      return Result.failure(const NotFoundFailure());
    }

    final updated = existing.copyWith(
      status: api_status.TaskStatus.fromJson(status.value),
      updatedAt: DateTime.now(),
    );

    await AppDatabase.updateTask(updated);
    await AppDatabase.addToSyncQueue(
      operation: 'update_status',
      entityId: id,
      payload: {'status': status.value},
    );

    return Result.success(TaskMapper.toEntity(updated));
  }
}
