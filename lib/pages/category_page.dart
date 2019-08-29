import 'package:flutter/material.dart';
import './../service/service_method.dart';
import './../model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';
import '../provide/category_goods_list_store.dart';
import '../model/mall_goods_model.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/phoenix_footer.dart';
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
            // 左侧一级分类
            LeftCategoryNav(),
            // 右侧分类及列表视图区
            Column(
              children: <Widget>[
                RightTopWidget(),
                CategoryGoodsList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 左侧
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
    print('1111');
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
          Provide.value<ChildCategory>(context).currentPage = 1;
          _getGoodsList(categoryId:this.categoryModelList[this.currentIndex].mallCategoryId,page: Provide.value<ChildCategory>(context).currentPage);
        });
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 15),
        decoration: BoxDecoration(
            color: this.currentIndex == index
                ? Color.fromRGBO(236, 236, 236, 1.0)
                : Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
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
    Provide.value<ChildCategory>(context).childCategoryList =
        this.categoryModelList[this.currentIndex].bxMallSubDto;
    Provide.value<ChildCategory>(context).currentPage = 1;
    String goodListStr = await RequestUtil.getGoodsList(categoryId: this.categoryModelList[this.currentIndex].mallCategoryId);
    List<MallGoodsModel> list = MallGoodsResponse.getMallGoodsModelList(goodListStr);
    setState(() {
      Provide.value<CategoryGoodsListStore>(context).setMallGoodsModelList(list);
    });
  }

  void _getGoodsList({String categoryId, String categorySubId = '', int page}) async{
    String goodListStr = await request('getMallGoods', formData: {"categoryId": categoryId,"categorySubId": categorySubId,"page": page,});
    List<MallGoodsModel> list = MallGoodsResponse.getMallGoodsModelList(goodListStr);
    Provide.value<CategoryGoodsListStore>(context).setMallGoodsModelList(list);
  }
}


//右侧的二级菜单
class RightTopWidget extends StatefulWidget {
  @override
  _RightTopWidgetState createState() => _RightTopWidgetState();
}

class _RightTopWidgetState extends State<RightTopWidget> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Provide<ChildCategory>(builder: (builder, child, childCategory) {
      return Container(
          height: ScreenUtil().setHeight(80),
          width: ScreenUtil().setWidth(570),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(
                color: Colors.black12,
                width: 0.5,
              ))),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: childCategory.childCategoryList.length,
              itemBuilder: (context, index) {
                return _secondCategoryInkWell(
                    childCategory.childCategoryList[index], index);
              }));
    });
  }

//  二级菜单每个点击的框框
  Widget _secondCategoryInkWell(BxMallSubDto item, index) {
    return Provide<ChildCategory>(
      builder: (builder, child, childCategory) {
        return Container(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          decoration: BoxDecoration(
              color: childCategory.secondCurrentIndex == index
                  ? Colors.black12
                  : Colors.white,
              border:
                  Border(right: BorderSide(width: 0.5, color: Colors.black12))),
          child: InkWell(
            onTap: () {
              setState(() {
                childCategory.secondCurrentIndex = index;
                () async {
                  Provide.value<ChildCategory>(context).currentPage = 1;
                  List<MallGoodsModel> list = await _getGoodsList(
                      categoryId: item.mallCategoryId,
                      categorySubId: item.mallSubId,
                      page: 1,
                  );
                  if (list != null) {
                    Provide.value<CategoryGoodsListStore>(context)
                        .setMallGoodsModelList(list);
                  } else {
                    Provide.value<CategoryGoodsListStore>(context)
                        .setMallGoodsModelList([]);
                  }
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
  Future<List<MallGoodsModel>> _getGoodsList({String categoryId, String categorySubId = '', int page}) async{
    String goodListStr = await request('getMallGoods', formData: {"categoryId": categoryId,"categorySubId": categorySubId,"page": page,});
    return MallGoodsResponse.getMallGoodsModelList(goodListStr);
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
    print('商品列表build触发' );
    return Provide<CategoryGoodsListStore>(
        builder: (builder, child, categoryGoodsListStore) {
      if (categoryGoodsListStore.mallGoodsModelList.length == 0) {
        return Text('暂无数据');
      } else {
        return Expanded(
          child: Container(
            width: ScreenUtil().setWidth(570),
            decoration: BoxDecoration(),
            child: EasyRefresh(
              child: ListView.builder(
//                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  itemCount: categoryGoodsListStore.mallGoodsModelList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.black12, width: 0.5)
                          )
                      ),
                      // 渲染每一行的内容 包括左侧图片 和 右侧文字
                      child: mallGoodsRow(mallGoodsModelList:categoryGoodsListStore.mallGoodsModelList,index: index),
                    );
                  }),
              onRefresh: () async {
                this._getGoodsListByPage(currentPage: 1);
              },
              onLoad: () async {
                if (Provide.value<ChildCategory>(context).currentPage != -1) {
                  this._getGoodsListByPage(currentPage:Provide.value<ChildCategory>(context).currentPage +1);
                }
              },
              header: TaurusHeader(),
              footer: PhoenixFooter(),
            ),
          ),
        );
      }
    });
  }

  Widget mallGoodsRow({List<MallGoodsModel> mallGoodsModelList, int index}) {
    return Row(
      children: <Widget>[
        Image.network(
          mallGoodsModelList[index].image,
          width: ScreenUtil().setWidth(200),
          height: ScreenUtil().setHeight(200),
        ),
        rightContent(mallGoodsModelList: mallGoodsModelList, index: index)
      ],
    );
  }

  // 右侧文本
  Container rightContent({List<MallGoodsModel> mallGoodsModelList, int index}) {
    return Container(
      width: ScreenUtil().setWidth(370),
      decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            mallGoodsModelList[index].goodsName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: ScreenUtil().setSp(28)),
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
                    '价格：' + mallGoodsModelList[index].presentPrice.toString(),
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(26), color: Colors.pink),
                  ),
                ),
                Text(
                  mallGoodsModelList[index].oriPrice.toString(),
                  style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                      fontSize: ScreenUtil().setSp(22)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 执行上拉加载 下拉刷新时调用的方法
  void _getGoodsListByPage({int currentPage}) async {
    BxMallSubDto currentBxMallSubDtoInfo =
        Provide.value<ChildCategory>(context).getCurrentBxMallSubDtoInfo();
    String goodListStr = await RequestUtil.getGoodsList(
        categoryId: currentBxMallSubDtoInfo.mallCategoryId,
        categorySubId: currentBxMallSubDtoInfo.mallSubId,
        page: currentPage);
    MallGoodsResponse.getMallGoodsModelList(goodListStr);
    List<MallGoodsModel> list =
        MallGoodsResponse.getMallGoodsModelList(goodListStr);
    if (list != null) {
      if (currentPage == 1) {
        Provide.value<CategoryGoodsListStore>(context)
            .setMallGoodsModelList(list);
      } else {
        Provide.value<CategoryGoodsListStore>(context)
            .addMallGoodsModelList(list);
      }
      Provide.value<ChildCategory>(context).currentPage = currentPage;
    } else {
      Provide.value<ChildCategory>(context).currentPage = -1;
    }
  }
}

class RequestUtil {
  static Future getGoodsList(
      {String categoryId, String categorySubId, int page}) async {
    return await request('getMallGoods', formData: {
      "categoryId": categoryId == null ? '4' : categoryId,
      "categorySubId": categorySubId == null ? '' : categorySubId,
      "page": page == null ? 1 : page,
    });
  }
}
