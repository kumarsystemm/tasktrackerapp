// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_tasks_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginatedTasksDataImpl _$$PaginatedTasksDataImplFromJson(
        Map<String, dynamic> json) =>
    _$PaginatedTasksDataImpl(
      tasks: (json['tasks'] as List<dynamic>)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination:
          PaginationMeta.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PaginatedTasksDataImplToJson(
        _$PaginatedTasksDataImpl instance) =>
    <String, dynamic>{
      'tasks': instance.tasks,
      'pagination': instance.pagination,
    };
