import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

            if(naigatorList.length>10){
              naigatorList.removeRange(10,naigatorList.length);
            }
            return Column(
              children: <Widget>[
                SwiperDiy(swiperDataList:swiper),
                TopNavigator(naigatorList:naigatorList),
                AdBanner(adPicture:adPicture),
              ],
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