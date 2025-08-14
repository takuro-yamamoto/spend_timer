import 'package:spend_timer/model/entity/activity.dart';
import 'package:spend_timer/model/entity/weekday.dart';
import 'package:flutter/material.dart';
import 'package:spend_timer/model/repository/repository.dart';
import 'package:spend_timer/common/common.dart';

class CalenderScreenData extends ChangeNotifier {
  final Repository _repository = Repository();

  CalenderScreenData() {
    load();
  }

  List<Activity> _activities = [];
  List<Activity> _weekActivities = [];
  List<Activity> _previousWeekActivities = [];
  List<Activity> _totalTimeActivities = [];
  List<Activity> _totalTimeActivitiesCharts = [];
  List<Weekday> _weekdayTime = [];
  List<Weekday> _previousWeekdayTime = [];
  Map<DateTime, List<Activity>> _events = {};
  int _differenceFromLastWeek = 0;

  List<Activity> get activities => _activities;
  List<Activity> get weekActivities => _weekActivities;
  List<Activity> get previousWeekActivities => _previousWeekActivities;
  List<Activity> get totalTimeActivities => _totalTimeActivities;
  List<Activity> get totalTimeActivitiesCharts => _totalTimeActivitiesCharts;
  List<Weekday> get weekdayTime => _weekdayTime;
  List<Weekday> get previousWeekdayTime => _previousWeekdayTime;
  Map<DateTime, List<Activity>> get events => _events;
  int get differenceFromLastWeek => _differenceFromLastWeek;

  DateTime _focusedDay = DateTime.now();
  DateTime get focusedDay => _focusedDay;
  bool isShowTotalTimeWidget = true;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future load() async {
    _startLoading();
    await getAllActivities();
    await getWeekActivities(DateTime.now());
    await getTotalTimeActivities();
    getDifferenceFromLastWeek();
    _finishLoading();
    notifyListeners();
  }

  Future reload() async {
    await getAllActivities();
    await getWeekActivities(DateTime.now());
    await getTotalTimeActivities();
    getDifferenceFromLastWeek();
    notifyListeners();
  }

  void _startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void _finishLoading() {
    _isLoading = false;
    notifyListeners();
  }

  void reset() {
    _activities = [];
    _weekActivities = [];
    _previousWeekActivities = [];
    _totalTimeActivities = [];
    _weekdayTime = [];
    _previousWeekdayTime = [];
    _events = {};
    _isLoading = false;
    _differenceFromLastWeek = 0;
  }

  void daySelected(DateTime day) {
    _focusedDay = day;
    notifyListeners();
  }

  Future getWeekActivities(DateTime day) async {
    _weekActivities = await _repository.getWeekActivities(day);

    _weekdayTime = getWeekday(day, _weekActivities);
    _previousWeekActivities = await _repository
        .getWeekActivities(day.subtract(const Duration(days: 7)));
    _previousWeekdayTime = getWeekday(
        day.subtract(const Duration(days: 7)), _previousWeekActivities);
    // notifyListeners();
  }

  Future getAllActivities() async {
    _activities = await _repository.getAllActivities();
    getEvents();
    // notifyListeners();
  }

  Future getTotalTimeActivities() async {
    _totalTimeActivities = await _repository.getTotalTimeActivities();
    _totalTimeActivitiesCharts = List.from(_totalTimeActivities);
    if (_totalTimeActivitiesCharts.length > 10) {
      // 「その他」の総時間を計算
      int otherTotalTime = 0;
      for (int i = 10; i < _totalTimeActivitiesCharts.length; i++) {
        otherTotalTime += _totalTimeActivitiesCharts[i].durationInSeconds;
      }

      // 「その他」のアクティビティを作成
      Activity otherActivity = Activity(
        title: 'その他',
        durationInSeconds: otherTotalTime,
        createdTime: DateTime.now(),
        description: '', // カスタマイズ可能な色を指定
      );

      // リストから削除
      _totalTimeActivitiesCharts.removeRange(
          10, _totalTimeActivitiesCharts.length);

      // 「その他」のアクティビティを追加
      _totalTimeActivitiesCharts.add(otherActivity);
    }
    addColorToActivity(_totalTimeActivitiesCharts);
  }

  void addColorToActivity(List<Activity> activities) {
    if (activities.length > 10) {
      for (int i = 0; i < 10; i++) {
        activities[i].color = Common.colors[i];
      }
      for (int i = 10; i < activities.length; i++) {
        activities[i].color = Colors.grey;
      }
    } else {
      for (int i = 0; i < activities.length; i++) {
        activities[i].color = Common.colors[i];
      }
    }
  }

  int getTotalTime() {
    int totalTime = 0;
    for (Activity activity in _activities) {
      totalTime += activity.durationInSeconds;
    }
    return totalTime;
  }

  int getTotalWeekTime(List<Activity> weekActivities) {
    int totalTime = 0;
    for (Activity activity in weekActivities) {
      totalTime += activity.durationInSeconds;
    }
    return totalTime;
  }

  void getDifferenceFromLastWeek() {
    _differenceFromLastWeek = getTotalWeekTime(_weekActivities) -
        getTotalWeekTime(_previousWeekActivities);
  }

  List<Weekday> getWeekday(DateTime day, List<Activity> weekActivities) {
    // 週の始まり（日曜日）を計算
    DateTime weekStart = DateTime(day.year, day.month, day.day)
        .subtract(Duration(days: day.weekday % 7));
    int time = 0;
    List<Weekday> weekDayTime = [];

    for (int i = 0; i < 7; i++) {
      time = 0;
      for (Activity activity in weekActivities) {
        DateTime activityDay = DateTime(activity.createdTime.year,
            activity.createdTime.month, activity.createdTime.day);
        if (activityDay.isAtSameMomentAs(weekStart.add(Duration(days: i)))) {
          time += activity.durationInSeconds;
        }
      }
      weekDayTime.add(Weekday(dayOfWeek: Common.weekDays[i], time: time));
    }

    return weekDayTime;
  }

  void getEvents() {
    for (Activity activity in _activities) {
      if (_events.containsKey(DateTime(
        activity.createdTime.year,
        activity.createdTime.month,
        activity.createdTime.day,
      ))) {
        _events[DateTime(
          activity.createdTime.year,
          activity.createdTime.month,
          activity.createdTime.day,
        )]
            ?.add(activity);
      } else {
        _events[DateTime(
          activity.createdTime.year,
          activity.createdTime.month,
          activity.createdTime.day,
        )] = [activity];
      }
    }
  }

  void changeTotalTimeWidget(bool isChanged) {
    isShowTotalTimeWidget = isChanged;
    notifyListeners();
  }
}
