import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../provide/goods_detail_provide.dart';
class DetailTabbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<GoodsDetailProvide>(
        builder:(context,child,goodsDetailProvide){
          bool isLeft = goodsDetailProvide.isLeft;
          bool isRight = goodsDetailProvide.isRight;
            return Container(
              margin: EdgeInsets.only(top: 10.0),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  _myTabbarLeft(context, isLeft),
                  _myTabbarRight(context, isRight)
                ],
              ),
            );
        }
    );
  }
  Widget _myTabbarLeft(BuildContext context,bool isLeft){
    return InkWell(
      onTap: (){
        Provide.value<GoodsDetailProvide>(context).changeLeftAndRight('left');
      },
      child: Container(
        padding:EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                  color: isLeft?Colors.pink:Colors.black12,
                  width: 1.0,
                )
            )
        ),
        child: Text(
          '详情',
          style: TextStyle(
            color: isLeft?Colors.pink:Colors.black12,
          ),
        ),
      ),
    );
  }

  Widget _myTabbarRight(BuildContext context,bool isRight){
    return InkWell(
      onTap: (){
        Provide.value<GoodsDetailProvide>(context).changeLeftAndRight('right');
      },
      child: Container(
        padding:EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                  color: isRight?Colors.pink:Colors.black12,
                  width: 1.0,
                )
            )
        ),
        child: Text(
          '评论',
          style: TextStyle(
            color: isRight?Colors.pink:Colors.black12,
          ),
        ),
      ),
    );
  }
}
