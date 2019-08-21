import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import './pages/index_page.dart';
import './provide/counter.dart';
import './provide/child_category.dart';
import './provide/category_goods_list_store.dart';

void main(){
  var counter = Counter();
  var childCategory = ChildCategory();
  var categoryGoodsList = CategoryGoodsListStore();

  // 全局状态管理
  final providers = Providers();
  // 将自类状态注入到provider实例中
  providers
    ..provide(Provider<Counter>.value(counter))
    ..provide(Provider<ChildCategory>.value(childCategory))
    ..provide(Provider<CategoryGoodsListStore>.value(categoryGoodsList));

  runApp(ProviderNode(providers: providers,child: MyApp(),));
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return Container(
      child: MaterialApp(
        title: '百姓生活+',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.pink,
        ),
        home: IndexPage(),
      ),
    );
  }
}