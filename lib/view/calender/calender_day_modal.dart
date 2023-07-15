import 'package:spend_timer/view/calender/calender_day_modal_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spend_timer/common/constraints.dart';
import 'package:spend_timer/common/common.dart';

import '../detail/activity_detail_screen.dart';

class CalenderDay extends StatelessWidget {
  final DateTime day;

  const CalenderDay({super.key, required this.day});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CalenderDayModalData(day: day),
      child: CalenderDayModal(
        day: day,
      ),
    );
  }
}

class CalenderDayModal extends StatelessWidget {
  // const ({Key? key}) : super(key: key);
  final DateTime day;

  const CalenderDayModal({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double deviceHeight = mediaQuery.size.height;
    final calenderDayData = context.watch<CalenderDayModalData>();

    return Container(
      color: kModalEdgeColorColor,
      child: Container(
        height: deviceHeight * 0.8,
        decoration: const BoxDecoration(
          color: kBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        child: Column(
          children: [
            const Expanded(
              flex: 1,
              child: SizedBox(
                width: 150.0,
                height: 20.0,
                child: Divider(
                  thickness: 3.0,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '${DateFormat('yyyy/MM/dd').format(day)} ${Common.weekDays[day.weekday % 7]}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              flex: 20,
              child: ListView.builder(
                itemCount: calenderDayData.dayActivities.length,
                itemBuilder: (context, index) {
                  final activity = calenderDayData.dayActivities[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 2.0,
                    ),
                    child: Container(
                      color: kContainerColor,
                      child: Slidable(
                        key: Key(activity.id.toString()),
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          // dismissible: DismissiblePane(onDismissed: () {}),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                if (activity.id != null) {
                                  await calenderDayData.deleteActivity(
                                      activity, day);
                                  calenderDayData.deleteLapTimes(activity);

                                  calenderDayData.reset();
                                  calenderDayData.getDayActivities(day);
                                }
                              },
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: ListTile(
                          // tileColor:
                          title: Text(
                            activity.title,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            activity.description.split('\n').first,
                            maxLines: 1,
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: Text(
                            Common.durationFormatA(activity.durationInSeconds),
                            style: const TextStyle(color: Colors.white),
                          ),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ActivityDetail(activity: activity),
                              ),
                            );

                            calenderDayData.reset();
                            calenderDayData.getDayActivities(day);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
