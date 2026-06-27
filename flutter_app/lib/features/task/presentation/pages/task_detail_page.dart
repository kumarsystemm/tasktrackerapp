import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_tracker/core/errors/failures.dart';
import 'package:task_tracker/features/task/domain/entities/task_entity.dart';
import 'package:task_tracker/features/task/presentation/providers/task_provider.dart';
import 'package:task_tracker/shared/widgets/loading_widget.dart';

class TaskDetailPage extends ConsumerWidget {

  const TaskDetailPage({required this.taskId, super.key});
  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsync = ref.watch(taskDetailProvider(taskId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Task'),
        actions: [
          taskAsync.when(
            data: (task) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => context.push('/edit-task/$taskId').then((_) {
                    ref.invalidate(taskDetailProvider(taskId));
                  }),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteDialog(context, ref, task),
                ),
              ],
            ),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
      body: taskAsync.when(
        data: (task) => _buildContent(context, ref, task),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorState(
          message: _mapErrorToMessage(error),
          onRetry: () => ref.invalidate(taskDetailProvider(taskId)),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, TaskEntity task) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: task.isDone ? Colors.green.shade100 : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  task.isDone ? 'Done' : 'Pending',
                  style: TextStyle(
                    color: task.isDone ? Colors.green.shade700 : Colors.orange.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Deskripsi',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            task.description,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 24),
          Text(
            'Dibuat',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatDate(task.createdAt),
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            'Terakhir diupdate',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatDate(task.updatedAt),
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                final newStatus = task.isDone ? TaskStatus.pending : TaskStatus.done;
                final result = await ref.read(taskListProvider.notifier).updateTaskStatus(
                  task.id,
                  newStatus,
                );
                result.when(
                  success: (_) {
                    ref.invalidate(taskDetailProvider(taskId));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          task.isDone ? 'Status diubah ke Pending' : 'Status diubah ke Done',
                        ),
                      ),
                    );
                  },
                  failure: (failure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(failure.message)),
                    );
                  },
                );
              },
              icon: Icon(task.isDone ? Icons.undo : Icons.check),
              label: Text(task.isDone ? 'Tandai Pending' : 'Tandai Done'),
              style: ElevatedButton.styleFrom(
                backgroundColor: task.isDone ? Colors.orange : Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, TaskEntity task) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Task'),
        content: Text('Apakah Anda yakin ingin menghapus "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(dialogContext);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final goRouter = GoRouter.of(context);
              final result = await ref.read(taskListProvider.notifier).deleteTask(task.id);
              navigator.pop();
              result.when(
                success: (_) {
                  goRouter.pop();
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text('Task berhasil dihapus')),
                  );
                },
                failure: (failure) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text(failure.message)),
                  );
                },
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  String _mapErrorToMessage(Object error) {
    if (error is Failure) {
      return error.message;
    }
    return 'Terjadi kesalahan yang tidak terduga';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
