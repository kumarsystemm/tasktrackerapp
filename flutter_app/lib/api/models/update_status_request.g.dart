// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_status_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateStatusRequestImpl _$$UpdateStatusRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateStatusRequestImpl(
      status: UpdateStatusRequestStatus.fromJson(json['status'] as String),
    );

Map<String, dynamic> _$$UpdateStatusRequestImplToJson(
        _$UpdateStatusRequestImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
    };
