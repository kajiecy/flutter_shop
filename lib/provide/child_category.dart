import 'package:flutter/material.dart';
import '../model/category.dart';
import '../model/mall_goods_model.dart';

class ChildCategory with ChangeNotifier{
   List<BxMallSubDto> childCategoryList= [];
   List<MallGoodsModel> _mallGoodsModelList = [];



   int _currentIndex = 0;
   int _secondCurrentIndex = 0;
   String _currentCategoryId = '4';

   setChildCategoryModel(List<BxMallSubDto> childCategoryList){
     BxMallSubDto bxMallSubDto = BxMallSubDto(comments: '',mallCategoryId: '',mallSubId: '',mallSubName: '全部');
     this.childCategoryList.clear();
     this.childCategoryList.add(bxMallSubDto);
     this.childCategoryList.addAll(childCategoryList);
     this.secondCurrentIndex = 0;
     notifyListeners();
   }

   set currentIndex(int value){
     this._currentIndex = value;
     notifyListeners();
   }
   int get currentIndex {
     return this._currentIndex;
   }

   set secondCurrentIndex(int value) {
     this._secondCurrentIndex = value;
     notifyListeners();
   }
   int get secondCurrentIndex {
     return this._secondCurrentIndex;;
   }

   set currentCategoryId(String value) {
     this._currentCategoryId = value;
     notifyListeners();
   }
   String get currentCategoryId {
     return this._currentCategoryId;
   }


   List<MallGoodsModel> get mallGoodsModelList => _mallGoodsModelList;
   set mallGoodsModelList(List<MallGoodsModel> value) {
     _mallGoodsModelList = value;
     notifyListeners();
   }
}