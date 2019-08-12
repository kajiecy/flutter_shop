import 'package:flutter/material.dart';

class Counter with ChangeNotifier{
  int value = 0;
  increment(){
    this.value ++;
    notifyListeners();
  }
}