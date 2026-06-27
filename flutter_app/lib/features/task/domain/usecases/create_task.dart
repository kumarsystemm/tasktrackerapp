import 'package:task_tracker/core/errors/result.dart';
import 'package:task_tracker/features/task/domain/entities/task_entity.dart';
import 'package:task_tracker/features/task/domain/repositories/task_repository.dart';

/// UseCase: Membuat task baru.
class CreateTaskUseCase {

  const CreateTaskUseCase(this._repository);
  final TaskRepository _repository;

  Future<Result<TaskEntity>> call({
    required String title,
    required String description,
  }) {
    return _repository.createTask(title: title, description: description);
  }
}
