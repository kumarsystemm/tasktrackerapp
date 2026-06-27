// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_task_request.freezed.dart';
part 'update_task_request.g.dart';

@Freezed()
class UpdateTaskRequest with _$UpdateTaskRequest {
  const factory UpdateTaskRequest({
    /// Task title
    required String title,

    /// Task description
    required String description,
  }) = _UpdateTaskRequest;
  
  factory UpdateTaskRequest.fromJson(Map<String, Object?> json) => _$UpdateTaskRequestFromJson(json);
}
