import 'package:spend_timer/view/search/search_screen_data.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:spend_timer/view/detail/activity_detail_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:spend_timer/common/common.dart';
import 'package:spend_timer/common/constraints.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchScreenData(),
      child: const SearchScreen(),
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activityData = context.watch<SearchScreenData>();
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: kCalenderContainerColor,
              ),
              child: Center(
                child: TextField(
                  controller: activityData.searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      hintStyle: const TextStyle(color: Colors.white),
                      hintText: 'Search...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipOval(
                          child: Material(
                            color: const Color(0xff3e4143),
                            child: InkWell(
                              onTap: () {
                                activityData.searchController.clear();
                                activityData.searchString = '';
                                activityData.getAllActivities();
                              },
                              child: const SizedBox(
                                width: 36,
                                height: 36,
                                child: Icon(Icons.clear,
                                    color: kEventColor, size: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                      border: InputBorder.none),
                  onChanged: (searchString) {
                    activityData.searchString = searchString;
                    activityData.searchActivities(activityData.searchString);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                itemCount: activityData.activities.length,
                itemBuilder: (context, index) {
                  final activity = activityData.activities[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2.0),
                    child: Slidable(
                      key: Key(activity.id.toString()),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        // dismissible: DismissiblePane(onDismissed: () {}),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              if (activity.id != null) {
                                activityData.deleteActivity(activity);
                                activityData.deleteLapTimes(activity);
                              }
                            },
                            backgroundColor: const Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: Container(
                        color: kContainerColor,
                        child: ListTile(
                          // tileColor: Colors.black12,
                          title: Text(
                            activity.title,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            '${DateFormat('yyyy/MM/dd').format(activity.createdTime)} ${activity.description.split('\n').first}',
                            maxLines: 1,
                            style: kTextStyleWhite,
                          ),
                          trailing: Text(
                            Common.durationFormatA(activity.durationInSeconds),
                            style: kTextStyleWhite,
                          ),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ActivityDetail(activity: activity),
                              ),
                            );
                            if (activityData.searchString == '') {
                              activityData.getAllActivities();
                            } else {
                              activityData
                                  .searchActivities(activityData.searchString);
                              activityData.searchController.text =
                                  activityData.searchString;
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
