import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_tracker/features/task/data/models/task_model.dart';
import 'package:task_tracker/features/task/domain/repositories/task_repository.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
  });

  final testTasks = [
    Task(
      id: '1',
      title: 'Task 1',
      description: 'Description 1',
      status: 'pending',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
    Task(
      id: '2',
      title: 'Task 2',
      description: 'Description 2',
      status: 'done',
      createdAt: DateTime(2024, 1, 2),
      updatedAt: DateTime(2024, 1, 2),
    ),
  ];

  final testResponse = PaginatedTasksResponse(
    tasks: testTasks,
    pagination: PaginationMeta(
      page: 1,
      limit: 10,
      total: 2,
      totalPages: 1,
    ),
  );

  group('TaskRepository (mock)', () {
    test('getTasks returns paginated response', () async {
      when(() => mockRepository.getTasks(
            search: any(named: 'search'),
            status: any(named: 'status'),
            page: any(named: 'page'),
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => testResponse);

      final result = await mockRepository.getTasks(page: 1, limit: 10);

      expect(result.tasks.length, 2);
      expect(result.pagination.total, 2);
      expect(result.tasks.first.title, 'Task 1');
    });

    test('getTaskById returns task', () async {
      when(() => mockRepository.getTaskById('1'))
          .thenAnswer((_) async => testTasks.first);

      final result = await mockRepository.getTaskById('1');

      expect(result.id, '1');
      expect(result.title, 'Task 1');
    });

    test('createTask returns created task', () async {
      final newTask = Task(
        id: '3',
        title: 'New Task',
        description: 'New Description',
        status: 'pending',
        createdAt: DateTime(2024, 1, 3),
        updatedAt: DateTime(2024, 1, 3),
      );
      when(() => mockRepository.createTask(
            title: 'New Task',
            description: 'New Description',
          )).thenAnswer((_) async => newTask);

      final result = await mockRepository.createTask(
        title: 'New Task',
        description: 'New Description',
      );

      expect(result.id, '3');
      expect(result.title, 'New Task');
    });

    test('deleteTask calls repository', () async {
      when(() => mockRepository.deleteTask('1')).thenAnswer((_) async {});

      await mockRepository.deleteTask('1');

      verify(() => mockRepository.deleteTask('1')).called(1);
    });

    test('updateTaskStatus returns updated task', () async {
      final updatedTask = testTasks.first.copyWith(status: 'done');
      when(() => mockRepository.updateTaskStatus(
            id: '1',
            status: 'done',
          )).thenAnswer((_) async => updatedTask);

      final result = await mockRepository.updateTaskStatus(
        id: '1',
        status: 'done',
      );

      expect(result.status, 'done');
    });
  });
}
