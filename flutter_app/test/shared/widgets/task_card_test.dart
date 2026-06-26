import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_tracker/features/task/data/models/task_model.dart';
import 'package:task_tracker/shared/widgets/task_card.dart';

void main() {
  group('TaskCard', () {
    final testTask = Task(
      id: 'test-id',
      title: 'Test Task Title',
      description: 'Test task description that is a bit longer',
      status: 'pending',
      createdAt: DateTime(2024, 1, 15),
      updatedAt: DateTime(2024, 1, 15),
    );

    final doneTask = Task(
      id: 'done-id',
      title: 'Done Task',
      description: 'This task is completed',
      status: 'done',
      createdAt: DateTime(2024, 1, 15),
      updatedAt: DateTime(2024, 1, 15),
    );

    testWidgets('renders task title and description', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: testTask,
              onTap: () {},
              onDelete: () {},
              onStatusChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Test Task Title'), findsOneWidget);
      expect(find.text('Test task description that is a bit longer'), findsOneWidget);
    });

    testWidgets('shows Pending badge for pending task', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: testTask,
              onTap: () {},
              onDelete: () {},
              onStatusChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('shows Done badge for done task', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: doneTask,
              onTap: () {},
              onDelete: () {},
              onStatusChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('checkbox calls onStatusChanged', (tester) async {
      String? capturedStatus;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: testTask,
              onTap: () {},
              onDelete: () {},
              onStatusChanged: (status) => capturedStatus = status,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Checkbox));
      expect(capturedStatus, 'done');
    });

    testWidgets('onTap is called when card is tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: testTask,
              onTap: () => tapped = true,
              onDelete: () {},
              onStatusChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TaskCard));
      expect(tapped, true);
    });
  });
}
