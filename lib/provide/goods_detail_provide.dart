import 'package:flutter/material.dart';
import '../model/goods_detail_model.dart';
import '../service/service_method.dart';

class GoodsDetailProvide with ChangeNotifier{
    GoodsDetail goodsDetail;
    // 从后台获取商品详情
    Future getGoodsDetailInfo(String goodsId) async {
      String result = await request('getGoodDetailById',formData: {'goodId':goodsId});
      goodsDetail = getGoodsDetail(result);
//      print('request end===');
      notifyListeners();
    }

}