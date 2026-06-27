// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DeleteResponse _$DeleteResponseFromJson(Map<String, dynamic> json) {
  return _DeleteResponse.fromJson(json);
}

/// @nodoc
mixin _$DeleteResponse {
  bool get success => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  /// Serializes this DeleteResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeleteResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeleteResponseCopyWith<DeleteResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeleteResponseCopyWith<$Res> {
  factory $DeleteResponseCopyWith(
          DeleteResponse value, $Res Function(DeleteResponse) then) =
      _$DeleteResponseCopyWithImpl<$Res, DeleteResponse>;
  @useResult
  $Res call({bool success, String message});
}

/// @nodoc
class _$DeleteResponseCopyWithImpl<$Res, $Val extends DeleteResponse>
    implements $DeleteResponseCopyWith<$Res> {
  _$DeleteResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeleteResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeleteResponseImplCopyWith<$Res>
    implements $DeleteResponseCopyWith<$Res> {
  factory _$$DeleteResponseImplCopyWith(_$DeleteResponseImpl value,
          $Res Function(_$DeleteResponseImpl) then) =
      __$$DeleteResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, String message});
}

/// @nodoc
class __$$DeleteResponseImplCopyWithImpl<$Res>
    extends _$DeleteResponseCopyWithImpl<$Res, _$DeleteResponseImpl>
    implements _$$DeleteResponseImplCopyWith<$Res> {
  __$$DeleteResponseImplCopyWithImpl(
      _$DeleteResponseImpl _value, $Res Function(_$DeleteResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeleteResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
  }) {
    return _then(_$DeleteResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeleteResponseImpl implements _DeleteResponse {
  const _$DeleteResponseImpl({required this.success, required this.message});

  factory _$DeleteResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeleteResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String message;

  @override
  String toString() {
    return 'DeleteResponse(success: $success, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, message);

  /// Create a copy of DeleteResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteResponseImplCopyWith<_$DeleteResponseImpl> get copyWith =>
      __$$DeleteResponseImplCopyWithImpl<_$DeleteResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeleteResponseImplToJson(
      this,
    );
  }
}

abstract class _DeleteResponse implements DeleteResponse {
  const factory _DeleteResponse(
      {required final bool success,
      required final String message}) = _$DeleteResponseImpl;

  factory _DeleteResponse.fromJson(Map<String, dynamic> json) =
      _$DeleteResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String get message;

  /// Create a copy of DeleteResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteResponseImplCopyWith<_$DeleteResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
