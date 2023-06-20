import 'package:flutter/material.dart';
import 'dart:async';
import 'package:spend_timer/model/repository/activity_repository.dart';

class ActivityTimerScreenData extends ChangeNotifier {
  final ActivityRepository _repository = ActivityRepository();

  ActivityTimerScreenData() {
    getAllTitle();
  }

  List<String> _titles = [];

  List<String> get titles => _titles;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void getAllTitle() async {
    _startLoading();
    _titles = await _repository.getAllTitle();
    _finishLoading();
  }

  Future<int> insertActivity(activity) async {
    return await _repository.insertActivity(activity);
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
