// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'task_status.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@Freezed()
class Task with _$Task {
  const factory Task({
    /// Unique identifier (UUID v4)
    required String id,

    /// Task title
    required String title,

    /// Task description
    required String description,

    /// Task status
    required TaskStatus status,

    /// Creation timestamp (RFC3339)
    @JsonKey(name: 'created_at')
    required DateTime createdAt,

    /// Last update timestamp (RFC3339)
    @JsonKey(name: 'updated_at')
    required DateTime updatedAt,
  }) = _Task;
  
  factory Task.fromJson(Map<String, Object?> json) => _$TaskFromJson(json);
}
