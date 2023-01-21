import 'package:flutter/material.dart';

class ViewSettings {
  //singleton
  static final ViewSettings _instance = ViewSettings._internal();
  factory ViewSettings() => _instance;
  ViewSettings._internal();

  final String title = 'Resource Management';
  final double sideBarWidth = 250;
  final Color backgroundColor = const Color.fromRGBO(52, 58, 64, 1);
}
