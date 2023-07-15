import 'package:spend_timer/model/entity/activity.dart';
import 'package:flutter/material.dart';
import 'package:spend_timer/model/repository/repository.dart';

class SearchScreenData extends ChangeNotifier {
  final Repository _repository = Repository();

  SearchScreenData() {
    getAllActivities();
  }

  List<Activity> _activities = [];

  List<Activity> get activities => _activities;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String searchString = '';

  void _startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void _finishLoading() {
    _isLoading = false;
    notifyListeners();
  }

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

  Future<int> deleteLapTimes(Activity activity) async {
    int result;
    result = await _repository.deleteLapTimes(activity.id!);
    notifyListeners();
    return result;
  }
}
