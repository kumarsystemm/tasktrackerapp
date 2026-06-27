import 'package:task_tracker/api/export.dart' as api;
import 'package:task_tracker/features/task/domain/entities/task_entity.dart';

/// Mapper antara data layer (generated API models) dan domain layer (TaskEntity).
class TaskMapper {
  /// Convert generated [api.Task] -> [TaskEntity] (domain entity).
  static TaskEntity toEntity(api.Task model) {
    return TaskEntity(
      id: model.id,
      title: model.title,
      description: model.description,
      status: _mapApiStatus(model.status),
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  /// Convert [List<api.Task>] -> [List<TaskEntity>].
  static List<TaskEntity> toEntityList(List<api.Task> models) {
    return models.map(toEntity).toList();
  }

  /// Convert generated [api.TaskListResponse] -> [PaginatedTasks] (domain).
  static PaginatedTasks toPaginatedEntity(api.TaskListResponse response) {
    return PaginatedTasks(
      tasks: toEntityList(response.data.tasks),
      pagination: PaginationInfo(
        page: response.data.pagination.page,
        limit: response.data.pagination.limit,
        total: response.data.pagination.total,
        totalPages: response.data.pagination.totalPages,
      ),
    );
  }

  /// Map generated [api.TaskStatus] -> domain [TaskStatus].
  static TaskStatus _mapApiStatus(api.TaskStatus status) {
    switch (status) {
      case api.TaskStatus.pending:
        return TaskStatus.pending;
      case api.TaskStatus.done:
        return TaskStatus.done;
      case api.TaskStatus.$unknown:
        return TaskStatus.pending;
    }
  }
}
