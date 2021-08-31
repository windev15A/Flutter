import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tableName = "todos";
final String columnId = "id";
final String columnName = "name";

class TaskModel {
  final int id;
  final String name;

  TaskModel({this.id, this.name});

  Map<String, dynamic> toMap() => {columnId: id, columnName: name};
}

class HelperDb {
  Database db;
  HelperDb() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    db = await openDatabase(
      join(await getDatabasesPath(), "my_db.db"),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE IF NOT EXISTS $tableName($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnName TEXT NOT NULL)");
      },
      version: 1,
    );
  }

  Future<void> insert(TaskModel task) async {
    try {
      db.insert(tableName, task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print(e);
    }
  }

  Future<List<TaskModel>> getAllTask() async {
    final List<Map<String, dynamic>> tasks = await db.query(tableName);
    return List.generate(tasks.length, (index) {
      return TaskModel(
          name: tasks[index][columnName], id: tasks[index][columnId]);
    });
  }
}
