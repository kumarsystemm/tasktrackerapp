import 'package:task_tracker/features/task/data/models/task_model.dart';

abstract class TaskRepository {
  Future<PaginatedTasksResponse> getTasks({
    String? search,
    String? status,
    int page = 1,
    int limit = 10,
  });

  Future<Task> getTaskById(String id);

  Future<Task> createTask({
    required String title,
    required String description,
  });

  Future<Task> updateTask({
    required String id,
    required String title,
    required String description,
  });

  Future<void> deleteTask(String id);

  Future<Task> updateTaskStatus({
    required String id,
    required String status,
  });
}
