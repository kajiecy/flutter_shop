import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../provide/goods_detail_provide.dart';

class DetailExplain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10.0),
      width: ScreenUtil().setWidth(740.0),
      padding: EdgeInsets.only(left: 10.0,top: 5.0,bottom: 5.0),
      child: Text(
          '说明：> 急速送达 > 正品保证',
        style: TextStyle(
          color: Colors.pink,
          fontSize: ScreenUtil().setSp(28.0)
        ),

      ),
    );
  }
}
