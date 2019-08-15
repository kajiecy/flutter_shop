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
        });
        List<BxMallSubDto> bxMallSubDto = this.categoryModelList[index].bxMallSubDto;
        Provide.value<ChildCategory>(context).setChildCategoryModel(bxMallSubDto);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 15),
        decoration: BoxDecoration(
            color: this.currentIndex == index ? Color.fromRGBO(236, 236, 236, 1.0) : Colors.white,
            border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
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
        print('执行到这里');
      });
      Provide.value<ChildCategory>(context).setChildCategoryModel(this.categoryModelList[this.currentIndex].bxMallSubDto);
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
                  return _secondCategoryInkWell(childCategory.childCategoryList[index].mallSubName);
                });
            }),
        ),
        Provide<ChildCategory>(
          builder: (builder,child,childCategory){
            return Text(childCategory.childCategoryList.length.toString());
          },
        ),
        CategoryGoodsList(),
      ],
    );
  }

  Widget _secondCategoryInkWell(item){
    return Container(
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            width: 0.5,
            color: Colors.black12
          )
        )
      ),
      child: InkWell(
        onTap: (){},
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
  Widget build(BuildContext context) {
    return Container(
      child: Text('商品列表'),
    );
  }
  void _getGoodsList()async{
    var data = {
      "categoryId":"4",
      "categorySubId":"",
      "page":"1",
    };
    await request('getMallGoods',formData: data).then((result){
      var data = json.decode(result.toString());
      List<MallGoodsModel> mallGoodsModelList = MallGoodsResponse.getMallGoodsModelList(result.toString());
      print('商品列表信息为：${data.toString()}');
    });
  }

  @override
  void initState() {
    this._getGoodsList();
    super.initState();
  }

}
