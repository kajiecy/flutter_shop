import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String homePageContext = '正在获取数据';
  @override
  void initState() {
    getHomePageContent().then((val){
      setState(() {
       homePageContext = val.toString(); 
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('百姓生活+'),
      ),
      body: FutureBuilder(
        future: getHomePageContent(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            var data = json.decode(snapshot.data.toString());
            List<Map> swiper = (data['data']['slides'] as List).cast();
            List<Map> naigatorList = (data['data']['category'] as List).cast();
            String adPicture = (data['data']['advertesPicture']['PICTURE_ADDRESS'] as String);
            String leaderImage = (data['data']['shopInfo']['leaderImage'] as String);
            String leaderPhone = (data['data']['shopInfo']['leaderPhone'] as String);
            List<Map> recommendList = (data['data']['recommend'] as List).cast();
            recommendList.insert(recommendList.length, recommendList[0]);
            if(naigatorList.length>10){
              naigatorList.removeRange(10,naigatorList.length);
            }
            return 
            SingleChildScrollView(
              child: Column(
              children: <Widget>[
                SwiperDiy(swiperDataList:swiper),
                TopNavigator(naigatorList:naigatorList),
                AdBanner(adPicture:adPicture),
                LeaderPhoneView(leaderImage:leaderImage,leaderPhone:leaderPhone),
                Recommend(recommendList:recommendList),
              ],
            ),
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
