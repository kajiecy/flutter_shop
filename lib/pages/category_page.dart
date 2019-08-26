import 'package:flutter/material.dart';
import './../service/service_method.dart';
import './../model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';
import '../provide/category_goods_list_store.dart';
import 'dart:convert';
import '../model/mall_goods_model.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/phoenix_footer.dart';
//import 'package:flutter_easyrefresh/phoenix_header.dart';
import 'package:flutter_easyrefresh/taurus_header.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品分类'),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            Column(
              children: <Widget>[
                RightCategoryView(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//左侧大类导航
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}
class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List<CategoryModel> categoryModelList = [];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
          border: Border(right: BorderSide(width: 0.5, color: Colors.black12))),
      child: ListView.builder(
        itemCount: categoryModelList.length,
        itemBuilder: (context, index) {
          return _leftInkWell(index);
        },
      ),
    );
  }

  @override
  void initState() {
    _getCategoryList();
    super.initState();
  }

  Widget _leftInkWell(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          this.currentIndex = index;
          Provide.value<ChildCategory>(context).childCategoryList = this.categoryModelList[this.currentIndex].bxMallSubDto;
          print(this.categoryModelList[this.currentIndex].toString());
          () async{
            String goodListStr = await RequestUtil.getGoodsList(categoryId: this.categoryModelList[this.currentIndex].mallCategoryId);
            List<MallGoodsModel> list = MallGoodsResponse.getMallGoodsModelList(goodListStr);
            Provide.value<CategoryGoodsListStore>(context).setMallGoodsModelList(list);

          }();

        });
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 15),
        decoration: BoxDecoration(
            color: this.currentIndex == index ? Color.fromRGBO(236, 236, 236, 1.0) : Colors.white,
            border: Border(bottom: BorderSide(width: 1, color: Colors.black12))
        ),
        child: Text(
          categoryModelList[index].mallCategoryName,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(26),
          ),
        ),
      ),
    );
  }
  void _getCategoryList() async {
    String result = await request('getCategory');
    categoryModelList = getCategoryModelList(result.toString());
    Provide.value<ChildCategory>(context).childCategoryList = this.categoryModelList[this.currentIndex].bxMallSubDto;
    String goodListStr = await RequestUtil.getGoodsList(categoryId: this.categoryModelList[this.currentIndex].mallCategoryId);
    List<MallGoodsModel> list = MallGoodsResponse.getMallGoodsModelList(goodListStr);
    setState(() {
      Provide.value<CategoryGoodsListStore>(context).setMallGoodsModelList(list);
    });
  }
}


//右侧展示界面
class RightCategoryView extends StatefulWidget {
  @override
  _RightCategoryViewState createState() => _RightCategoryViewState();
}
class _RightCategoryViewState extends State<RightCategoryView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
//        Text('111'),
        RightTopWidget(),
        CategoryGoodsList(),
      ],
    );
  }


}
class RightTopWidget extends StatefulWidget {
  @override
  _RightTopWidgetState createState() => _RightTopWidgetState();
}

class _RightTopWidgetState extends State<RightTopWidget> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double _screenHeight = mediaQuery.size.height;
    double _devicePixelRatio = mediaQuery.devicePixelRatio;
    print('_screenHeight--------->${_screenHeight.toString()}');
    print('_devicePixelRatio--------->${_devicePixelRatio.toString()}');
    print('----------');

    print('ScreenUtil.screenHeight =========>${ScreenUtil.screenHeight}');
    print('ScreenUtil.instance.height======>${ScreenUtil.instance.height}');
    print('ScreenUtil.screenHeightDp=====>${ScreenUtil.screenHeightDp}');
    print('ScreenUtil().setHeight(100)========>${ScreenUtil().setHeight(100)}');
    print('======================================');

    return Container(
      height: ScreenUtil().setHeight(100),
      width: ScreenUtil().setWidth(570),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                color: Colors.black12,
                width: 0.5,
              )
          )
      ),
      child:
//      Text('111111111111111'),
      Provide<ChildCategory>(
          builder:(builder,child,childCategory){
            return
              ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: childCategory.childCategoryList.length,
                  itemBuilder: (context,index){
                    return _secondCategoryInkWell(childCategory.childCategoryList[index],index);
                  });
          }),
    );
  }
  Widget _secondCategoryInkWell(BxMallSubDto item,index){
    return Provide<ChildCategory>(
      builder:(builder,child,childCategory){
        return  Container(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          decoration: BoxDecoration(
              color: childCategory.secondCurrentIndex==index?Colors.black12:Colors.white,
              border: Border(
                  right: BorderSide(
                      width: 0.5,
                      color: Colors.black12
                  )
              )
          ),
          child: InkWell(
            onTap: (){
              setState((){
                childCategory.secondCurrentIndex = index;
                    () async{
                  String goodListStr = await RequestUtil.getGoodsList(categoryId: item.mallCategoryId,categorySubId: item.mallSubId);
                  MallGoodsResponse.getMallGoodsModelList(goodListStr);
                  List<MallGoodsModel> list = MallGoodsResponse.getMallGoodsModelList(goodListStr);
                  Provide.value<CategoryGoodsListStore>(context).setMallGoodsModelList(list);
                }();
              });
            },
            child: Text(
              item.mallSubName,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(28),
              ),
            ),
          ),
        );
      },
    );
  }

}


