// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'paginated_tasks_data.dart';

part 'task_list_response.freezed.dart';
part 'task_list_response.g.dart';

@Freezed()
class TaskListResponse with _$TaskListResponse {
  const factory TaskListResponse({
    required bool success,
    required String message,
    required PaginatedTasksData data,
  }) = _TaskListResponse;
  
  factory TaskListResponse.fromJson(Map<String, Object?> json) => _$TaskListResponseFromJson(json);
}
