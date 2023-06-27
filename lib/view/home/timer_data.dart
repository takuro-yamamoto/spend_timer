import 'package:flutter/material.dart';
import 'dart:async';
import 'package:spend_timer/view/calender/calender_screen.dart';
import 'package:spend_timer/view/activity_timer/activity_timer_screen.dart';
import 'package:spend_timer/view/search/search_screen.dart';

class TimerData extends ChangeNotifier {
  String _timerText = '0:00:00';
  Duration _duration = const Duration();
  Timer? _timer;
  bool _isRunning = false;
  bool _isFirstTimeStartButtonPressed = false;
  String title = '';
  String description = '';
  late DateTime _startTime;
  late DateTime _stopTime;
  Duration _pausedDuration = const Duration();

  int _selectedIndex = 1;
  get selectIndex => _selectedIndex;

  final List<Widget> _screens = [
    const Calender(),
    const ActivityTimer(),
    const Search(),
  ];
  get screens => _screens;

  void onItemTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  String get timerText {
    return _timerText;
  }

  Duration get duration {
    return _duration;
  }

  bool get isRunning {
    return _isRunning;
  }

  bool get isFirstTimeStartButtonPressed {
    return _isFirstTimeStartButtonPressed;
  }

  bool isStopButtonEnabled() {
    if (_isRunning == false && _isFirstTimeStartButtonPressed) {
      return true;
    } else {
      return false;
    }
  }

  void startTimer() {
    _isRunning = true;
    if (_isFirstTimeStartButtonPressed == false) {
      _startTime = DateTime.now();
      _isFirstTimeStartButtonPressed = true;
    } else {
      _pausedDuration += DateTime.now().difference(_stopTime);
    }

    notifyListeners();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _duration = DateTime.now().difference(_startTime) - _pausedDuration;

      notifyListeners();
    });
  }

  void stopTimer() {
    _isRunning = false;
    _timer?.cancel();
    _stopTime = DateTime.now();
    notifyListeners();
  }

  void resetScreen() {
    _isRunning = false;
    _isFirstTimeStartButtonPressed = false;
    _duration = const Duration();
    _pausedDuration = const Duration();
    _timerText = '0:00:00';
    title = '';
    description = '';
    notifyListeners();
  }
}
