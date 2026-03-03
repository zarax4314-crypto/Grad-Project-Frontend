import 'package:flutter/material.dart';

class Responsive {
  static late double _width;
  static late double _height;

  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _width = size.width;
    _height = size.height;
  }

  // width percentage
  static double w(double percent) {
    return _width * percent;
  }

  // height percentage
  static double h(double percent) {
    return _height * percent;
  }

  // scalable font size (اختياري)
  static double sp(double size) {
    return size * (_width / 375); // 375 = عرض iPhone reference
  }
}