import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:spend_timer/model/db/lap_times_database_helper.dart';
import 'package:spend_timer/model/entity/activity.dart';

class ActivityDatabaseHelper {
  static const _databaseName = 'activity_database.db';
  static const _databaseVersion = 2;

  static const table = 'activities';

  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnDescription = 'description';
  static const columnDurationInSeconds = 'duration_in_seconds';
  static const columnCreatedTime = 'created_time';

  // make this a singleton class
  ActivityDatabaseHelper._privateConstructor();

  static final ActivityDatabaseHelper _instance =
      ActivityDatabaseHelper._privateConstructor();

  factory ActivityDatabaseHelper() {
    return _instance;
  }
  final LapTimesDatabaseHelper _lapTimesHelper = LapTimesDatabaseHelper();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, _databaseName);
    final database = await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
    await database.execute("PRAGMA timezone = 'Asia/Tokyo';");
    return database;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTitle TEXT NOT NULL,
            $columnDescription TEXT NOT NULL,
            $columnCreatedTime TEXT NOT NULL,
            $columnDurationInSeconds INTEGER NOT NULL
          )
          ''');
    await _lapTimesHelper.createLapTimes(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _lapTimesHelper.createLapTimes(db);
    }
  }

  Future<int> insertActivity(Activity activity) async {
    final db = await database;
    return await db.insert(table, activity.toMap());
  }

  Future<int> updateActivity(Activity activity) async {
    final db = await database;
    return await db.update(table, activity.toMap(),
        where: '$columnId = ?', whereArgs: [activity.id]);
  }

  Future<int> deleteActivity(int id) async {
    final db = await database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<Activity>> getTotalTimeActivities() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT $columnTitle, SUM($columnDurationInSeconds) AS "total_time" FROM $table GROUP BY $columnTitle ORDER BY "total_time" DESC ');
    return List.generate(maps.length, (i) {
      return Activity(
          title: maps[i][columnTitle],
          description: "",
          durationInSeconds: maps[i]['total_time'],
          createdTime: DateTime.now());
    });
  }

  Future<List<Activity>> getAllActivities() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT * FROM $table ORDER BY $columnCreatedTime DESC');
    return List.generate(maps.length, (i) {
      return Activity.fromMap(maps[i]);
    });
  }

  Future<List<Activity>> getWeekActivities(DateTime day) async {
    // 週の始まり（日曜日）を計算
    DateTime weekStart = day.subtract(Duration(days: day.weekday % 7));
// 週の終わり（土曜日）を計算
    DateTime weekEnd = weekStart.add(const Duration(days: 6));
    String weekStartStr = DateFormat('yyyy-MM-dd').format(weekStart);
    String weekEndStr = DateFormat('yyyy-MM-dd').format(weekEnd);
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM $table WHERE '$weekStartStr' <= DATE($columnCreatedTime) AND DATE($columnCreatedTime) <= '$weekEndStr' ");

    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return Activity.fromMap(maps[i]);
      });
    } else {
      return [];
    }
  }

  Future<List<Activity>> getDayActivities(DateTime searchDay) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT  * FROM $table WHERE DATE($columnCreatedTime) = '${DateFormat('yyyy-MM-dd').format(searchDay)}' ");
    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return Activity.fromMap(maps[i]);
      });
    } else {
      return [];
    }
  }

  Future<Activity?> getActivity(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(table,
        where: '$columnId = ?', whereArgs: [id], limit: 1);
    if (maps.isNotEmpty) {
      return Activity.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<Activity?> getActivityByCreatedTime(DateTime time) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT  * FROM $table WHERE $columnCreatedTime = '${time.toIso8601String()}' LIMIT 1");
    if (maps.isNotEmpty) {
      return Activity.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Activity>> searchActivities(String searchString) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM $table WHERE $columnTitle LIKE "%$searchString%" OR $columnDescription LIKE "%$searchString%" ORDER BY $columnCreatedTime DESC ');
    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return Activity.fromMap(maps[i]);
      });
    } else {
      return [];
    }
  }

  Future<List<String>> getAllTitle() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT $columnTitle, COUNT(*) AS "count" FROM $table GROUP BY $columnTitle ORDER BY "count" DESC');
    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return maps[i][columnTitle];
      });
    } else {
      return [];
    }
  }
}
