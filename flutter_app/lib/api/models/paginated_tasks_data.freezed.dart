// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_tasks_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaginatedTasksData _$PaginatedTasksDataFromJson(Map<String, dynamic> json) {
  return _PaginatedTasksData.fromJson(json);
}

/// @nodoc
mixin _$PaginatedTasksData {
  List<Task> get tasks => throw _privateConstructorUsedError;
  PaginationMeta get pagination => throw _privateConstructorUsedError;

  /// Serializes this PaginatedTasksData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginatedTasksData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginatedTasksDataCopyWith<PaginatedTasksData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedTasksDataCopyWith<$Res> {
  factory $PaginatedTasksDataCopyWith(
          PaginatedTasksData value, $Res Function(PaginatedTasksData) then) =
      _$PaginatedTasksDataCopyWithImpl<$Res, PaginatedTasksData>;
  @useResult
  $Res call({List<Task> tasks, PaginationMeta pagination});

  $PaginationMetaCopyWith<$Res> get pagination;
}

/// @nodoc
class _$PaginatedTasksDataCopyWithImpl<$Res, $Val extends PaginatedTasksData>
    implements $PaginatedTasksDataCopyWith<$Res> {
  _$PaginatedTasksDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginatedTasksData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tasks = null,
    Object? pagination = null,
  }) {
    return _then(_value.copyWith(
      tasks: null == tasks
          ? _value.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<Task>,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationMeta,
    ) as $Val);
  }

  /// Create a copy of PaginatedTasksData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaginationMetaCopyWith<$Res> get pagination {
    return $PaginationMetaCopyWith<$Res>(_value.pagination, (value) {
      return _then(_value.copyWith(pagination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PaginatedTasksDataImplCopyWith<$Res>
    implements $PaginatedTasksDataCopyWith<$Res> {
  factory _$$PaginatedTasksDataImplCopyWith(_$PaginatedTasksDataImpl value,
          $Res Function(_$PaginatedTasksDataImpl) then) =
      __$$PaginatedTasksDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Task> tasks, PaginationMeta pagination});

  @override
  $PaginationMetaCopyWith<$Res> get pagination;
}

/// @nodoc
class __$$PaginatedTasksDataImplCopyWithImpl<$Res>
    extends _$PaginatedTasksDataCopyWithImpl<$Res, _$PaginatedTasksDataImpl>
    implements _$$PaginatedTasksDataImplCopyWith<$Res> {
  __$$PaginatedTasksDataImplCopyWithImpl(_$PaginatedTasksDataImpl _value,
      $Res Function(_$PaginatedTasksDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaginatedTasksData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tasks = null,
    Object? pagination = null,
  }) {
    return _then(_$PaginatedTasksDataImpl(
      tasks: null == tasks
          ? _value._tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<Task>,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationMeta,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginatedTasksDataImpl implements _PaginatedTasksData {
  const _$PaginatedTasksDataImpl(
      {required final List<Task> tasks, required this.pagination})
      : _tasks = tasks;

  factory _$PaginatedTasksDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginatedTasksDataImplFromJson(json);

  final List<Task> _tasks;
  @override
  List<Task> get tasks {
    if (_tasks is EqualUnmodifiableListView) return _tasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tasks);
  }

  @override
  final PaginationMeta pagination;

  @override
  String toString() {
    return 'PaginatedTasksData(tasks: $tasks, pagination: $pagination)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginatedTasksDataImpl &&
            const DeepCollectionEquality().equals(other._tasks, _tasks) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_tasks), pagination);

  /// Create a copy of PaginatedTasksData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginatedTasksDataImplCopyWith<_$PaginatedTasksDataImpl> get copyWith =>
      __$$PaginatedTasksDataImplCopyWithImpl<_$PaginatedTasksDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginatedTasksDataImplToJson(
      this,
    );
  }
}

abstract class _PaginatedTasksData implements PaginatedTasksData {
  const factory _PaginatedTasksData(
      {required final List<Task> tasks,
      required final PaginationMeta pagination}) = _$PaginatedTasksDataImpl;

  factory _PaginatedTasksData.fromJson(Map<String, dynamic> json) =
      _$PaginatedTasksDataImpl.fromJson;

  @override
  List<Task> get tasks;
  @override
  PaginationMeta get pagination;

  /// Create a copy of PaginatedTasksData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginatedTasksDataImplCopyWith<_$PaginatedTasksDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
