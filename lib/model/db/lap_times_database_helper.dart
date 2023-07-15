import 'package:sqflite/sqflite.dart';
import 'package:spend_timer/model/db/activity_database_helper.dart';
import 'package:spend_timer/model/entity/lap_time.dart';

class LapTimesDatabaseHelper {
  static const table = 'lap_times';
  static const columnId = 'id';
  static const columnActivityId = 'activity_id';
  static const columnLapTime = 'lap_time';
  static const columnCreatedTime = 'created_time';

  Future<void> createLapTimes(Database db) async {
    await db.execute('''
      CREATE TABLE $table (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnActivityId INTEGER NOT NULL,
        $columnLapTime INTEGER NOT NULL,
        $columnCreatedTime TEXT NOT NULL
      )
    ''');
  }

  Future<Database> getActivityDatabase() async {
    return await ActivityDatabaseHelper().database;
  }

  Future<int> insertLapTime(LapTime lapTime) async {
    final Database db = await getActivityDatabase();
    final Map<String, dynamic> row = lapTime.toMap();
    return await db.insert(table, row);
  }

  Future<List<LapTime>> getLapTimesByActivityId(int activityId) async {
    final Database db = await getActivityDatabase();

    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: '$columnActivityId = ?',
      whereArgs: [activityId],
    );
    return List.generate(maps.length, (index) {
      return LapTime.fromMap(maps[index]);
    });
  }

  Future<int> deleteLapTimes(int activityId) async {
    final db = await getActivityDatabase();
    return await db
        .delete(table, where: '$columnActivityId = ?', whereArgs: [activityId]);
  }
}
