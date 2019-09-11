import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../provide/goods_detail_provide.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var goodsDetail = Provide.value<GoodsDetailProvide>(context).goodsDetail.goodInfo.goodsDetail;
    return Container(
      child: Html(data: goodsDetail),
    );
  }
}
