import 'package:spend_timer/model/entity/activity.dart';
import 'package:flutter/material.dart';
import 'package:spend_timer/model/repository/activity_repository.dart';

class SearchScreenData extends ChangeNotifier {
  final ActivityRepository _repository = ActivityRepository();

  SearchScreenData() {
    getAllActivities();
  }

  List<Activity> _activities = [];

  List<Activity> get activities => _activities;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void getAllActivities() async {
    _startLoading();
    _activities = await _repository.getAllActivities();
    _finishLoading();
  }

  void searchActivities(String searchString) async {
    _startLoading();
    _activities = await _repository.searchActivities(searchString);
    _finishLoading();
  }

  void deleteActivity(Activity activity) async {
    _startLoading();
    int num;
    num = await _repository.deleteActivity(activity.id!);
    getAllActivities();

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
}
