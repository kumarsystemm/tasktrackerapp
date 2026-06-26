import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_tracker/features/task/data/repositories/task_repository_impl.dart';
import 'package:task_tracker/features/task/presentation/providers/task_provider.dart';

class AddTaskPage extends ConsumerStatefulWidget {
  final String? taskId;
  final String? initialTitle;
  final String? initialDescription;

  const AddTaskPage({
    super.key,
    this.taskId,
    this.initialTitle,
    this.initialDescription,
  });

  @override
  ConsumerState<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends ConsumerState<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  bool _isLoading = false;

  bool get isEditing => widget.taskId != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _descController = TextEditingController(text: widget.initialDescription ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(taskRepositoryProvider);

      if (isEditing) {
        await repository.updateTask(
          id: widget.taskId!,
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
        );
      } else {
        await repository.createTask(
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
        );
      }

      ref.read(taskListProvider.notifier).loadTasks(refresh: true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? 'Task berhasil diupdate' : 'Task berhasil ditambahkan'),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Tambah Task'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Judul Task',
                  hintText: 'Masukkan judul task',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  if (value.trim().length > 255) {
                    return 'Judul maksimal 255 karakter';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.sentences,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  hintText: 'Masukkan deskripsi task',
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.sentences,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(isEditing ? 'Simpan Perubahan' : 'Tambah Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
