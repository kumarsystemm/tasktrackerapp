// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskResponseImpl _$$TaskResponseImplFromJson(Map<String, dynamic> json) =>
    _$TaskResponseImpl(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: Task.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TaskResponseImplToJson(_$TaskResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };
