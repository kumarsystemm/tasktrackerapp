import 'package:task_tracker/core/errors/result.dart';
import 'package:task_tracker/features/task/domain/entities/task_entity.dart';
import 'package:task_tracker/features/task/domain/repositories/task_repository.dart';

/// UseCase: Mendapatkan daftar task dengan pagination, search, dan filter.
class GetTasksUseCase {

  const GetTasksUseCase(this._repository);
  final TaskRepository _repository;

  Future<Result<PaginatedTasks>> call({
    String? search,
    String? status,
    int page = 1,
    int limit = 10,
  }) {
    return _repository.getTasks(
      search: search,
      status: status,
      page: page,
      limit: limit,
    );
  }
}
