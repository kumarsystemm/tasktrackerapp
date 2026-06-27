import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_tracker/core/errors/result.dart';
import 'package:task_tracker/features/task/domain/entities/task_entity.dart';
import 'package:task_tracker/features/task/domain/repositories/task_repository.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(TaskStatus.pending);
  });

  setUp(() {
    mockRepository = MockTaskRepository();
  });

  final testTasks = [
    TaskEntity(
      id: '1',
      title: 'Task 1',
      description: 'Description 1',
      status: TaskStatus.pending,
      createdAt: DateTime(2024),
      updatedAt: DateTime(2024),
    ),
    TaskEntity(
      id: '2',
      title: 'Task 2',
      description: 'Description 2',
      status: TaskStatus.done,
      createdAt: DateTime(2024, 1, 2),
      updatedAt: DateTime(2024, 1, 2),
    ),
  ];

  final testResponse = PaginatedTasks(
    tasks: testTasks,
    pagination: const PaginationInfo(
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
          ),).thenAnswer((_) async => Result.success(testResponse));

      final result = await mockRepository.getTasks();

      final data = result.dataOrNull!;
      expect(data.tasks.length, 2);
      expect(data.pagination.total, 2);
      expect(data.tasks.first.title, 'Task 1');
    });

    test('getTaskById returns task', () async {
      when(() => mockRepository.getTaskById('1'))
          .thenAnswer((_) async => Result.success(testTasks.first));

      final result = await mockRepository.getTaskById('1');

      final data = result.dataOrNull!;
      expect(data.id, '1');
      expect(data.title, 'Task 1');
    });

    test('createTask returns created task', () async {
      final newTask = TaskEntity(
        id: '3',
        title: 'New Task',
        description: 'New Description',
        status: TaskStatus.pending,
        createdAt: DateTime(2024, 1, 3),
        updatedAt: DateTime(2024, 1, 3),
      );
      when(() => mockRepository.createTask(
            title: 'New Task',
            description: 'New Description',
          ),).thenAnswer((_) async => Result.success(newTask));

      final result = await mockRepository.createTask(
        title: 'New Task',
        description: 'New Description',
      );

      final data = result.dataOrNull!;
      expect(data.id, '3');
      expect(data.title, 'New Task');
    });

    test('deleteTask calls repository', () async {
      when(() => mockRepository.deleteTask('1'))
          .thenAnswer((_) async => Result.success(null));

      await mockRepository.deleteTask('1');

      verify(() => mockRepository.deleteTask('1')).called(1);
    });

    test('updateTaskStatus returns updated task', () async {
      final updatedTask = testTasks.first.copyWith(status: TaskStatus.done);
      when(() => mockRepository.updateTaskStatus(
            id: '1',
            status: TaskStatus.done,
          ),).thenAnswer((_) async => Result.success(updatedTask));

      final result = await mockRepository.updateTaskStatus(
        id: '1',
        status: TaskStatus.done,
      );

      final data = result.dataOrNull!;
      expect(data.status, TaskStatus.done);
    });
  });
}
