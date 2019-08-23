import 'package:flutter/material.dart';
import '../model/category.dart';
import '../model/mall_goods_model.dart';

class ChildCategory with ChangeNotifier{
   List<BxMallSubDto> _childCategoryList= [];
   int _secondCurrentIndex = 0;

   int _currentPage = 1;

   int get currentPage => _currentPage;

   set currentPage(int value) {
     _currentPage = value;
     notifyListeners();
   }

   int get secondCurrentIndex => _secondCurrentIndex;

   set secondCurrentIndex(int value) {
     _secondCurrentIndex = value;
     notifyListeners();
   }

   List<BxMallSubDto> get childCategoryList => _childCategoryList;

   set childCategoryList(List<BxMallSubDto> value) {
     BxMallSubDto bxMallSubDto = BxMallSubDto(comments: '',mallCategoryId: value[0].mallCategoryId,mallSubId: '',mallSubName: '全部');
     this.childCategoryList.clear();
     this.childCategoryList.add(bxMallSubDto);
     this.childCategoryList.addAll(value);
     this.secondCurrentIndex = 0;
     notifyListeners();
   }

   BxMallSubDto getCurrentBxMallSubDtoInfo(){
     return this._childCategoryList[_secondCurrentIndex];
   }
}