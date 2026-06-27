// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_task_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateTaskRequestImpl _$$CreateTaskRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateTaskRequestImpl(
      title: json['title'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$$CreateTaskRequestImplToJson(
        _$CreateTaskRequestImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
    };
