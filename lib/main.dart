import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import './pages/index_page.dart';
import './provide/counter.dart';

void main(){
  var counter = Counter();
  final providers = Providers();
  providers..provide(Provider<Counter>.value(counter));
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