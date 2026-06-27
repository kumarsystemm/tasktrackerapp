import 'package:task_tracker/core/errors/result.dart';
import 'package:task_tracker/features/task/domain/entities/task_entity.dart';

/// Abstract repository interface di domain layer.
/// Hanya reference domain entities, bukan data models.
abstract class TaskRepository {
  Future<Result<PaginatedTasks>> getTasks({
    String? search,
    String? status,
    int page = 1,
    int limit = 10,
  });

  Future<Result<TaskEntity>> getTaskById(String id);

  Future<Result<TaskEntity>> createTask({
    required String title,
    required String description,
  });

  Future<Result<TaskEntity>> updateTask({
    required String id,
    required String title,
    required String description,
  });

  Future<Result<void>> deleteTask(String id);

  Future<Result<TaskEntity>> updateTaskStatus({
    required String id,
    required TaskStatus status,
  });
}
