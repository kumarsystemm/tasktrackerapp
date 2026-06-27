import 'package:flutter/material.dart';
import 'package:task_tracker/features/task/domain/entities/task_entity.dart';

class TaskCard extends StatelessWidget {

  const TaskCard({
    required this.task, required this.onTap, required this.onDelete, required this.onStatusChanged, super.key,
  });
  final TaskEntity task;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final void Function(TaskStatus) onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Hapus Task'),
            content: const Text('Apakah Anda yakin ingin menghapus task ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Hapus'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          decoration: task.isDone ? TextDecoration.lineThrough : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: task.isDone ? Colors.green.shade100 : Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          task.isDone ? 'Done' : 'Pending',
                          style: TextStyle(
                            color: task.isDone ? Colors.green.shade700 : Colors.orange.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  value: task.isDone,
                  onChanged: (value) {
                    onStatusChanged(value! ? TaskStatus.done : TaskStatus.pending);
                  },
                  activeColor: Colors.green,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
