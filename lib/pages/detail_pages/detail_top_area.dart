import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../provide/goods_detail_provide.dart';
import '../../model/goods_detail_model.dart';

class DetailTopArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<GoodsDetailProvide>(
      builder:(context,child,goodsDetailProvide){
        var goodsInfo = goodsDetailProvide.goodsDetail.goodInfo;
        if(goodsInfo!=null){
          return Container(
            padding: EdgeInsets.only(left: 5.0,right: 5.0),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                _goodsImg(goodsInfo.image1),
                _goodsName(goodsInfo.goodsName),
                _goodsNum(goodsInfo.goodsSerialNumber),
                _priceRow(goodsInfo.oriPrice,goodsInfo.presentPrice),
              ],
            ),
          );
        }else{
          return Text('正在加载中');
        }
      }
    );
  }
  // 商品图片
  Widget _goodsImg(String url){
    return Image.network(
      url,
      width: ScreenUtil().setWidth(740.0),
    );
  }
  // 商品名称
  Widget _goodsName(String name){
    return Container(
      width: ScreenUtil().setWidth(740.0),
      padding: EdgeInsets.only(left: 5.0,top: 5.0,bottom: 5.0),
      child: Text(
        name,
        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
      ),
    );
  }
  // 商品编号
  Widget _goodsNum(String num){
    return Container(
      width: ScreenUtil().setWidth(740),
      padding: EdgeInsets.only(left: 5.0,top: 5.0,bottom: 5.0),
      child: Text(
          '编号:${num.toString()}',
        style: TextStyle(
            color: Colors.black45
        ),
      ),
    );
  }
  Widget _priceRow(double oriPrice,double presentPrice){
    return Container(
      width: ScreenUtil().setWidth(740.0),
      padding: EdgeInsets.only(left: 5.0,top: 5.0,bottom: 5.0),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 30.0),
//            width: ScreenUtil().setWidth(200.0),
            child: Text(
                "￥${presentPrice}",
              style: TextStyle(
                color: Colors.orange,
                fontSize: ScreenUtil().setSp(36),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            child: Text(
                "市场价："
            ),
          ),
          Container(
            child: Text(
                "￥${oriPrice}",
              style: TextStyle(
                color: Colors.black26,
                decoration: TextDecoration.lineThrough
              ),
            ),
          ),
        ],
      ),
    );
  }

}
