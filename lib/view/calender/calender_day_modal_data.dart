import 'package:flutter/material.dart';
import 'package:spend_timer/model/entity/activity.dart';
import 'package:spend_timer/model/repository/activity_repository.dart';

class CalenderDayModalData extends ChangeNotifier {
  final ActivityRepository _repository = ActivityRepository();
  DateTime day;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Activity> _dayActivities = [];
  List<Activity> get dayActivities => _dayActivities;

  CalenderDayModalData({required this.day}) {
    _startLoading();
    getDayActivities(day);
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

  Future getDayActivities(DateTime day) async {
    _dayActivities = await _repository.getDayActivities(day);
    notifyListeners();
  }

  Future deleteActivity(Activity activity, DateTime day) async {
    int num;
    num = await _repository.deleteActivity(activity.id!);
  }

  void reset() {
    _dayActivities = [];
  }
}
