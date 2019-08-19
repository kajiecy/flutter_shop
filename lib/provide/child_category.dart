import 'package:flutter/material.dart';
import '../model/category.dart';
import '../model/mall_goods_model.dart';

class ChildCategory with ChangeNotifier{
   List<BxMallSubDto> childCategoryList= [];

   setChildCategoryModel(List<BxMallSubDto> childCategoryList){
     BxMallSubDto bxMallSubDto = BxMallSubDto(comments: '',mallCategoryId: '',mallSubId: '',mallSubName: '全部');
     this.childCategoryList.clear();
     this.childCategoryList.add(bxMallSubDto);
     this.childCategoryList.addAll(childCategoryList);
     notifyListeners();
   }

}