import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:spend_timer/common/common.dart';
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
    final _timerData = context.watch<TimerData>();
    final _activityTimerScreenData = context.watch<ActivityTimerScreenData>();

    if (_timerData.isRunning == false) {
      titleController.text = _timerData.title;
      descriptionController.text = _timerData.description;
    }

    final _titles = _activityTimerScreenData.titles;

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
                flex: 5,
                child: Center(
                  child: Text(
                    Common.durationFormatB(_timerData.duration),
                    style: const TextStyle(
                      fontSize: 80.0,
                      color: Colors.white,
                    ),
                  ),
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
                      if (value != null) {
                        _timerData.title = value;
                        // title = value;
                      }
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _titles.length,
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
                          _timerData.title = _titles[index];
                          titleController.text = _titles[index];
                        },
                        child: Text(
                          _titles[index],
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
                      if (value != null) {
                        _timerData.description = value;
                      }
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (_timerData.isStopButtonEnabled())
                      GestureDetector(
                        onTap: () {
                          if (_timerData.isStopButtonEnabled()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Press Longer')),
                            );
                          }
                        },
                        onLongPress: () {
                          if (_timerData.isStopButtonEnabled()) {
                            if (_formKey.currentState != null &&
                                _formKey.currentState!.validate()) {
                              Future(
                                () async {
                                  final activity = Activity(
                                    title: _timerData.title!,
                                    description: _timerData.description,
                                    durationInSeconds:
                                        _timerData.duration.inSeconds,
                                    createdTime: DateTime.now(),
                                  );
                                  await _activityTimerScreenData
                                      .insertActivity(activity);
                                  // activity = await _activityTimerScreenData
                                  //     .getActivityByCreatedTime(
                                  //         activity.createdTime);
                                  // print(activity);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ActivityDetail(activity: activity),
                                    ),
                                  );
                                  _timerData.resetScreen();
                                  _activityTimerScreenData.getAllTitle();
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    if (_timerData.isRunning)
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
                            _timerData.stopTimer();
                          },
                          child: const Text(
                            'STOP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      )
                    else
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
                            _timerData.startTimer();
                          },
                          child: const Text(
                            'START',
                            style: TextStyle(color: Colors.white, fontSize: 20),
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
