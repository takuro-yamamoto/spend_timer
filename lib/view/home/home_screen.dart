import 'package:spend_timer/common/constraints.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_timer/view/home/timer_data.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TimerData(),
        ),
      ],
      child: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final timerData = context.watch<TimerData>();
    final PageController controller =
        PageController(initialPage: timerData.selectIndex);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: PageView(
        controller: controller,
        children: timerData.screens,
        onPageChanged: (int index) {
          timerData.onItemTapped(index);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        backgroundColor: Colors.white.withOpacity(0.1),
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.greenAccent,
        currentIndex: timerData.selectIndex,
        onTap: (int index) {
          timerData.onItemTapped(index);
          controller.jumpToPage(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bar_chart,
              // size: 30,
            ),
            label: 'Chart',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              // size: 30,
            ),
            label: 'Start',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
              // size: 30,
            ),
            label: 'List',
          ),
        ],
      ),
    );
  }
}
