// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'pagination_meta.dart';
import 'task.dart';

part 'paginated_tasks_data.freezed.dart';
part 'paginated_tasks_data.g.dart';

@Freezed()
class PaginatedTasksData with _$PaginatedTasksData {
  const factory PaginatedTasksData({
    required List<Task> tasks,
    required PaginationMeta pagination,
  }) = _PaginatedTasksData;
  
  factory PaginatedTasksData.fromJson(Map<String, Object?> json) => _$PaginatedTasksDataFromJson(json);
}
