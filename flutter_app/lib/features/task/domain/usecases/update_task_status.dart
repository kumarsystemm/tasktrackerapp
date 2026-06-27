import 'package:task_tracker/core/errors/result.dart';
import 'package:task_tracker/features/task/domain/entities/task_entity.dart';
import 'package:task_tracker/features/task/domain/repositories/task_repository.dart';

/// UseCase: Update status task (pending <-> done).
class UpdateTaskStatusUseCase {

  const UpdateTaskStatusUseCase(this._repository);
  final TaskRepository _repository;

  Future<Result<TaskEntity>> call({
    required String id,
    required TaskStatus status,
  }) {
    return _repository.updateTaskStatus(id: id, status: status);
  }
}
