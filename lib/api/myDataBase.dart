import 'package:language/models/taskModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tableName = "todos";
final String columnId = "id";
final String columnName = "name";

class DB {


  Future<Database> initDatabase() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, "my_db.db"),
      onCreate: (db, version) async {
        await db.execute("""CREATE TABLE IF NOT EXISTS $tableName(
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
             $columnName TEXT NOT NULL)
             """);
      },
      version: 1,
    );
  }

  Future<void> insert(TaskModel task) async {
    final Database db = await initDatabase();
    try {
      db.insert(tableName, task.toMap());
    } catch (e) {
      print(e);
    }
  }

  Future<List<TaskModel>> getAllTask() async {
    final Database db = await initDatabase();
    final List<Map<String, dynamic>> tasks = await db.query(tableName);
    return tasks.map((e) => TaskModel.fromMap(e)).toList();
  }
}
