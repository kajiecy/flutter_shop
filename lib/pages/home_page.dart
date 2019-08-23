import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/phoenix_footer.dart';
import './../model/category.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  int page = 1;
  List<Map> hotGoodsList = [];


  @override
  bool get wantKeepAlive {

    return true;
  }

  @override
  void initState() {
    super.initState();
    _getHotGoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('百姓生活+'),
      ),
      body: FutureBuilder(
        future: request('homePageContext', formData:{'lon':'115.02932','lat':'35.76189'}),
        builder: (context,snapshot){
          if(snapshot.hasData){
            var data = json.decode(snapshot.data.toString());
            List<Map> swiper = (data['data']['slides'] as List).cast();
            List<Map> naigatorList = (data['data']['category'] as List).cast();
            String adPicture = (data['data']['advertesPicture']['PICTURE_ADDRESS'] as String);
            String leaderImage = (data['data']['shopInfo']['leaderImage'] as String);
            String leaderPhone = (data['data']['shopInfo']['leaderPhone'] as String);
            List<Map> recommendList = (data['data']['recommend'] as List).cast();

            String pictureAddress1 = (data['data']['floor1Pic']['PICTURE_ADDRESS'] as String);
            List<Map> floorGoodList1 = (data['data']['floor1'] as List).cast();
            String pictureAddress2 = (data['data']['floor2Pic']['PICTURE_ADDRESS'] as String);
            List<Map> floorGoodList2 = (data['data']['floor2'] as List).cast();
            String pictureAddress3 = (data['data']['floor3Pic']['PICTURE_ADDRESS'] as String);
            List<Map> floorGoodList3 = (data['data']['floor3'] as List).cast();

            recommendList.insert(recommendList.length, recommendList[0]);
            if(naigatorList.length>10){
              naigatorList.removeRange(10,naigatorList.length);
            }


            return
            EasyRefresh(
                child:ListView(
                  children: <Widget>[
                    SwiperDiy(swiperDataList:swiper),
                    TopNavigator(naigatorList:naigatorList),
                    AdBanner(adPicture:adPicture),
                    LeaderPhoneView(leaderImage:leaderImage,leaderPhone:leaderPhone),
                    Recommend(recommendList:recommendList),
                    FloorTitle(pictureAddress:pictureAddress1),
                    FloorContent(floorGoodList:floorGoodList1),
                    FloorTitle(pictureAddress:pictureAddress2),
                    FloorContent(floorGoodList:floorGoodList2),
                    FloorTitle(pictureAddress:pictureAddress3),
                    FloorContent(floorGoodList:floorGoodList3),
                    _hotGoods(),
                  ],
                ),
              topBouncing:false,
              onLoad: () async {
                print('触发onLoad');
                _getHotGoods(isNext: true);
              },
              footer: PhoenixFooter(),
            );
          }else{
            return Center(
              child: Text('没有数据'),
            );
          }
        },
      ),
    );
  }
  void _getHotGoods({isNext}){
    var formData = {'page':page};
    request('homePageBelowConten',formData:formData).then((val){
      var data = json.decode(val.toString());
      List<Map> newGoodsList = [];
      if(isNext!=true){
        newGoodsList = (data["data"] as List).cast();
      }else{
        newGoodsList.addAll((data["data"] as List).cast());
      }
      setState(() {
        hotGoodsList.addAll(newGoodsList);
        page++;
      });
    });
  }

  Widget hotTitle = Container(
    child: Text("火爆专区"),
    margin: EdgeInsets.only(top: 10.0,bottom: 10.0),
    alignment: Alignment.center,
    color: Colors.transparent,
  );

  Widget _wrapList(){
    if(hotGoodsList.length>0){
      List<Widget> listWidget = hotGoodsList.map((val){
        return InkWell(
          onTap: (){},
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(val["image"],width: ScreenUtil().setWidth(370),),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: ScreenUtil().setSp(26),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text("￥${val['mallPrice']}"),
                    Text(
                        "￥${val['price']}",
                      style: TextStyle(
                        color: Colors.black26,
                        decoration: TextDecoration.lineThrough
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();
      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    }else{
      return Text("空");
    }
  }

  Widget _hotGoods(){
    return Container(
      child: Column(
        children: [
          hotTitle,
          _wrapList(),
        ],
      ),
    );
  }

}

// 首页轮播
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;
  const SwiperDiy({Key key,this.swiperDataList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // print('设备的像素密度${ScreenUtil.pixelRatio}');
    // print('设备的高${ScreenUtil.screenHeight}');
    // print('设备的宽${ScreenUtil.screenWidth}');
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context,int index){
          return Image.network("${swiperDataList[index]['image']}",fit: BoxFit.fill,);
        },
        itemCount: swiperDataList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}
// 分类列表
class TopNavigator extends StatelessWidget {
  final List naigatorList;
  const TopNavigator({Key key,this.naigatorList}) : super(key: key);
  Widget _gridViewItemUI(BuildContext context,item){
    return InkWell(
      onTap: (){print('点击了导航');},
      child: Column(
        children: <Widget>[
          Image.network(item['image'],width: ScreenUtil().setWidth(95),),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(346),
      padding: EdgeInsets.fromLTRB(0,3.0,0,3.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: naigatorList.map((item){return _gridViewItemUI(context,item);}).toList(),
      ),
    );
  }
}
// 广告banner
class AdBanner extends StatelessWidget {
  final String adPicture;
  const AdBanner({Key key,this.adPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}
// 联系店长
class LeaderPhoneView extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;
  const LeaderPhoneView({Key key,this.leaderImage,this.leaderPhone}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child: Image.network(leaderImage),
      ),
    );
  }
  void _launchURL() async{
    String url = 'tel:'+leaderPhone;
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw "URL不能进行访问${url}";
    }
  }
}
// 商品推荐
class Recommend extends StatelessWidget {
  final List recommendList;
  const Recommend({Key key,this.recommendList}) : super(key: key);

  // 标题widget
  Widget _titleWidget(){
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 0.5,color: Colors.black12),
        )
      ),
      child: Text(
        '商品推荐',
        style: TextStyle(
          color: Colors.pink
        ),
      ),
    );
  }
  // 商品items
  Widget _item(index){
    return InkWell(
      onTap: (){

      },
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(
              width: 0.5,
              color: Colors.black12,
            )
          ),
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text("￥${recommendList[index]['mallPrice']}"),
            Text(
              "￥${recommendList[index]['price']}",
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 横向列表
  Widget _recommendList(){
    return Container(
      height: ScreenUtil().setHeight(349),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
          itemCount: recommendList.length,
          itemBuilder: (context,index){
            return _item(index);
          },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      height: ScreenUtil().setHeight(410),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList(),
        ],
      ),
    );
  }
}
// 楼层标题
class FloorTitle extends StatelessWidget {
  final String pictureAddress;
  const FloorTitle({Key key,this.pictureAddress}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
      child: Image.network(pictureAddress),
    );
  }
}
// 楼层楼层商品
class FloorContent extends StatelessWidget {
  final List floorGoodList;
  const FloorContent ({Key key,this.floorGoodList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _firstRow(),
          _otherGoods(),
        ],
      ),
    );
  }
  Widget _firstRow(){
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodList[0]),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodList[1]),
            _goodsItem(floorGoodList[2]),
          ],
        )
      ],
    );
  }
  Widget _otherGoods(){
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodList[3]),
        _goodsItem(floorGoodList[4]),
      ],
    );
  }

  Widget _goodsItem(Map goods){
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: (){

        },
        child: Image.network(goods['image']),
      ),
    );
  }
}


