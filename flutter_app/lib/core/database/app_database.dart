import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_tracker/api/models/task.dart' as api;
import 'package:task_tracker/api/models/task_status.dart' as api;

class AppDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'task_tracker.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  static Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE sync_queue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        operation TEXT NOT NULL,
        entity_id TEXT,
        temp_id TEXT,
        payload TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  static Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS sync_queue (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          operation TEXT NOT NULL,
          entity_id TEXT,
          temp_id TEXT,
          payload TEXT NOT NULL,
          created_at TEXT NOT NULL
        )
      ''');
    }
  }

  // --- Task CRUD ---

  static Future<void> insertTask(api.Task task) async {
    final db = await database;
    await db.insert(
      'tasks',
      {
        'id': task.id,
        'title': task.title,
        'description': task.description,
        'status': task.status.toJson(),
        'created_at': task.createdAt.toIso8601String(),
        'updated_at': task.updatedAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> insertTasks(List<api.Task> tasks) async {
    final db = await database;
    final batch = db.batch();
    for (final task in tasks) {
      batch.insert(
        'tasks',
        {
          'id': task.id,
          'title': task.title,
          'description': task.description,
          'status': task.status.toJson(),
          'created_at': task.createdAt.toIso8601String(),
          'updated_at': task.updatedAt.toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  static Future<api.Task?> getTaskById(String id) async {
    final db = await database;
    final maps = await db.query('tasks', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return api.Task(
      id: maps[0]['id']! as String,
      title: maps[0]['title']! as String,
      description: maps[0]['description']! as String,
      status: api.TaskStatus.fromJson(maps[0]['status']! as String),
      createdAt: DateTime.parse(maps[0]['created_at']! as String),
      updatedAt: DateTime.parse(maps[0]['updated_at']! as String),
    );
  }

  static Future<List<api.Task>> getAllTasks() async {
    final db = await database;
    final maps = await db.query('tasks', orderBy: 'created_at DESC');
    return maps.map((map) => api.Task(
      id: map['id']! as String,
      title: map['title']! as String,
      description: map['description']! as String,
      status: api.TaskStatus.fromJson(map['status']! as String),
      createdAt: DateTime.parse(map['created_at']! as String),
      updatedAt: DateTime.parse(map['updated_at']! as String),
    ),).toList();
  }

  static Future<void> updateTask(api.Task task) async {
    final db = await database;
    await db.update(
      'tasks',
      {
        'title': task.title,
        'description': task.description,
        'status': task.status.toJson(),
        'updated_at': task.updatedAt.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  static Future<void> deleteTask(String id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> clearAll() async {
    final db = await database;
    await db.delete('tasks');
  }

  // --- Sync Queue ---

  static Future<void> addToSyncQueue({
    required String operation,
    String? entityId,
    String? tempId,
    required Map<String, dynamic> payload,
  }) async {
    final db = await database;
    await db.insert('sync_queue', {
      'operation': operation,
      'entity_id': entityId,
      'temp_id': tempId,
      'payload': jsonEncode(payload),
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  static Future<List<Map<String, dynamic>>> getSyncQueue() async {
    final db = await database;
    return db.query('sync_queue', orderBy: 'id ASC');
  }

  static Future<void> removeSyncQueueItem(int id) async {
    final db = await database;
    await db.delete('sync_queue', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> getSyncQueueCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM sync_queue');
    return result.first['count'] as int;
  }

  static Future<void> clearSyncQueue() async {
    final db = await database;
    await db.delete('sync_queue');
  }
}
