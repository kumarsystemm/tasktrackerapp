import 'package:task_tracker/core/errors/result.dart';
import 'package:task_tracker/features/task/domain/entities/task_entity.dart';
import 'package:task_tracker/features/task/domain/repositories/task_repository.dart';

/// UseCase: Update task (title dan description).
class UpdateTaskUseCase {

  const UpdateTaskUseCase(this._repository);
  final TaskRepository _repository;

  Future<Result<TaskEntity>> call({
    required String id,
    required String title,
    required String description,
  }) {
    return _repository.updateTask(id: id, title: title, description: description);
  }
}
