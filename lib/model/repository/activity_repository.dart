import 'package:spend_timer/model/db/activity_database_helper.dart';
import 'package:spend_timer/model/entity/activity.dart';

class ActivityRepository {
  final ActivityDatabaseHelper _dbHelper = ActivityDatabaseHelper();

  Future<List<String>> getAllTitle() => _dbHelper.getAllTitle();

  Future<int> insertActivity(activity) => _dbHelper.insertActivity(activity);

  Future<List<Activity>> getAllActivities() => _dbHelper.getAllActivities();

  Future<List<Activity>> getTotalTimeActivities() =>
      _dbHelper.getTotalTimeActivities();

  Future<List<Activity>> searchActivities(searchString) =>
      _dbHelper.searchActivities(searchString);

  Future<List<Activity>> getWeekActivities(DateTime day) =>
      _dbHelper.getWeekActivities(day);

  Future<List<Activity>> getDayActivities(DateTime day) =>
      _dbHelper.getDayActivities(day);

  Future<Activity?> getActivityByCreatedTime(DateTime time) =>
      _dbHelper.getActivityByCreatedTime(time);

  Future<int> deleteActivity(int id) => _dbHelper.deleteActivity(id);

  Future<int> updateActivity(Activity activity) =>
      _dbHelper.updateActivity(activity);
}
