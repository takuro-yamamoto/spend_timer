import 'package:flutter/material.dart';
import 'package:spend_timer/model/entity/activity.dart';
import 'package:spend_timer/model/repository/activity_repository.dart';

class ActivityDetailScreenData extends ChangeNotifier {
  final ActivityRepository _repository = ActivityRepository();
  Activity activity;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  ActivityDetailScreenData({required this.activity}) {
    _startLoading();
    getActivityByCreatedTime(activity.createdTime);
    _finishLoading();
  }

  void _startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void _finishLoading() {
    _isLoading = false;
    notifyListeners();
  }

  Future getActivityByCreatedTime(DateTime time) async {
    Activity? temp;
    temp = await _repository.getActivityByCreatedTime(time);
    if (temp != null) {
      activity = temp;
      notifyListeners();
    }
  }

  Future<int> updateActivity() async {
    int result = 0;
    result = await _repository.updateActivity(activity);
    if (result == 1) {
      notifyListeners();
    }
    return result;
  }

  Future<int> deleteActivity() async {
    int result;
    result = await _repository.deleteActivity(activity.id!);
    print(result);
    if (result == 1) {}
    notifyListeners();
    return result;
  }
}
