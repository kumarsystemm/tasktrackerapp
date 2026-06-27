import 'package:task_tracker/core/errors/result.dart';
import 'package:task_tracker/features/task/domain/repositories/task_repository.dart';

/// UseCase: Hapus task berdasarkan ID.
class DeleteTaskUseCase {

  const DeleteTaskUseCase(this._repository);
  final TaskRepository _repository;

  Future<Result<void>> call(String id) {
    return _repository.deleteTask(id);
  }
}
