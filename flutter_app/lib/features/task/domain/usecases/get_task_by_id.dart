import 'package:task_tracker/core/errors/result.dart';
import 'package:task_tracker/features/task/domain/entities/task_entity.dart';
import 'package:task_tracker/features/task/domain/repositories/task_repository.dart';

/// UseCase: Mendapatkan detail task berdasarkan ID.
class GetTaskByIdUseCase {

  const GetTaskByIdUseCase(this._repository);
  final TaskRepository _repository;

  Future<Result<TaskEntity>> call(String id) {
    return _repository.getTaskById(id);
  }
}
