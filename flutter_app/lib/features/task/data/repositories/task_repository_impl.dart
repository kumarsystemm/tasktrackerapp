import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          return Result.failure(const CacheFailure());
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
          return Result.failure(const CacheFailure());
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
      return Result.failure(mapExceptionToFailure(e));
    }
  }
}
