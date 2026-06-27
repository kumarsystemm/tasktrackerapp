// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_response.freezed.dart';
part 'delete_response.g.dart';

@Freezed()
class DeleteResponse with _$DeleteResponse {
  const factory DeleteResponse({
    required bool success,
    required String message,
  }) = _DeleteResponse;
  
  factory DeleteResponse.fromJson(Map<String, Object?> json) => _$DeleteResponseFromJson(json);
}
