import 'package:flutter/material.dart';
import './../service/service_method.dart';
import './../model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';
import 'dart:convert';
import '../model/mall_goods_model.dart';

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
//  int currentIndex = 0;

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
          Provide.value<ChildCategory>(context).currentIndex = index;
          List<BxMallSubDto> bxMallSubDto = this.categoryModelList[index].bxMallSubDto;
          Provide.value<ChildCategory>(context).setChildCategoryModel(bxMallSubDto);
          RequestUtil.getGoodsList(context).then((result){
            Provide.value<ChildCategory>(context).mallGoodsModelList = MallGoodsResponse.getMallGoodsModelList(result.toString());
            print('商品列表信息为：${Provide.value<ChildCategory>(context).mallGoodsModelList.toString()}');
          });
        });
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 15),
        decoration: BoxDecoration(
            color: Provide.value<ChildCategory>(context).currentIndex == index ? Color.fromRGBO(236, 236, 236, 1.0) : Colors.white,
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
    await request('getCategory').then((val) {
      setState(() {
        categoryModelList = getCategoryModelList(val.toString());
        Provide.value<ChildCategory>(context).setChildCategoryModel(this.categoryModelList[Provide.value<ChildCategory>(context).currentIndex].bxMallSubDto);
        Provide.value<ChildCategory>(context).currentCategoryId = this.categoryModelList[Provide.value<ChildCategory>(context).currentIndex].mallCategoryId;
        RequestUtil.getGoodsList(context).then((result){
          setState(() {
            Provide.value<ChildCategory>(context).mallGoodsModelList = MallGoodsResponse.getMallGoodsModelList(result.toString());
          });
          print('商品列表信息为：${Provide.value<ChildCategory>(context).mallGoodsModelList.toString()}');
        });
        print('执行到这里');
      });
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
        Container(
          height: ScreenUtil().setHeight(80),
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
          child:Provide<ChildCategory>(
            builder:(builder,child,childCategory){
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: childCategory.childCategoryList.length,
                itemBuilder: (context,index){
                  return _secondCategoryInkWell(childCategory.childCategoryList[index].mallSubName,index);
                });
            }),
        ),
        CategoryGoodsList(),
      ],
    );
  }

  Widget _secondCategoryInkWell(item,index){
    return Container(
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      decoration: BoxDecoration(
        color: Provide.value<ChildCategory>(context).secondCurrentIndex==index?Colors.black12:Colors.white,
        border: Border(
          right: BorderSide(
            width: 0.5,
            color: Colors.black12
          )
        )
      ),
      child: InkWell(
        onTap: (){
          setState(() {
            Provide.value<ChildCategory>(context).secondCurrentIndex = index;
          });
        },
        child: Text(
          item,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(28),
          ),
        ),
      ),
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
    this._getGoodsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(980),
      width: ScreenUtil().setWidth(570),
      decoration: BoxDecoration(
      ),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: Provide.value<ChildCategory>(context).mallGoodsModelList.length,
        itemBuilder: (context,index){
          return Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black12,width: 0.5)
              )
            ),
            child: new MallGoodsRow(mallGoodsModelList: Provide.value<ChildCategory>(context).mallGoodsModelList,index: index),
          );
        }
      ),
    );
  }
  void _getGoodsList()async{

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
  static Future getGoodsList(BuildContext context)async{
    return await request('getMallGoods',formData: {
      "categoryId":Provide.value<ChildCategory>(context).currentCategoryId,
      "categorySubId":Provide.value<ChildCategory>(context).childCategoryList[Provide.value<ChildCategory>(context).secondCurrentIndex].mallCategoryId,
      "page":1,
    });
  }
}