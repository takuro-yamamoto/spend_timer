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
      child: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _timerData = context.watch<TimerData>();
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: _timerData.screens[_timerData.selectIndex],
      bottomNavigationBar: BottomNavigationBar(
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        backgroundColor: Colors.white.withOpacity(0.1),
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.greenAccent,
        currentIndex: _timerData.selectIndex,
        onTap: _timerData.onItemTapped,
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
