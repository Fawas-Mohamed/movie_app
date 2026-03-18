import'package:flutter/material.dart';

class TabControllerNotifier {
  static final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  static void changeTab(int index) {
    currentIndex.value = index;
  }
}