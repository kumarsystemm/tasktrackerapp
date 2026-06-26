import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_tracker/core/theme/app_theme.dart';
import 'package:task_tracker/core/theme/theme_provider.dart';
import 'package:task_tracker/features/task/presentation/pages/add_task_page.dart';
import 'package:task_tracker/features/task/presentation/pages/edit_task_page.dart';
import 'package:task_tracker/features/task/presentation/pages/task_detail_page.dart';
import 'package:task_tracker/features/task/presentation/pages/task_list_page.dart';
import 'package:go_router/go_router.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => TaskListPage(),
    ),
    GoRoute(
      path: '/add-task',
      builder: (context, state) => AddTaskPage(),
    ),
    GoRoute(
      path: '/task/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return TaskDetailPage(taskId: id);
      },
    ),
    GoRoute(
      path: '/edit-task/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return EditTaskPage(taskId: id);
      },
    ),
  ],
);

Future<void> main() async {
  await dotenv.load();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Task Tracker',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeMode,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
