// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskListResponseImpl _$$TaskListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$TaskListResponseImpl(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: PaginatedTasksData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TaskListResponseImplToJson(
        _$TaskListResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };
