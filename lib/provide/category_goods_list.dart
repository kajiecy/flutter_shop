import 'package:flutter/material.dart';
import '../model/category.dart';
import '../model/mall_goods_model.dart';

class CategoryGoodsList with ChangeNotifier{
  List<MallGoodsModel> _mallGoodsModelList = [];
  List<MallGoodsModel> get mallGoodsModelList => _mallGoodsModelList;
  set mallGoodsModelList(List<MallGoodsModel> value) {
    _mallGoodsModelList = value;
    notifyListeners();
  }
}