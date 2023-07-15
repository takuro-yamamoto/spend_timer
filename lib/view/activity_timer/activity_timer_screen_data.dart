import 'package:flutter/material.dart';
import 'dart:async';
import 'package:spend_timer/model/repository/repository.dart';
import 'package:spend_timer/model/entity/activity.dart';

import 'package:spend_timer/model/entity/lap_time.dart';

class ActivityTimerScreenData extends ChangeNotifier {
  final Repository _repository = Repository();

  ActivityTimerScreenData() {
    getAllTitle();
  }

  List<String> _titles = [];

  List<String> get titles => _titles;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void _finishLoading() {
    _isLoading = false;
    notifyListeners();
  }

  void getAllTitle() async {
    _startLoading();
    _titles = await _repository.getAllTitle();
    _finishLoading();
  }

  Future<int> insertActivity(Activity activity) async {
    return await _repository.insertActivity(activity);
  }

  Future<Activity?> getActivityByCreatedTime(DateTime time) async {
    Activity? activity;
    activity = await _repository.getActivityByCreatedTime(time);
    return activity;
  }

  Future<int> insertLapTimes(List<LapTime> lapTimes) async {
    int returnCode = 0;
    for (LapTime lapTime in lapTimes) {
      returnCode += await _repository.insertLapTime(lapTime);
    }
    return returnCode;
  }
}
