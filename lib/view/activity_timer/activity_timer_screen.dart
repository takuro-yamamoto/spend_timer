import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:spend_timer/common/common.dart';
import 'package:spend_timer/model/entity/lap_time.dart';
import 'package:spend_timer/view/detail/activity_detail_screen.dart';
import 'package:spend_timer/model/entity/activity.dart';
import 'package:spend_timer/view/home/timer_data.dart';
import 'activity_timer_screen_data.dart';
import 'package:spend_timer/common/constraints.dart';

//活動時間登録画面
class ActivityTimer extends StatelessWidget {
  const ActivityTimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ActivityTimerScreenData(),
      child: ActivityTimerScreen(),
    );
  }
}

final titleController = TextEditingController();
final descriptionController = TextEditingController();

class ActivityTimerScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  ActivityTimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final timerData = context.watch<TimerData>();
    final activityTimerScreenData = context.watch<ActivityTimerScreenData>();
    final ScrollController scrollController = timerData.scrollController;

    if (timerData.isRunning == false) {
      titleController.text = timerData.title;
      descriptionController.text = timerData.description;
    }

    final titles = activityTimerScreenData.titles;

    return Form(
      key: _formKey,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: kContainerColor),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      Common.durationFormatB(timerData.duration),
                      style: const TextStyle(
                        fontSize: 80.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: ListView.builder(
                  controller: scrollController,
                  // reverse: true,
                  itemCount: timerData.lapTimes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return LapItem(
                      index: timerData.lapTimes.length - index,
                      duration: Common.durationFormatB(timerData
                          .lapTimes[timerData.lapTimes.length - 1 - index]),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 1, color: kContainerColor),
                    ),
                  ),
                  child: TextFormField(
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    controller: titleController,
                    decoration: InputDecoration(
                      fillColor: kBackgroundColor,
                      labelText: 'Title',
                      labelStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      ),
                      filled: true,
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      timerData.title = value;
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: titles.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        // color: kContainerColor,
                      ),
                      height: 32.0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 5.0),
                      margin: const EdgeInsets.only(left: 5),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: kContainerColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        onPressed: () {
                          timerData.title = titles[index];
                          titleController.text = titles[index];
                        },
                        child: Text(
                          titles[index],
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 1, color: kContainerColor),
                      bottom: BorderSide(width: 1, color: kContainerColor),
                    ),
                  ),
                  child: TextFormField(
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    controller: descriptionController,
                    // initialValue: _timerData.description,
                    decoration: InputDecoration(
                      labelText: 'memo',
                      labelStyle:
                          TextStyle(color: Colors.white.withOpacity(0.5)),
                      filled: true,
                      fillColor: kBackgroundColor,
                      border: InputBorder.none,
                    ),
                    maxLines: 10,
                    onChanged: (value) {
                      timerData.description = value;
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: (timerData.isRunning)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 120,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: kContainerColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                timerData.lapTimer();
                                scrollController.jumpTo(0);
                              },
                              child: const Text(
                                'LAP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 120,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                timerData.stopTimer();
                              },
                              child: const Text(
                                'STOP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (timerData.isSaveButtonEnabled())
                            GestureDetector(
                              onTap: () {
                                if (timerData.isSaveButtonEnabled()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Press Longer')),
                                  );
                                }
                              },
                              onLongPress: () {
                                if (timerData.isSaveButtonEnabled()) {
                                  if (_formKey.currentState != null &&
                                      _formKey.currentState!.validate()) {
                                    Future(
                                      () async {
                                        Activity activity = Activity(
                                          title: timerData.title,
                                          description: timerData.description,
                                          durationInSeconds:
                                              timerData.duration.inSeconds,
                                          createdTime: DateTime.now(),
                                        );
                                        await activityTimerScreenData
                                            .insertActivity(activity);
                                        Activity? temp =
                                            await activityTimerScreenData
                                                .getActivityByCreatedTime(
                                                    activity.createdTime);
                                        if (temp != null) {
                                          activity = temp;
                                          List<LapTime> lapTimes = [];
                                          for (Duration duration
                                              in timerData.lapTimes) {
                                            lapTimes.add(
                                              LapTime(
                                                  activityId: activity.id!,
                                                  lapTime: duration.inSeconds,
                                                  createdTime:
                                                      activity.createdTime),
                                            );
                                          }
                                          await activityTimerScreenData
                                              .insertLapTimes(lapTimes);
                                        }
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ActivityDetail(
                                                    activity: activity),
                                          ),
                                        );
                                        timerData.resetScreen();
                                        activityTimerScreenData.getAllTitle();
                                      },
                                    );
                                  }
                                }
                              },
                              child: Container(
                                width: 120,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  // shape: BoxShape.circle,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Center(
                                  child: Text(
                                    'SAVE',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          Container(
                            width: 120,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              // shape: BoxShape.circle,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: TextButton(
                              // shape
                              onPressed: () {
                                timerData.startTimer();
                              },
                              child: const Text(
                                'START',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LapItem extends StatelessWidget {
  const LapItem({
    super.key,
    required this.index,
    required this.duration,
  });

  final int index;
  final String duration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: kContainerColor),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lap $index',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              Text(
                duration,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
