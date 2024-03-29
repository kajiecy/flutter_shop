import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/goods_detail_provide.dart';
import '../../provide/car_provide.dart';


class DetailBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var goodsInfo = Provide.value<GoodsDetailProvide>(context).goodsDetail.goodInfo;


    return Container(
      width: ScreenUtil().setWidth(750.0),
      color: Colors.white,
      height: ScreenUtil().setHeight(80.0),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: (){},
            child: Container(
              width: ScreenUtil().setWidth(110.0),
              height: ScreenUtil().setHeight(80.0),
              alignment: Alignment.center,
              child: Icon(
                Icons.shopping_cart,
                size: ScreenUtil().setSp(45),
                color: Colors.red,
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              await Provide.value<CarProvide>(context).save(goodsInfo.goodsId, goodsInfo.goodsName, 1, goodsInfo.presentPrice, goodsInfo.image1);
            },
            child: Container(
              width: ScreenUtil().setWidth(320),
              height: ScreenUtil().setHeight(80.0),
              alignment: Alignment.center,
              color: Colors.green,
              child: Text(
                  '加入购物车',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(28)
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              await Provide.value<CarProvide>(context).removeCarInfo();
            },
            child: Container(
              width: ScreenUtil().setWidth(320),
              height: ScreenUtil().setHeight(80.0),
              alignment: Alignment.center,
              color: Colors.red,
              child: Text(
                '立即购买',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(28)
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}
