import 'package:task_tracker/core/errors/failures.dart';

/// Sealed class Result sebagai pengganti Either<Failure, T>.
/// Tidak perlu dependency tambahan (dartz/fpdart).
sealed class Result<T> {
  const Result();

  /// Buat Success result.
  factory Result.success(T data) = Success<T>;

  /// Buat Failure result.
  factory Result.failure(Failure failure) = Err<T>;

  /// Pattern match result.
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  });

  /// Check apakah result adalah success.
  bool get isSuccess => this is Success<T>;

  /// Check apakah result adalah failure.
  bool get isFailure => this is Err<T>;

  /// Ambil data jika success, null jika failure.
  T? get dataOrNull => switch (this) {
        Success<T>(:final data) => data,
        Err<T>() => null,
      };

  /// Ambil failure jika error, null jika success.
  Failure? get failureOrNull => switch (this) {
        Success<T>() => null,
        Err<T>(:final failure) => failure,
      };
}

/// Success variant dari Result.
class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    return success(data);
  }
}

/// Error variant dari Result.
class Err<T> extends Result<T> {
  const Err(this.failure);
  final Failure failure;

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    return failure(this.failure);
  }
}
