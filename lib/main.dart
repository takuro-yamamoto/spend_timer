import 'package:flutter/material.dart';
import 'package:spend_timer/view/home/home_screen.dart';

void main() {
  runApp(const SpendTimer());
}

class SpendTimer extends StatelessWidget {
  const SpendTimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Roboto'),
        ),
      ),
      home: const Home(),
    );
  }
}
