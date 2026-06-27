// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_meta.freezed.dart';
part 'pagination_meta.g.dart';

@Freezed()
class PaginationMeta with _$PaginationMeta {
  const factory PaginationMeta({
    /// Current page number
    required int page,

    /// Items per page
    required int limit,

    /// Total number of items
    required int total,

    /// Total number of pages
    @JsonKey(name: 'total_pages')
    required int totalPages,
  }) = _PaginationMeta;
  
  factory PaginationMeta.fromJson(Map<String, Object?> json) => _$PaginationMetaFromJson(json);
}
