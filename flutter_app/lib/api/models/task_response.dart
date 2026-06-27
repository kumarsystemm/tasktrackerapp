// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'task.dart';

part 'task_response.freezed.dart';
part 'task_response.g.dart';

@Freezed()
class TaskResponse with _$TaskResponse {
  const factory TaskResponse({
    required bool success,
    required String message,
    required Task data,
  }) = _TaskResponse;
  
  factory TaskResponse.fromJson(Map<String, Object?> json) => _$TaskResponseFromJson(json);
}
