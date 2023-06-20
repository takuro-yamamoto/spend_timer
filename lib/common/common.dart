import 'package:flutter/material.dart';

class Common {
  static List<String> weekDays = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];

  static List<Color> colors = [
    Color.fromRGBO(170, 255, 234, 1), // RGB(170, 255, 234) - HEX #aaffea
    Color.fromRGBO(105, 240, 174, 1), // RGB(105, 240, 174) - HEX #69f0ae
    Color.fromRGBO(24, 179, 117, 1), // RGB(24, 179, 117) - HEX #18b375
    Color.fromRGBO(0, 120, 65, 1), // RGB(0, 120, 65) - HEX #007841
    Color.fromRGBO(0, 66, 17, 1), // RGB(0, 66, 17) - HEX #004211
    Color.fromRGBO(38, 166, 154, 1), // RGB(38, 166, 154) - HEX #26a69a
    Color.fromRGBO(100, 216, 203, 1), // RGB(100, 216, 203) - HEX #64d8cb
    Color.fromRGBO(153, 255, 254, 1), // RGB(153, 255, 254) - HEX #99fffe
    Color.fromRGBO(206, 255, 255, 1), // RGB(206, 255, 255) - HEX #ceffff
    Color.fromRGBO(255, 255, 255, 1), // RGB(255, 255, 255) - HEX #ffffff
  ];

  static String durationFormatA(int seconds) {
    Duration duration = Duration(seconds: seconds);
    // int hours = duration.inHours;
    // int minutes = duration.inMinutes.remainder(60);
    // int secs = duration.inSeconds.remainder(60);
    // return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    switch (duration.toString().length) {
      case 14:
        return duration.toString().substring(0, 7);

      case 15:
        return duration.toString().substring(0, 8);

      case 16:
        return duration.toString().substring(0, 9);
      case 17:
        return duration.toString().substring(0, 10);
    }
    return '';
  }

  static String durationFormatB(Duration duration) {
    // Duration duration = Duration(seconds: seconds);
    // int hours = duration.inHours;
    // int minutes = duration.inMinutes.remainder(60);
    // int secs = duration.inSeconds.remainder(60);
    // return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    switch (duration.toString().length) {
      case 14:
        return duration.toString().substring(0, 7);

      case 15:
        return duration.toString().substring(0, 8);

      case 16:
        return duration.toString().substring(0, 9);
      case 17:
        return duration.toString().substring(0, 10);
    }
    return '';
  }
}
