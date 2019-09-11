import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../provide/goods_detail_provide.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var goodsDetail = Provide.value<GoodsDetailProvide>(context).goodsDetail.goodInfo.goodsDetail;
    return Provide<GoodsDetailProvide>(
      builder: (context,child,goodDetailProvide){
        if(goodDetailProvide.isLeft){
          return  Container(
            child: Html(data: goodsDetail),
          );
        }else{
          return Container(
            padding: EdgeInsets.all(10.0),
            width: ScreenUtil().setWidth(750.0),
            alignment: Alignment.center,
            child: Text('暂无评论'),
          );
        }
      },
    );
  }
}
