import 'package:meta/meta.dart';

/// Domain entity untuk Task.
/// Pure business object, tidak tergantung pada framework, serialization, atau database.
@immutable
class TaskEntity {

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isDone => status == TaskStatus.done;
  bool get isPending => status == TaskStatus.pending;

  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          status == other.status &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(id, title, description, status, createdAt, updatedAt);
}

/// Status enum untuk Task (type-safe, bukan String).
enum TaskStatus {
  pending('pending'),
  done('done');

  const TaskStatus(this.value);

  final String value;

  static TaskStatus fromString(String value) {
    return TaskStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TaskStatus.pending,
    );
  }
}

/// Paginated response entity untuk domain layer.
class PaginatedTasks {

  const PaginatedTasks({
    required this.tasks,
    required this.pagination,
  });
  final List<TaskEntity> tasks;
  final PaginationInfo pagination;
}

/// Pagination metadata entity.
class PaginationInfo {

  const PaginationInfo({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  bool get hasNextPage => page < totalPages;
}
