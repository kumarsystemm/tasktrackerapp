import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_tracker/features/task/data/models/task_model.dart';
import 'package:task_tracker/features/task/data/repositories/task_repository_impl.dart';
import 'package:task_tracker/shared/widgets/loading_widget.dart';

final taskDetailProvider = FutureProvider.autoDispose.family<Task, String>((ref, id) async {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.getTaskById(id);
});

class TaskDetailPage extends ConsumerWidget {
  final String taskId;

  const TaskDetailPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsync = ref.watch(taskDetailProvider(taskId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Task'),
        actions: [
          taskAsync.when(
            data: (task) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => context.push('/edit-task/$taskId').then((_) {
                    ref.invalidate(taskDetailProvider(taskId));
                  }),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteDialog(context, ref, task),
                ),
              ],
            ),
            loading: () => SizedBox(),
            error: (_, __) => SizedBox(),
          ),
        ],
      ),
      body: taskAsync.when(
        data: (task) => _buildContent(context, ref, task),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(taskDetailProvider(taskId)),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, Task task) {
    final isDone = task.status == 'done';

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDone ? Colors.green.shade100 : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  isDone ? 'Done' : 'Pending',
                  style: TextStyle(
                    color: isDone ? Colors.green.shade700 : Colors.orange.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            'Deskripsi',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            task.description,
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          SizedBox(height: 24),
          Text(
            'Dibuat',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _formatDate(task.createdAt),
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 8),
          Text(
            'Terakhir diupdate',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _formatDate(task.updatedAt),
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                final newStatus = isDone ? 'pending' : 'done';
                ref.read(taskRepositoryProvider).updateTaskStatus(
                  id: task.id,
                  status: newStatus,
                ).then((_) {
                  ref.invalidate(taskDetailProvider(taskId));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isDone ? 'Status diubah ke Pending' : 'Status diubah ke Done',
                      ),
                    ),
                  );
                });
              },
              icon: Icon(isDone ? Icons.undo : Icons.check),
              label: Text(isDone ? 'Tandai Pending' : 'Tandai Done'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDone ? Colors.orange : Colors.green,
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Task'),
        content: Text('Apakah Anda yakin ingin menghapus "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              ref.read(taskRepositoryProvider).deleteTask(task.id).then((_) {
                Navigator.pop(context);
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Task berhasil dihapus')),
                );
              });
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Hapus'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
