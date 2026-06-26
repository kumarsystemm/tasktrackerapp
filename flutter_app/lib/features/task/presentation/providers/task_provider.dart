import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_tracker/features/task/data/models/task_model.dart';
import 'package:task_tracker/features/task/data/repositories/task_repository_impl.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final statusFilterProvider = StateProvider<String?>((ref) => null);

final taskListProvider = StateNotifierProvider.autoDispose<TaskListNotifier, AsyncValue<List<Task>>>((ref) {
  return TaskListNotifier(ref);
});

class TaskListNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final Ref _ref;
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  List<Task> _allTasks = [];
  PaginationMeta? _pagination;

  TaskListNotifier(this._ref) : super(const AsyncValue.loading()) {
    loadTasks();
  }

  PaginationMeta? get pagination => _pagination;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> loadTasks({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _allTasks = [];
    }

    state = const AsyncValue.loading();

    try {
      final repository = _ref.read(taskRepositoryProvider);
      final search = _ref.read(searchQueryProvider);
      final status = _ref.read(statusFilterProvider);

      final response = await repository.getTasks(
        search: search.isEmpty ? null : search,
        status: status,
        page: _currentPage,
        limit: 10,
      );

      _allTasks = response.tasks;
      _pagination = response.pagination;
      _hasMore = _currentPage < response.pagination.totalPages;

      state = AsyncValue.data(_allTasks);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore) return;

    _isLoadingMore = true;

    try {
      _currentPage++;
      final repository = _ref.read(taskRepositoryProvider);
      final search = _ref.read(searchQueryProvider);
      final status = _ref.read(statusFilterProvider);

      final response = await repository.getTasks(
        search: search.isEmpty ? null : search,
        status: status,
        page: _currentPage,
        limit: 10,
      );

      _allTasks = [..._allTasks, ...response.tasks];
      _pagination = response.pagination;
      _hasMore = _currentPage < response.pagination.totalPages;

      state = AsyncValue.data(_allTasks);
    } catch (e) {
      _currentPage--;
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final repository = _ref.read(taskRepositoryProvider);
      await repository.deleteTask(id);
      _allTasks = _allTasks.where((task) => task.id != id).toList();
      state = AsyncValue.data(_allTasks);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateTaskStatus(String id, String status) async {
    try {
      final repository = _ref.read(taskRepositoryProvider);
      final updatedTask = await repository.updateTaskStatus(id: id, status: status);
      _allTasks = _allTasks.map((task) => task.id == id ? updatedTask : task).toList();
      state = AsyncValue.data(_allTasks);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
