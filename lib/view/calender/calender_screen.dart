import 'package:spend_timer/common/common.dart';
import 'package:spend_timer/common/constraints.dart';
import 'package:spend_timer/model/entity/activity.dart';
import 'package:spend_timer/model/entity/weekday.dart';
import 'package:spend_timer/view/calender/calender_day_modal.dart';
import 'package:spend_timer/view/calender/calender_screen_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Calender extends StatelessWidget {
  const Calender({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CalenderScreenData(),
      child: CalenderScreen(),
    );
  }
}

class CalenderScreen extends StatelessWidget {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  final ScrollController _scrollController = ScrollController();

  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final _calenderData = context.watch<CalenderScreenData>();

    //曜日のマス
    Widget weekdayTitle(DateTime day, TextStyle style) {
      return Center(
        child: Text(
          Common.weekDays[day.weekday % 7],
          style: style,
        ),
      );
    }

    //日にちのマス
    Widget dayCell(DateTime day, TextStyle style, Color color) {
      return Container(
        alignment: Alignment.topCenter,
        color: color,
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            day.day.toString(),
            style: style,
          ),
        ),
      );
    }

    //event
    Widget eventBox(String title) {
      return SizedBox(
        height: 20.0,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: kEventColor,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
        ),
      );
    }

    //日にちのモーダル作成
    void showDayEventsModal(DateTime day) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => CalenderDay(day: day),
      ).then((value) {
        _calenderData.reset();
        _calenderData.reload();
      });
    }

    //イベント作成
    Widget getEventsList(
        List<Activity> events, bool isSelectedDay, DateTime day) {
      if (events.isEmpty) {
        return Container();
      }

      List<Widget> eventsList = [];
      for (int i = 0; i < events.length; i++) {
        if (eventsList.length > 2) {
          // イベントが3個以上の時
          if (isSelectedDay) {
            // 選択された日の場合
            return TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                showDayEventsModal(day);
              },
              child: Column(
                children: eventsList,
              ),
            );
          } else {
            // 選択された日じゃない場合
            return Column(
              children: eventsList,
            );
          }
        }

        eventsList.add(eventBox(events[i].title));
      }
      // イベント3個以下
      if (isSelectedDay) {
        // 選択された日の場合
        return TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          onPressed: () {
            showDayEventsModal(day);
          },
          child: Column(
            children: eventsList,
          ),
        );
      } else {
        // 選択されてない日の場合
        return Column(
          children: eventsList,
        );
      }
    }

    return SafeArea(
      child: _calenderData.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ScrollbarTheme(
              data: ScrollbarThemeData(
                trackColor: MaterialStateProperty.all<Color>(Colors.white),
                thumbColor: MaterialStateProperty.all<Color>(Colors.white),
                trackBorderColor:
                    MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: Scrollbar(
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      //総時間
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: kContainerColor,
                          ),
                          width: double.infinity,
                          // height: 200.0,
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  // 'Total Time',
                                  '今までの合計時間',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 20.0,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  Common.durationFormatA(
                                      _calenderData.getTotalTime()),
                                  // textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: SfCartesianChart(
                                  tooltipBehavior:
                                      TooltipBehavior(enable: true),
                                  primaryXAxis: CategoryAxis(
                                    majorGridLines: kMajorGridLinesStyle,
                                    axisLine: kAxisLineStyle,
                                    labelStyle: kTextStyleWhite,
                                  ),
                                  primaryYAxis: NumericAxis(
                                    majorGridLines: kMajorGridLinesStyle,
                                    axisLine: kAxisLineStyle,
                                    labelStyle: kTextStyleWhite,
                                    labelFormat: '{value}h',
                                  ),
                                  series: <ColumnSeries<Activity, String>>[
                                    ColumnSeries<Activity, String>(
                                      color: Colors.white,
                                      name: "Total Time",
                                      // yAxisName: 'hour',
                                      dataSource:
                                          _calenderData.totalTimeActivities,
                                      xValueMapper: (Activity data, _) =>
                                          data.title,
                                      yValueMapper: (Activity data, _) {
                                        double num =
                                            data.durationInSeconds / 3600;
                                        double hour =
                                            (num * 100).truncateToDouble() /
                                                100;
                                        return hour;
                                      },
                                      pointColorMapper: (Activity data, _) =>
                                          data.color,
                                      // Color(0xfff59347),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //週の総時間
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: kContainerColor,
                          ),
                          width: double.infinity,
                          // height: 200.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      // 'This week',
                                      '今週の合計時間',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 20.0,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      // 'This week',
                                      '今週の合計時間',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: kContainerColor,
                                        fontSize: 20.0,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 1.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      Common.durationFormatA(
                                          _calenderData.getTotalWeekTime(
                                              _calenderData.weekActivities)),
                                      // textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '先週と比較して',
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.5),
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        _calenderData.differenceFromLastWeek > 0
                                            ? Text(
                                                '+${Common.durationFormatA(_calenderData.differenceFromLastWeek)}',
                                                // textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Colors.greenAccent,
                                                  fontSize: 20.0,
                                                  // fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : Text(
                                                Common.durationFormatA(
                                                    _calenderData
                                                        .differenceFromLastWeek),
                                                // textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.5),
                                                  fontSize: 20.0,
                                                  // fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: SfCartesianChart(
                                  tooltipBehavior:
                                      TooltipBehavior(enable: true),
                                  primaryXAxis: CategoryAxis(
                                    majorGridLines: kMajorGridLinesStyle,
                                    axisLine: kAxisLineStyle,
                                    labelStyle: kTextStyleWhite,
                                  ),
                                  primaryYAxis: NumericAxis(
                                    majorGridLines: kMajorGridLinesStyle,
                                    axisLine: kAxisLineStyle,
                                    labelStyle: kTextStyleWhite,
                                    labelFormat: '{value}h',
                                  ),
                                  series: <ColumnSeries<Weekday, String>>[
                                    ColumnSeries<Weekday, String>(
                                      color: Colors.greenAccent,
                                      name: "week",
                                      dataSource: _calenderData.weekdayTime,
                                      xValueMapper: (Weekday data, _) =>
                                          data.dayOfWeek,
                                      yValueMapper: (Weekday data, _) {
                                        double num = data.time / 3600;
                                        double hour =
                                            (num * 100).truncateToDouble() /
                                                100;
                                        return hour;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //カレンダー
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: kCalenderContainerColor,
                          ),
                          width: double.infinity,
                          // テーブルカレンダーウィジェット
                          child: Column(
                            children: [
                              TableCalendar(
                                headerStyle: const HeaderStyle(
                                  titleTextStyle: kTextStyleWhite,
                                ),

                                // カレンダーのフォーマット
                                availableCalendarFormats: const {
                                  CalendarFormat.month: 'Month'
                                },
                                rowHeight: 80.0, //行の高さ
                                firstDay: DateTime(2023, 6, 1),
                                lastDay: DateTime.now(), //今日まで
                                focusedDay: _calenderData.focusedDay, //選択された日
                                calendarFormat: _calendarFormat,
                                selectedDayPredicate: (day) {
                                  return isSameDay(_selectedDay, day);
                                },
                                //日にちが押された時の処理
                                onDaySelected: (selectedDay, focusedDay) {
                                  _selectedDay = selectedDay;
                                  _calenderData.daySelected(selectedDay);
                                },
                                //カレンダーのスタイル
                                calendarStyle: const CalendarStyle(
                                  cellAlignment: Alignment.topCenter,
                                ),
                                // カレンダー作成
                                calendarBuilders: CalendarBuilders(
                                  //曜日
                                  dowBuilder:
                                      (BuildContext context, DateTime day) {
                                    if (day.weekday % 7 == 0) {
                                      return weekdayTitle(
                                        day,
                                        kTextStyleRed,
                                      );
                                    } else if (day.weekday % 7 == 6) {
                                      return weekdayTitle(
                                        day,
                                        kTextStyleBlue,
                                      );
                                    } else {
                                      return weekdayTitle(
                                        day,
                                        kTextStyleWhite,
                                      );
                                    }
                                  },
                                  //日にちのマス作成
                                  defaultBuilder: (BuildContext context,
                                      DateTime day, DateTime focusDay) {
                                    if (day.weekday % 7 == 0) {
                                      return dayCell(
                                        day,
                                        kTextStyleRed,
                                        kCalenderContainerColor,
                                      );
                                    } else if (day.weekday % 7 == 6) {
                                      return dayCell(
                                        day,
                                        kTextStyleBlue,
                                        kCalenderContainerColor,
                                      );
                                    } else {
                                      return dayCell(
                                        day,
                                        kTextStyleWhite,
                                        kCalenderContainerColor,
                                      );
                                    }
                                  },
                                  //範囲外の日にちのマス
                                  disabledBuilder: (BuildContext context,
                                      DateTime day, DateTime focusDay) {
                                    return dayCell(day, kTextStyleBlack45,
                                        kCalenderContainerColor);
                                  },
                                  //現在のカレンダーの他の月の部分
                                  outsideBuilder: (BuildContext context,
                                      DateTime day, DateTime focusDay) {
                                    if (day.weekday % 7 == 0) {
                                      return dayCell(
                                        day,
                                        TextStyle(
                                            color: Colors.red.withOpacity(0.5)),
                                        kCalenderContainerColor,
                                      );
                                    } else if (day.weekday % 7 == 6) {
                                      return dayCell(
                                        day,
                                        TextStyle(
                                            color:
                                                Colors.blue.withOpacity(0.5)),
                                        kCalenderContainerColor,
                                      );
                                    } else {
                                      return dayCell(
                                        day,
                                        kTextStyleWhite38,
                                        kCalenderContainerColor,
                                      );
                                    }
                                  },

                                  // 選択された日
                                  selectedBuilder: (BuildContext context,
                                      DateTime day, DateTime focusedDay) {
                                    if (day.weekday % 7 == 0) {
                                      return TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: () {
                                          showDayEventsModal(day);
                                        },
                                        child: dayCell(
                                          day,
                                          kTextStyleRed,
                                          kContainerColor,
                                        ),
                                      );
                                    } else if (day.weekday % 7 == 6) {
                                      return TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: () {
                                          showDayEventsModal(day);
                                        },
                                        child: dayCell(
                                          day,
                                          kTextStyleBoldBlue,
                                          kContainerColor,
                                        ),
                                      );
                                    } else {
                                      return TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: () {
                                          showDayEventsModal(day);
                                        },
                                        child: dayCell(
                                          day,
                                          kTextStyleBoldWhite,
                                          kContainerColor,
                                        ),
                                      );
                                    }
                                  },
                                  // 本日
                                  todayBuilder: (BuildContext context,
                                      DateTime day, DateTime focusedDay) {
                                    if (day.weekday % 7 == 0) {
                                      return dayCell(
                                        day,
                                        kTextStyleRed,
                                        kCalenderContainerColor,
                                      );
                                    } else if (day.weekday % 7 == 6) {
                                      return dayCell(
                                        day,
                                        kTextStyleBlue,
                                        kCalenderContainerColor,
                                      );
                                    } else {
                                      return dayCell(
                                        day,
                                        kTextStyleWhite,
                                        kCalenderContainerColor,
                                      );
                                    }
                                  },
                                  //イベント作成
                                  markerBuilder: (BuildContext context,
                                      DateTime day,
                                      List<dynamic> dailyScheduleList) {
                                    List<Activity> dayEvents =
                                        dailyScheduleList.cast<Activity>();
                                    dayEvents = dayEvents.reversed.toList();

                                    if (dailyScheduleList.isNotEmpty) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: getEventsList(
                                          dayEvents,
                                          isSameDay(day, _selectedDay),
                                          day,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                // イベント取得
                                eventLoader: (DateTime dateTime) {
                                  return _calenderData.events[DateTime(
                                          dateTime.year,
                                          dateTime.month,
                                          dateTime.day)] ??
                                      [];
                                },
                              ),
                              Container(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 70,
                          width: double.infinity,
                          child: IconButton(
                            color: Colors.white,
                            icon: const Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _scrollController.animateTo(0, // 移動したい位置を指定
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.ease);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
