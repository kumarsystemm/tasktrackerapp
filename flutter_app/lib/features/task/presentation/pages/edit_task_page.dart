import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_tracker/features/task/presentation/pages/add_task_page.dart';
import 'package:task_tracker/features/task/presentation/providers/task_provider.dart';
import 'package:task_tracker/shared/widgets/loading_widget.dart';

class EditTaskPage extends ConsumerWidget {

  const EditTaskPage({required this.taskId, super.key});
  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsync = ref.watch(taskDetailProvider(taskId));

    return taskAsync.when(
      data: (task) => AddTaskPage(
        taskId: task.id,
        initialTitle: task.title,
        initialDescription: task.description,
      ),
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Edit Task')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Edit Task')),
        body: ErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(taskDetailProvider(taskId)),
        ),
      ),
    );
  }
}
