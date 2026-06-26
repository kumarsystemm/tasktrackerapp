import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    required String description,
    required String status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}

@freezed
class PaginationMeta with _$PaginationMeta {
  const factory PaginationMeta({
    required int page,
    required int limit,
    required int total,
    @JsonKey(name: 'total_pages') required int totalPages,
  }) = _PaginationMeta;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) => _$PaginationMetaFromJson(json);
}

@freezed
class PaginatedTasksResponse with _$PaginatedTasksResponse {
  const factory PaginatedTasksResponse({
    required List<Task> tasks,
    required PaginationMeta pagination,
  }) = _PaginatedTasksResponse;

  factory PaginatedTasksResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return _$PaginatedTasksResponseFromJson(data);
  }
}