// 商品列表 可以上拉加载效果
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}
class _CategoryGoodsListState extends State<CategoryGoodsList> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      Provide<CategoryGoodsListStore>(
          builder:(builder,child,categoryGoodsListStore){
            return Container(
              height: ScreenUtil().setHeight(980),
              width: ScreenUtil().setWidth(570),
              decoration: BoxDecoration(
              ),
              child:
//              ListView.builder(
//                  scrollDirection: Axis.vertical,
//                  itemCount: categoryGoodsListStore.mallGoodsModelList.length,
//                  itemBuilder: (context,index){
//                    return Container(
//                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
//                      decoration: BoxDecoration(
//                          border: Border(
//                              bottom: BorderSide(color: Colors.black12,width: 0.5)
//                          )
//                      ),
//                      child: new MallGoodsRow(mallGoodsModelList: categoryGoodsListStore.mallGoodsModelList,index: index),
//                    );
//                  }
//              ),
            EasyRefresh(
              child:ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: categoryGoodsListStore.mallGoodsModelList.length,
                  itemBuilder: (context,index){
                    return Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.black12,width: 0.5)
                          )
                      ),
                      child: new MallGoodsRow(mallGoodsModelList: categoryGoodsListStore.mallGoodsModelList,index: index),
                    );
                  }
              ),
              onRefresh:() async {
                print('触发onRefresh');
                this._getGoodsListByPage(currentPage: 0);
              },
              onLoad: () async {
                if(Provide.value<ChildCategory>(context).currentPage!=-1){
                  print('触发onLoad');
                  this._getGoodsListByPage(currentPage: Provide.value<ChildCategory>(context).currentPage+1);
                }
              },
              header: TaurusHeader(),
              footer: PhoenixFooter(),
            ),

            );
          });

  }
  // 执行上拉加载 下拉刷新时调用的方法
  void _getGoodsListByPage({int currentPage}) async{
    print('执行上拉加载 下拉刷新时调用的方法');
    BxMallSubDto currentBxMallSubDtoInfo = Provide.value<ChildCategory>(context).getCurrentBxMallSubDtoInfo();
    String goodListStr = await RequestUtil.getGoodsList(categoryId: currentBxMallSubDtoInfo.mallCategoryId,categorySubId: currentBxMallSubDtoInfo.mallSubId,page: currentPage);
    MallGoodsResponse.getMallGoodsModelList(goodListStr);
    List<MallGoodsModel> list = MallGoodsResponse.getMallGoodsModelList(goodListStr);
    if(list!=null){
      if(currentPage==1){
        Provide.value<CategoryGoodsListStore>(context).setMallGoodsModelList(list);
      }else{
        Provide.value<CategoryGoodsListStore>(context).addMallGoodsModelList(list);
      }
      Provide.value<ChildCategory>(context).currentPage = currentPage;
    }else{
      Provide.value<ChildCategory>(context).currentPage = -1;
    }
  }
}
// 真是每一行的售卖商品信息
class MallGoodsRow extends StatelessWidget {
  const MallGoodsRow({
    Key key,
    @required this.mallGoodsModelList,
    @required this.index,
  }) : super(key: key);

  final List<MallGoodsModel> mallGoodsModelList;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Image.network(
          mallGoodsModelList[index].image,
          width: ScreenUtil().setWidth(200),
          height: ScreenUtil().setHeight(200),
        ),
        rightContent()
      ],
    );
  }

  Container rightContent() {
    return Container(
        width: ScreenUtil().setWidth(370),
        decoration: BoxDecoration(
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              mallGoodsModelList[index].goodsName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(28)
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 13.0),
              child: Row(
                textBaseline: TextBaseline.alphabetic,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 5.0),
                    child: Text(
                      '价格：'+mallGoodsModelList[index].presentPrice.toString(),
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(26),
                        color: Colors.pink
                      ),
                    ),
                  ),
                  Text(
                    mallGoodsModelList[index].oriPrice.toString(),
                    style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                      fontSize: ScreenUtil().setSp(22)
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
  }
}

class RequestUtil{
  static Future getGoodsList({String categoryId,String categorySubId,int page})async{
    return await request('getMallGoods',formData: {
      "categoryId":categoryId==null?'4':categoryId,
      "categorySubId":categorySubId==null?'':categorySubId,
      "page":page==null?1:page,
    });
  }
}