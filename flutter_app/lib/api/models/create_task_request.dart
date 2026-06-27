// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_task_request.freezed.dart';
part 'create_task_request.g.dart';

@Freezed()
class CreateTaskRequest with _$CreateTaskRequest {
  const factory CreateTaskRequest({
    /// Task title
    required String title,

    /// Task description
    required String description,
  }) = _CreateTaskRequest;
  
  factory CreateTaskRequest.fromJson(Map<String, Object?> json) => _$CreateTaskRequestFromJson(json);
}
