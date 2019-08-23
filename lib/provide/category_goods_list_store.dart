import 'package:flutter/material.dart';
import '../model/category.dart';
import '../model/mall_goods_model.dart';

class CategoryGoodsListStore with ChangeNotifier{


  List<MallGoodsModel> mallGoodsModelList = [];

  void setMallGoodsModelList(List<MallGoodsModel> value) {
    this.mallGoodsModelList.clear();
    this.mallGoodsModelList.addAll(value);
    notifyListeners();
  }
  void addMallGoodsModelList(List<MallGoodsModel> value) {
    this.mallGoodsModelList.addAll(value);
    notifyListeners();
  }
}