// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'update_status_request_status.dart';

part 'update_status_request.freezed.dart';
part 'update_status_request.g.dart';

@Freezed()
class UpdateStatusRequest with _$UpdateStatusRequest {
  const factory UpdateStatusRequest({
    /// New task status
    required UpdateStatusRequestStatus status,
  }) = _UpdateStatusRequest;
  
  factory UpdateStatusRequest.fromJson(Map<String, Object?> json) => _$UpdateStatusRequestFromJson(json);
}
