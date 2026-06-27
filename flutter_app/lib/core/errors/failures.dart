import 'package:dio/dio.dart';

/// Base class untuk semua failure dalam aplikasi.
/// Menggunakan sealed class agar exhaustive pattern matching di UI.
sealed class Failure implements Exception {

  const Failure({required this.message, this.code});
  final String message;
  final String? code;

  @override
  String toString() => message;
}

/// Gagal koneksi ke server (timeout, no internet, dll).
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Tidak dapat terhubung ke server',
    super.code = 'NETWORK_ERROR',
  });
}

/// Server mengembalikan error (4xx, 5xx).
class ServerFailure extends Failure {

  const ServerFailure({
    required super.message,
    super.code,
    this.statusCode,
  });
  final int? statusCode;
}

/// Resource tidak ditemukan (404).
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Data tidak ditemukan',
    super.code = 'NOT_FOUND',
  });
}

/// Validasi gagal (422).
class ValidationFailure extends Failure {

  const ValidationFailure({
    super.message = 'Data tidak valid',
    super.code = 'VALIDATION_ERROR',
    this.errors,
  });
  final Map<String, dynamic>? errors;
}

/// Unauthorized (401) atau Forbidden (403).
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Akses ditolak',
    super.code = 'UNAUTHORIZED',
  });
}

/// Error dari cache/database lokal.
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Gagal mengakses data lokal',
    super.code = 'CACHE_ERROR',
  });
}

/// Unknown error.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'Terjadi kesalahan yang tidak terduga',
    super.code = 'UNEXPECTED_ERROR',
  });
}

/// Mapper dari DioException ke Failure.
Failure mapDioExceptionToFailure(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return const NetworkFailure();

    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      var message = 'Terjadi kesalahan pada server';
      String? code;

      if (data is Map<String, dynamic>) {
        message = data['message'] as String? ?? message;
        code = data['code'] as String?;
      }

      return switch (statusCode) {
        401 || 403 => UnauthorizedFailure(message: message, code: code),
        404 => NotFoundFailure(message: message, code: code),
        422 => ValidationFailure(
            message: message,
            code: code,
            errors: data is Map<String, dynamic>
                ? data['errors'] as Map<String, dynamic>?
                : null,
          ),
        _ => ServerFailure(
            message: message,
            code: code,
            statusCode: statusCode,
          ),
      };

    case DioExceptionType.cancel:
      return const NetworkFailure(message: 'Request dibatalkan');

    case DioExceptionType.badCertificate:
      return const NetworkFailure(message: 'Sertifikat SSL tidak valid');

    case DioExceptionType.unknown:
      if (e.error != null && e.error.toString().contains('SocketException')) {
        return const NetworkFailure();
      }
      return UnexpectedFailure(message: e.message ?? 'Terjadi kesalahan');
  }
}

/// Mapper dari generic Exception ke Failure.
Failure mapExceptionToFailure(Object e) {
  if (e is DioException) {
    return mapDioExceptionToFailure(e);
  }
  if (e is Failure) {
    return e;
  }
  return UnexpectedFailure(message: e.toString());
}
