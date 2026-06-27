// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_status_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpdateStatusRequest _$UpdateStatusRequestFromJson(Map<String, dynamic> json) {
  return _UpdateStatusRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateStatusRequest {
  /// New task status
  UpdateStatusRequestStatus get status => throw _privateConstructorUsedError;

  /// Serializes this UpdateStatusRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateStatusRequestCopyWith<UpdateStatusRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateStatusRequestCopyWith<$Res> {
  factory $UpdateStatusRequestCopyWith(
          UpdateStatusRequest value, $Res Function(UpdateStatusRequest) then) =
      _$UpdateStatusRequestCopyWithImpl<$Res, UpdateStatusRequest>;
  @useResult
  $Res call({UpdateStatusRequestStatus status});
}

/// @nodoc
class _$UpdateStatusRequestCopyWithImpl<$Res, $Val extends UpdateStatusRequest>
    implements $UpdateStatusRequestCopyWith<$Res> {
  _$UpdateStatusRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UpdateStatusRequestStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateStatusRequestImplCopyWith<$Res>
    implements $UpdateStatusRequestCopyWith<$Res> {
  factory _$$UpdateStatusRequestImplCopyWith(_$UpdateStatusRequestImpl value,
          $Res Function(_$UpdateStatusRequestImpl) then) =
      __$$UpdateStatusRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UpdateStatusRequestStatus status});
}

/// @nodoc
class __$$UpdateStatusRequestImplCopyWithImpl<$Res>
    extends _$UpdateStatusRequestCopyWithImpl<$Res, _$UpdateStatusRequestImpl>
    implements _$$UpdateStatusRequestImplCopyWith<$Res> {
  __$$UpdateStatusRequestImplCopyWithImpl(_$UpdateStatusRequestImpl _value,
      $Res Function(_$UpdateStatusRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
  }) {
    return _then(_$UpdateStatusRequestImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UpdateStatusRequestStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateStatusRequestImpl implements _UpdateStatusRequest {
  const _$UpdateStatusRequestImpl({required this.status});

  factory _$UpdateStatusRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateStatusRequestImplFromJson(json);

  /// New task status
  @override
  final UpdateStatusRequestStatus status;

  @override
  String toString() {
    return 'UpdateStatusRequest(status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateStatusRequestImpl &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status);

  /// Create a copy of UpdateStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateStatusRequestImplCopyWith<_$UpdateStatusRequestImpl> get copyWith =>
      __$$UpdateStatusRequestImplCopyWithImpl<_$UpdateStatusRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateStatusRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateStatusRequest implements UpdateStatusRequest {
  const factory _UpdateStatusRequest(
          {required final UpdateStatusRequestStatus status}) =
      _$UpdateStatusRequestImpl;

  factory _UpdateStatusRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateStatusRequestImpl.fromJson;

  /// New task status
  @override
  UpdateStatusRequestStatus get status;

  /// Create a copy of UpdateStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateStatusRequestImplCopyWith<_$UpdateStatusRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
