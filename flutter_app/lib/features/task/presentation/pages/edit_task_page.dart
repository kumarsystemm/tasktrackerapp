import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_tracker/features/task/data/models/task_model.dart';
import 'package:task_tracker/features/task/data/repositories/task_repository_impl.dart';
import 'package:task_tracker/features/task/presentation/pages/add_task_page.dart';
import 'package:task_tracker/features/task/presentation/pages/task_detail_page.dart';
import 'package:task_tracker/shared/widgets/loading_widget.dart';

class EditTaskPage extends ConsumerWidget {
  final String taskId;

  const EditTaskPage({super.key, required this.taskId});

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
        appBar: AppBar(title: Text('Edit Task')),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: Text('Edit Task')),
        body: ErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(taskDetailProvider(taskId)),
        ),
      ),
    );
  }
}
