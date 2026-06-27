// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_task_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpdateTaskRequest _$UpdateTaskRequestFromJson(Map<String, dynamic> json) {
  return _UpdateTaskRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateTaskRequest {
  /// Task title
  String get title => throw _privateConstructorUsedError;

  /// Task description
  String get description => throw _privateConstructorUsedError;

  /// Serializes this UpdateTaskRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateTaskRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateTaskRequestCopyWith<UpdateTaskRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateTaskRequestCopyWith<$Res> {
  factory $UpdateTaskRequestCopyWith(
          UpdateTaskRequest value, $Res Function(UpdateTaskRequest) then) =
      _$UpdateTaskRequestCopyWithImpl<$Res, UpdateTaskRequest>;
  @useResult
  $Res call({String title, String description});
}

/// @nodoc
class _$UpdateTaskRequestCopyWithImpl<$Res, $Val extends UpdateTaskRequest>
    implements $UpdateTaskRequestCopyWith<$Res> {
  _$UpdateTaskRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateTaskRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateTaskRequestImplCopyWith<$Res>
    implements $UpdateTaskRequestCopyWith<$Res> {
  factory _$$UpdateTaskRequestImplCopyWith(_$UpdateTaskRequestImpl value,
          $Res Function(_$UpdateTaskRequestImpl) then) =
      __$$UpdateTaskRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String description});
}

/// @nodoc
class __$$UpdateTaskRequestImplCopyWithImpl<$Res>
    extends _$UpdateTaskRequestCopyWithImpl<$Res, _$UpdateTaskRequestImpl>
    implements _$$UpdateTaskRequestImplCopyWith<$Res> {
  __$$UpdateTaskRequestImplCopyWithImpl(_$UpdateTaskRequestImpl _value,
      $Res Function(_$UpdateTaskRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateTaskRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
  }) {
    return _then(_$UpdateTaskRequestImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateTaskRequestImpl implements _UpdateTaskRequest {
  const _$UpdateTaskRequestImpl(
      {required this.title, required this.description});

  factory _$UpdateTaskRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateTaskRequestImplFromJson(json);

  /// Task title
  @override
  final String title;

  /// Task description
  @override
  final String description;

  @override
  String toString() {
    return 'UpdateTaskRequest(title: $title, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateTaskRequestImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, description);

  /// Create a copy of UpdateTaskRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateTaskRequestImplCopyWith<_$UpdateTaskRequestImpl> get copyWith =>
      __$$UpdateTaskRequestImplCopyWithImpl<_$UpdateTaskRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateTaskRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateTaskRequest implements UpdateTaskRequest {
  const factory _UpdateTaskRequest(
      {required final String title,
      required final String description}) = _$UpdateTaskRequestImpl;

  factory _UpdateTaskRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateTaskRequestImpl.fromJson;

  /// Task title
  @override
  String get title;

  /// Task description
  @override
  String get description;

  /// Create a copy of UpdateTaskRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateTaskRequestImplCopyWith<_$UpdateTaskRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
