import 'package:flutter_test/flutter_test.dart';
import 'package:task_tracker/features/task/data/models/task_model.dart';

void main() {
  group('Task model', () {
    test('fromJson creates Task correctly', () {
      final json = {
        'id': 'test-id-123',
        'title': 'Test Task',
        'description': 'Test Description',
        'status': 'pending',
        'created_at': '2024-01-15T10:30:00.000Z',
        'updated_at': '2024-01-15T10:30:00.000Z',
      };

      final task = Task.fromJson(json);

      expect(task.id, 'test-id-123');
      expect(task.title, 'Test Task');
      expect(task.description, 'Test Description');
      expect(task.status, 'pending');
      expect(task.createdAt, DateTime.parse('2024-01-15T10:30:00.000Z'));
      expect(task.updatedAt, DateTime.parse('2024-01-15T10:30:00.000Z'));
    });

    test('toJson serializes correctly', () {
      final task = Task(
        id: 'test-id-123',
        title: 'Test Task',
        description: 'Test Description',
        status: 'done',
        createdAt: DateTime.parse('2024-01-15T10:30:00.000Z'),
        updatedAt: DateTime.parse('2024-01-15T10:30:00.000Z'),
      );

      final json = task.toJson();

      expect(json['id'], 'test-id-123');
      expect(json['title'], 'Test Task');
      expect(json['description'], 'Test Description');
      expect(json['status'], 'done');
      expect(json['created_at'], '2024-01-15T10:30:00.000Z');
      expect(json['updated_at'], '2024-01-15T10:30:00.000Z');
    });

    test('roundtrip fromJson -> toJson preserves data', () {
      final original = Task(
        id: 'roundtrip-id',
        title: 'Roundtrip Task',
        description: 'Roundtrip Description',
        status: 'pending',
        createdAt: DateTime(2024, 6, 15, 12, 0, 0),
        updatedAt: DateTime(2024, 6, 15, 12, 0, 0),
      );

      final restored = Task.fromJson(original.toJson());

      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.description, original.description);
      expect(restored.status, original.status);
      expect(restored.createdAt, original.createdAt);
      expect(restored.updatedAt, original.updatedAt);
    });
  });

  group('PaginationMeta', () {
    test('fromJson creates PaginationMeta correctly', () {
      final json = {
        'page': 1,
        'limit': 10,
        'total': 50,
        'total_pages': 5,
      };

      final meta = PaginationMeta.fromJson(json);

      expect(meta.page, 1);
      expect(meta.limit, 10);
      expect(meta.total, 50);
      expect(meta.totalPages, 5);
    });
  });
}
