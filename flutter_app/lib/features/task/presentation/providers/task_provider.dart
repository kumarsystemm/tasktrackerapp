import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_tracker/core/errors/result.dart';
import 'package:task_tracker/features/task/data/repositories/task_repository_impl.dart';
import 'package:task_tracker/features/task/domain/entities/task_entity.dart';
import 'package:task_tracker/features/task/domain/usecases/create_task.dart';
import 'package:task_tracker/features/task/domain/usecases/delete_task.dart';
import 'package:task_tracker/features/task/domain/usecases/get_task_by_id.dart';
import 'package:task_tracker/features/task/domain/usecases/get_tasks.dart';
import 'package:task_tracker/features/task/domain/usecases/update_task.dart';
import 'package:task_tracker/features/task/domain/usecases/update_task_status.dart';

// --- UseCase Providers ---

final getTasksUseCaseProvider = Provider<GetTasksUseCase>((ref) {
  return GetTasksUseCase(ref.watch(taskRepositoryProvider));
});

final getTaskByIdUseCaseProvider = Provider<GetTaskByIdUseCase>((ref) {
  return GetTaskByIdUseCase(ref.watch(taskRepositoryProvider));
});

final createTaskUseCaseProvider = Provider<CreateTaskUseCase>((ref) {
  return CreateTaskUseCase(ref.watch(taskRepositoryProvider));
});

final updateTaskUseCaseProvider = Provider<UpdateTaskUseCase>((ref) {
  return UpdateTaskUseCase(ref.watch(taskRepositoryProvider));
});

final deleteTaskUseCaseProvider = Provider<DeleteTaskUseCase>((ref) {
  return DeleteTaskUseCase(ref.watch(taskRepositoryProvider));
});

final updateTaskStatusUseCaseProvider = Provider<UpdateTaskStatusUseCase>((ref) {
  return UpdateTaskStatusUseCase(ref.watch(taskRepositoryProvider));
});

// --- State Providers ---

final searchQueryProvider = StateProvider<String>((ref) => '');

final statusFilterProvider = StateProvider<String?>((ref) => null);

// --- Task Detail Provider ---

final taskDetailProvider = FutureProvider.autoDispose.family<TaskEntity, String>((ref, id) async {
  final useCase = ref.watch(getTaskByIdUseCaseProvider);
  final result = await useCase(id);
  return result.when(
    success: (task) => task,
    failure: (failure) => throw failure,
  );
});

// --- Task List Provider ---

final taskListProvider = StateNotifierProvider.autoDispose<TaskListNotifier, AsyncValue<List<TaskEntity>>>((ref) {
  return TaskListNotifier(ref);
});

class TaskListNotifier extends StateNotifier<AsyncValue<List<TaskEntity>>> {

  TaskListNotifier(this._ref) : super(const AsyncValue.loading()) {
    loadTasks();
  }
  final Ref _ref;
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  List<TaskEntity> _allTasks = [];
  PaginationInfo? _pagination;

  PaginationInfo? get pagination => _pagination;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> loadTasks({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _allTasks = [];
    }

    state = const AsyncValue.loading();

    final getTasksUseCase = _ref.read(getTasksUseCaseProvider);
    final search = _ref.read(searchQueryProvider);
    final status = _ref.read(statusFilterProvider);

    final result = await getTasksUseCase(
      search: search.isEmpty ? null : search,
      status: status,
      page: _currentPage,
    );

    result.when(
      success: (paginatedTasks) {
        _allTasks = paginatedTasks.tasks;
        _pagination = paginatedTasks.pagination;
        _hasMore = paginatedTasks.pagination.hasNextPage;
        state = AsyncValue.data(_allTasks);
      },
      failure: (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
    );
  }

  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore) return;

    _isLoadingMore = true;

    _currentPage++;
    final getTasksUseCase = _ref.read(getTasksUseCaseProvider);
    final search = _ref.read(searchQueryProvider);
    final status = _ref.read(statusFilterProvider);

    final result = await getTasksUseCase(
      search: search.isEmpty ? null : search,
      status: status,
      page: _currentPage,
    );

    result.when(
      success: (paginatedTasks) {
        _allTasks = [..._allTasks, ...paginatedTasks.tasks];
        _pagination = paginatedTasks.pagination;
        _hasMore = paginatedTasks.pagination.hasNextPage;
        state = AsyncValue.data(_allTasks);
      },
      failure: (_) {
        _currentPage--;
      },
    );

    _isLoadingMore = false;
  }

  Future<Result<TaskEntity>> createTask({
    required String title,
    required String description,
  }) async {
    final useCase = _ref.read(createTaskUseCaseProvider);
    final result = await useCase(title: title, description: description);
    if (result.isSuccess) {
      await loadTasks(refresh: true);
    }
    return result;
  }

  Future<Result<TaskEntity>> updateTask({
    required String id,
    required String title,
    required String description,
  }) async {
    final useCase = _ref.read(updateTaskUseCaseProvider);
    final result = await useCase(id: id, title: title, description: description);
    if (result.isSuccess) {
      await loadTasks(refresh: true);
    }
    return result;
  }

  Future<Result<void>> deleteTask(String id) async {
    final useCase = _ref.read(deleteTaskUseCaseProvider);
    final result = await useCase(id);
    result.when(
      success: (_) {
        _allTasks = _allTasks.where((task) => task.id != id).toList();
        state = AsyncValue.data(_allTasks);
      },
      failure: (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
    );
    return result;
  }

  Future<Result<TaskEntity>> updateTaskStatus(String id, TaskStatus status) async {
    final useCase = _ref.read(updateTaskStatusUseCaseProvider);
    final result = await useCase(id: id, status: status);
    result.when(
      success: (updatedTask) {
        _allTasks = _allTasks.map((task) => task.id == id ? updatedTask : task).toList();
        state = AsyncValue.data(_allTasks);
      },
      failure: (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
    );
    return result;
  }
}
