// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TaskListResponse _$TaskListResponseFromJson(Map<String, dynamic> json) {
  return _TaskListResponse.fromJson(json);
}

/// @nodoc
mixin _$TaskListResponse {
  bool get success => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  PaginatedTasksData get data => throw _privateConstructorUsedError;

  /// Serializes this TaskListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskListResponseCopyWith<TaskListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskListResponseCopyWith<$Res> {
  factory $TaskListResponseCopyWith(
          TaskListResponse value, $Res Function(TaskListResponse) then) =
      _$TaskListResponseCopyWithImpl<$Res, TaskListResponse>;
  @useResult
  $Res call({bool success, String message, PaginatedTasksData data});

  $PaginatedTasksDataCopyWith<$Res> get data;
}

/// @nodoc
class _$TaskListResponseCopyWithImpl<$Res, $Val extends TaskListResponse>
    implements $TaskListResponseCopyWith<$Res> {
  _$TaskListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as PaginatedTasksData,
    ) as $Val);
  }

  /// Create a copy of TaskListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaginatedTasksDataCopyWith<$Res> get data {
    return $PaginatedTasksDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TaskListResponseImplCopyWith<$Res>
    implements $TaskListResponseCopyWith<$Res> {
  factory _$$TaskListResponseImplCopyWith(_$TaskListResponseImpl value,
          $Res Function(_$TaskListResponseImpl) then) =
      __$$TaskListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, String message, PaginatedTasksData data});

  @override
  $PaginatedTasksDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$TaskListResponseImplCopyWithImpl<$Res>
    extends _$TaskListResponseCopyWithImpl<$Res, _$TaskListResponseImpl>
    implements _$$TaskListResponseImplCopyWith<$Res> {
  __$$TaskListResponseImplCopyWithImpl(_$TaskListResponseImpl _value,
      $Res Function(_$TaskListResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? data = null,
  }) {
    return _then(_$TaskListResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as PaginatedTasksData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskListResponseImpl implements _TaskListResponse {
  const _$TaskListResponseImpl(
      {required this.success, required this.message, required this.data});

  factory _$TaskListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskListResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String message;
  @override
  final PaginatedTasksData data;

  @override
  String toString() {
    return 'TaskListResponse(success: $success, message: $message, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskListResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, message, data);

  /// Create a copy of TaskListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskListResponseImplCopyWith<_$TaskListResponseImpl> get copyWith =>
      __$$TaskListResponseImplCopyWithImpl<_$TaskListResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskListResponseImplToJson(
      this,
    );
  }
}

abstract class _TaskListResponse implements TaskListResponse {
  const factory _TaskListResponse(
      {required final bool success,
      required final String message,
      required final PaginatedTasksData data}) = _$TaskListResponseImpl;

  factory _TaskListResponse.fromJson(Map<String, dynamic> json) =
      _$TaskListResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String get message;
  @override
  PaginatedTasksData get data;

  /// Create a copy of TaskListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskListResponseImplCopyWith<_$TaskListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
