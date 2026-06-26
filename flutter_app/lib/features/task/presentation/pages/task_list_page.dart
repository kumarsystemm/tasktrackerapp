import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_tracker/core/theme/theme_provider.dart';
import 'package:task_tracker/features/task/presentation/providers/task_provider.dart';
import 'package:task_tracker/features/task/presentation/widgets/search_filter_bar.dart';
import 'package:task_tracker/shared/widgets/loading_widget.dart';
import 'package:task_tracker/shared/widgets/task_card.dart';

class TaskListPage extends ConsumerStatefulWidget {
  const TaskListPage({super.key});

  @override
  ConsumerState<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends ConsumerState<TaskListPage> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(taskListProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 300), () {
      ref.read(searchQueryProvider.notifier).state = query;
      ref.read(taskListProvider.notifier).loadTasks(refresh: true);
    });
  }

  void _onStatusFilterChanged(String? status) {
    ref.read(statusFilterProvider.notifier).state = status;
    ref.read(taskListProvider.notifier).loadTasks(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final taskListState = ref.watch(taskListProvider);
    final pagination = ref.watch(taskListProvider.notifier).pagination;
    final isLoadingMore = ref.watch(taskListProvider.notifier).isLoadingMore;
    final currentSearch = ref.watch(searchQueryProvider);
    final currentStatus = ref.watch(statusFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Tracker'),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SearchFilterBar(
            onSearchChanged: _onSearchChanged,
            onStatusFilterChanged: _onStatusFilterChanged,
            currentStatus: currentStatus,
          ),
          if (pagination != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Menampilkan ${taskListState.value?.length ?? 0} dari ${pagination.total} task',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: taskListState.when(
              data: (tasks) {
                if (tasks.isEmpty) {
                  return EmptyState(
                    title: currentSearch.isNotEmpty
                        ? 'Tidak ada task ditemukan'
                        : 'Belum ada task',
                    subtitle: currentSearch.isNotEmpty
                        ? 'Coba kata kunci lain'
                        : 'Silakan tambahkan task pertama Anda',
                    icon: currentSearch.isNotEmpty
                        ? Icons.search_off
                        : Icons.inbox_outlined,
                    onAction: currentSearch.isEmpty
                        ? () => context.push('/add-task')
                        : null,
                    actionLabel: 'Tambah Task',
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => ref.read(taskListProvider.notifier).loadTasks(refresh: true),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(16),
                    itemCount: tasks.length + (isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == tasks.length) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final task = tasks[index];
                      return TaskCard(
                        task: task,
                        onTap: () => context.push('/task/${task.id}'),
                        onDelete: () {
                          ref.read(taskListProvider.notifier).deleteTask(task.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Task berhasil dihapus')),
                          );
                        },
                        onStatusChanged: (status) {
                          ref.read(taskListProvider.notifier).updateTaskStatus(task.id, status);
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => SkeletonLoader(),
              error: (error, stack) => ErrorState(
                message: error.toString(),
                onRetry: () => ref.read(taskListProvider.notifier).loadTasks(refresh: true),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-task'),
        child: Icon(Icons.add),
      ),
    );
  }
}
