// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ErrorResponseImpl _$$ErrorResponseImplFromJson(Map<String, dynamic> json) =>
    _$ErrorResponseImpl(
      success: json['success'] as bool,
      message: json['message'] as String,
      errors: json['errors'] as String?,
    );

Map<String, dynamic> _$$ErrorResponseImplToJson(_$ErrorResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'errors': instance.errors,
    };
