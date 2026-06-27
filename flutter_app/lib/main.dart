import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_tracker/core/network/connectivity_service.dart';
import 'package:task_tracker/core/sync/sync_service.dart';
import 'package:task_tracker/core/theme/app_theme.dart';
import 'package:task_tracker/core/theme/theme_provider.dart';
import 'package:task_tracker/features/task/presentation/pages/add_task_page.dart';
import 'package:task_tracker/features/task/presentation/pages/edit_task_page.dart';
import 'package:task_tracker/features/task/presentation/pages/splash_page.dart';
import 'package:task_tracker/features/task/presentation/pages/task_detail_page.dart';
import 'package:task_tracker/features/task/presentation/pages/task_list_page.dart';
import 'package:task_tracker/shared/widgets/offline_banner.dart';

final goRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const TaskListPage(),
    ),
    GoRoute(
      path: '/add-task',
      builder: (context, state) => const AddTaskPage(),
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
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  Timer? _connectivityTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Listen to connectivity changes and update the provider.
    ref.listen(connectivityStreamProvider, (previous, next) async {
      final status = next.valueOrNull ?? ConnectivityStatus.online;
      ref.read(connectivityStatusProvider.notifier).state = status;

      if (mounted) {
        if (status == ConnectivityStatus.online &&
            (previous?.valueOrNull ?? ConnectivityStatus.online) ==
                ConnectivityStatus.offline) {
          // Sync pending operations when coming back online.
          final syncService = ref.read(syncServiceProvider);
          final syncedCount = await syncService.processQueue();
          final pendingCount = await syncService.getPendingCount();
          ref.read(pendingSyncCountProvider.notifier).state = pendingCount;

          if (mounted) {
            final message = syncedCount > 0
                ? 'Kembali online — $syncedCount perubahan disinkronkan'
                : 'Kembali online';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      }
    });

    // Check initial connectivity status.
    _checkConnectivity();

    // Poll connectivity every 3 seconds for real-time detection.
    _connectivityTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _checkConnectivity(),
    );
  }

  @override
  void dispose() {
    _connectivityTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkConnectivity();
    }
  }

  void _checkConnectivity() {
    final connectivityService = ref.read(connectivityServiceProvider);
    connectivityService.checkStatus().then((status) async {
      final previous = ref.read(connectivityStatusProvider);
      ref.read(connectivityStatusProvider.notifier).state = status;

      if (mounted && status == ConnectivityStatus.online && previous == ConnectivityStatus.offline) {
        // Sync pending operations when coming back online.
        final syncService = ref.read(syncServiceProvider);
        final syncedCount = await syncService.processQueue();
        final pendingCount = await syncService.getPendingCount();
        ref.read(pendingSyncCountProvider.notifier).state = pendingCount;

        if (mounted) {
          final message = syncedCount > 0
              ? 'Kembali online — $syncedCount perubahan disinkronkan'
              : 'Kembali online';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Task Tracker',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeMode,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => OfflineBanner(child: child ?? const SizedBox()),
    );
  }
}
