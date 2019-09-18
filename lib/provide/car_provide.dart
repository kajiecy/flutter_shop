import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CarProvide with ChangeNotifier{
  static final String useSaveName = 'carInfo';
  String carString = "[]";
  save(goodsId,goodsName,count,price,image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    carString = prefs.getString(useSaveName);
    var temp = carString == null ?[]:json.decode(carString);
    List<Map> tempList = (temp as List).cast();
    bool isHave = false;
    tempList.forEach((item){
      if(item['goodsId']==goodsId){
        item['count'] ++;
        isHave = true;
      }
    });
    if(!isHave){
      tempList.add({'goodsId':goodsId,'goodsName':goodsName,'count':count,'price':price,'image':image});
    }
    carString = json.encode(tempList).toString();
    print(carString);
    prefs.setString(useSaveName, carString);
    notifyListeners();
  }
  removeCarInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(useSaveName);
    notifyListeners();
  }
}