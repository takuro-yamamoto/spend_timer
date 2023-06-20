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

  ActivityDetail({required this.activity});
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

  Widget _buildPickerItem(
      int selectedValue, int maxValue, ValueChanged<int> onChanged) {
    return Container(
      height: 90,
      width: 80,
      color: kContainerColor,
      child: ListWheelScrollView(
        itemExtent: 60,
        physics: FixedExtentScrollPhysics(),
        children: List.generate(
          maxValue,
          (index) => Text(
            index.toString().padLeft(2, '0'),
            style: TextStyle(
              fontSize: 50,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onSelectedItemChanged: onChanged,
        controller: FixedExtentScrollController(initialItem: selectedValue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _activityDetailData = context.watch<ActivityDetailScreenData>();

    Duration duration =
        Duration(seconds: _activityDetailData.activity.durationInSeconds);
    int selectedHour = 0;
    int selectedMinute = 0;
    int selectedSecond = 0;
    int durationInSecounds = 0;
    String title = _activityDetailData.activity.title;
    String description = _activityDetailData.activity.description;

    MediaQueryData mediaQuery = MediaQuery.of(context);
    double deviceHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: _activityDetailData.isLoading
            ? Center(
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
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (_activityDetailData.activity.id != null) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: Text('Confirmation'),
                                    content: Text(
                                        'Are you sure you want to delete?'),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Close the dialog
                                        },
                                      ),
                                      CupertinoDialogAction(
                                        child: Text('Delete'),
                                        onPressed: () {
                                          // Perform deletion
                                          // Example: Delete data or navigate to another screen
                                          _activityDetailData.deleteActivity();
                                          Navigator.pop(
                                              context); // Close the dialog
                                          Navigator.pop(context,
                                              true); // Go back to the previous page
                                        },
                                        isDestructiveAction: true,
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (_activityDetailData.activity.id != null) {
                              selectedHour = duration.inHours;
                              selectedMinute = duration.inMinutes.remainder(60);
                              selectedSecond = duration.inSeconds.remainder(60);
                              buildShowModalBottomSheet(
                                  context,
                                  deviceHeight,
                                  durationInSecounds,
                                  selectedHour,
                                  selectedMinute,
                                  selectedSecond,
                                  _activityDetailData,
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
                              '${DateFormat('yyyy/MM/dd HH:mm:ss').format(_activityDetailData.activity.createdTime)}',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 16),
                          Center(
                            child: Text(
                              '${Common.durationFormatA(_activityDetailData.activity.durationInSeconds)}',
                              style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            '${_activityDetailData.activity.title}',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 16),
                          // Text(
                          //   'id: ${activity.id}',
                          //   style: TextStyle(fontSize: 16),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${_activityDetailData.activity.description}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
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

  Future<dynamic> buildShowModalBottomSheet(
      BuildContext context,
      double deviceHeight,
      int durationInSecounds,
      int selectedHour,
      int selectedMinute,
      int selectedSecond,
      ActivityDetailScreenData _activityDetailData,
      String title,
      String description) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: deviceHeight * 0.9,
          color: kModalEdgeColorColor,
          child: Container(
            decoration: BoxDecoration(
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
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.done,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                if (_formKey.currentState != null &&
                                    _formKey.currentState!.validate()) {
                                  durationInSecounds = selectedHour * 60 * 60 +
                                      selectedMinute * 60 +
                                      selectedSecond;
                                  _activityDetailData.activity.title = title;
                                  _activityDetailData.activity.description =
                                      description;
                                  _activityDetailData.activity
                                      .durationInSeconds = durationInSecounds;
                                  int result = await _activityDetailData
                                      .updateActivity();
                                  print(result);
                                  Navigator.pop(context);
                                }
                              },
                            )
                          ],
                        ),
                        Container(
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
                        SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                            top: BorderSide(color: kContainerColor),
                            bottom: BorderSide(color: kContainerColor),
                          )),
                          child: TextFormField(
                            initialValue: _activityDetailData.activity.title,
                            style: TextStyle(
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
                              if (value != null) {
                                title = value;
                                // title = value;
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            // color: kContainerColor,
                            child: TextFormField(
                              initialValue:
                                  _activityDetailData.activity.description,
                              maxLines: 10,
                              style: TextStyle(
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
                                if (value != null) {
                                  description = value;
                                }
                              },
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
        ),
      ),
    );
  }
}
