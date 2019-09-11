import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/goods_detail_provide.dart';
import './detail_pages/detail_top_area.dart';
import './detail_pages/detail_explain.dart';
import './detail_pages/detail_tabbar.dart';
import './detail_pages/detail_web.dart';
import './detail_pages/detail_bottom.dart';

class DetailsPage extends StatelessWidget {
  final String goodsId;
  DetailsPage(this.goodsId);
  @override
  Widget build(BuildContext context) {
    this.getGoodsDetailInfo(context);
    return Scaffold(
      appBar: AppBar(
        // 左侧返回图标
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            },
        ),
        title: Text('商品详情页面'),
      ),
      body:FutureBuilder(
          future: getGoodsDetailInfo(context),
          builder: (context,snapshot){
            if(snapshot.hasData){
              return
                Stack(
                  children: <Widget>[
                    Container(
                      child: ListView(
                        children: <Widget>[
                          DetailTopArea(),
                          DetailExplain(),
                          DetailTabbar(),
                          DetailWeb(),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                        left: 0.0,
                        child: DetailBottom(),

                    )
                  ],
                );
            }else{
              return Text('加载中...');
            }
          }
      ),
    );
  }
  Future<String> getGoodsDetailInfo(BuildContext context) async {
    await Provide.value<GoodsDetailProvide>(context).getGoodsDetailInfo(goodsId);
    return '加载完成';
  }
}

//class DetailsPage extends StatefulWidget {
//  final String goodsId;
//  DetailsPage(this.goodsId);
//  @override
//  _DetailsPageState createState() => _DetailsPageState(this.goodsId);
//}
//
//class _DetailsPageState extends State<DetailsPage> {
//  final String goodsId;
//  _DetailsPageState(this.goodsId);
//  @override
//  Widget build(BuildContext context) {
//    this.getGoodsDetailInfo();
//    return Container(child: Text(this.goodsId),);
//  }
//

//}

