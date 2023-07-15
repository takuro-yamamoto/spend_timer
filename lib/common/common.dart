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
    const Color.fromRGBO(170, 255, 234, 1), // RGB(170, 255, 234) - HEX #aaffea
    const Color.fromRGBO(105, 240, 174, 1), // RGB(105, 240, 174) - HEX #69f0ae
    const Color.fromRGBO(24, 179, 117, 1), // RGB(24, 179, 117) - HEX #18b375
    const Color.fromRGBO(0, 120, 65, 1), // RGB(0, 120, 65) - HEX #007841
    const Color.fromRGBO(0, 66, 17, 1), // RGB(0, 66, 17) - HEX #004211
    const Color.fromRGBO(38, 166, 154, 1), // RGB(38, 166, 154) - HEX #26a69a
    const Color.fromRGBO(100, 216, 203, 1), // RGB(100, 216, 203) - HEX #64d8cb
    const Color.fromRGBO(153, 255, 254, 1), // RGB(153, 255, 254) - HEX #99fffe
    const Color.fromRGBO(206, 255, 255, 1), // RGB(206, 255, 255) - HEX #ceffff
    const Color.fromRGBO(255, 255, 255, 1), // RGB(255, 255, 255) - HEX #ffffff
  ];

  static String durationFormatA(int seconds) {
    Duration duration = Duration(seconds: seconds);
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

  static String durationFormatC(Duration duration) {
    switch (duration.toString().length) {
      case 14:
        return duration.toString().substring(0, 9);

      case 15:
        return duration.toString().substring(0, 10);

      case 16:
        return duration.toString().substring(0, 11);
      case 17:
        return duration.toString().substring(0, 12);
    }
    return '';
  }

  static String durationFormatD(int seconds) {
    Duration duration = Duration(seconds: seconds);
    switch (duration.toString().length) {
      case 14:
        return duration.toString().substring(0, 10);

      case 15:
        return duration.toString().substring(0, 11);

      case 16:
        return duration.toString().substring(0, 12);
      case 17:
        return duration.toString().substring(0, 13);
    }
    return '';
  }
}
