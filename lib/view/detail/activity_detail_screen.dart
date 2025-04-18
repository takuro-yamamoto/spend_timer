import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spend_timer/model/entity/activity.dart';
import 'package:spend_timer/common/common.dart';
import 'package:provider/provider.dart';
import 'package:spend_timer/view/detail/activity_detail_screen_data.dart';
import 'package:spend_timer/common/constraints.dart';

class ActivityDetail extends StatelessWidget {
  final Activity activity;

  const ActivityDetail({super.key, required this.activity});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ActivityDetailScreenData(activity: activity),
      child: ActivityDetailScreen(),
    );
  }
}

class ActivityDetailScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  ActivityDetailScreen({super.key});

  Widget _buildPickerItem(
      int selectedValue, int maxValue, ValueChanged<int> onChanged) {
    return Container(
      height: 90,
      width: 80,
      color: kContainerColor,
      child: ListWheelScrollView(
        itemExtent: 60,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onChanged,
        controller: FixedExtentScrollController(initialItem: selectedValue),
        children: List.generate(
          maxValue,
          (index) => Text(
            index.toString().padLeft(2, '0'),
            style: const TextStyle(
              fontSize: 50,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activityDetailData = context.watch<ActivityDetailScreenData>();

    Duration duration =
        Duration(seconds: activityDetailData.activity.durationInSeconds);
    int selectedHour = 0;
    int selectedMinute = 0;
    int selectedSecond = 0;
    int durationInSeconds = 0;
    String title = activityDetailData.activity.title;
    String description = activityDetailData.activity.description;

    MediaQueryData mediaQuery = MediaQuery.of(context);
    double deviceHeight = mediaQuery.size.height;

    List<Widget> getLapTimes() {
      List<Widget> lapTimesList = [];
      for (int index = 0; index < activityDetailData.lapTimes.length; index++) {
        lapTimesList.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: (index == 0)
                      ? const BorderSide(width: 1, color: kContainerColor)
                      : BorderSide.none,
                  bottom: const BorderSide(width: 1, color: kContainerColor),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lap ${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      Common.durationFormatA(
                          activityDetailData.lapTimes[index].lapTime),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
      return lapTimesList;
    }

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: activityDetailData.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (activityDetailData.activity.id != null) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: const Text('Confirmation'),
                                    content: const Text(
                                        'Are you sure you want to delete?'),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Close the dialog
                                        },
                                      ),
                                      CupertinoDialogAction(
                                        onPressed: () {
                                          // Perform deletion
                                          // Example: Delete data or navigate to another screen
                                          activityDetailData.deleteActivity();

                                          activityDetailData.deleteLapTimes();
                                          Navigator.pop(
                                              context); // Close the dialog
                                          Navigator.pop(context,
                                              true); // Go back to the previous page
                                        },
                                        isDestructiveAction: true,
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (activityDetailData.activity.id != null) {
                              selectedHour = duration.inHours;
                              selectedMinute = duration.inMinutes.remainder(60);
                              selectedSecond = duration.inSeconds.remainder(60);
                              buildShowModalBottomSheet(
                                  context,
                                  deviceHeight,
                                  durationInSeconds,
                                  selectedHour,
                                  selectedMinute,
                                  selectedSecond,
                                  activityDetailData,
                                  title,
                                  description);
                            }
                          },
                        )
                      ],
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          Center(
                            child: Text(
                              DateFormat('yyyy/MM/dd HH:mm:ss').format(
                                  activityDetailData.activity.createdTime),
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: Text(
                              Common.durationFormatA(activityDetailData
                                  .activity.durationInSeconds),
                              style: const TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),

                          const SizedBox(height: 16),
                          Text(
                            activityDetailData.activity.title,
                            style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          // Text(
                          //   'id: ${activity.id}',
                          //   style: TextStyle(fontSize: 16),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              activityDetailData.activity.description,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Column(
                            children: getLapTimes(),
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

  Future<dynamic> buildShowModalBottomSheet(
      BuildContext context,
      double deviceHeight,
      int durationInSeconds,
      int selectedHour,
      int selectedMinute,
      int selectedSecond,
      ActivityDetailScreenData activityDetailData,
      String title,
      String description) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              // height: deviceHeight * 0.9,
              color: kModalEdgeColorColor,
              child: Container(
                decoration: const BoxDecoration(
                  color: kBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.done,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              if (_formKey.currentState != null &&
                                  _formKey.currentState!.validate()) {
                                durationInSeconds = selectedHour * 60 * 60 +
                                    selectedMinute * 60 +
                                    selectedSecond;
                                activityDetailData.activity.title = title;
                                activityDetailData.activity.description =
                                    description;
                                activityDetailData.activity.durationInSeconds =
                                    durationInSeconds;

                                await activityDetailData.updateActivity();
                                Navigator.pop(context);
                              }
                            },
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          width: 270,
                          decoration: BoxDecoration(
                              color: kContainerColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildPickerItem(selectedHour, 100, (value) {
                                selectedHour = value;
                              }),
                              Container(
                                color: kBackgroundColor,
                                width: 1,
                                height: 100,
                              ),
                              _buildPickerItem(selectedMinute, 60, (value) {
                                selectedMinute = value;
                              }),
                              Container(
                                color: kBackgroundColor,
                                width: 1,
                                height: 100,
                              ),
                              _buildPickerItem(selectedSecond, 60, (value) {
                                selectedSecond = value;
                              }),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          decoration: const BoxDecoration(
                              border: Border(
                            top: BorderSide(color: kContainerColor),
                            bottom: BorderSide(color: kContainerColor),
                          )),
                          child: TextFormField(
                            initialValue: activityDetailData.activity.title,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Title',
                              labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 20.0),
                              // filled: true,
                              // fillColor: Colors.white,
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              title = value;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          initialValue: activityDetailData.activity.description,
                          maxLines: 10,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              labelText: 'memo',
                              labelStyle: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                              ),
                              border: InputBorder.none
                              // filled: true,
                              // fillColor: Colors.white,
                              ),
                          onChanged: (value) {
                            description = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
