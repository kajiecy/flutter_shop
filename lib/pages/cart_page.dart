import 'package:flutter/material.dart';
import '../provide/counter.dart';
import 'package:provide/provide.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[

          ],
        ),
      ),
    );
  }
}





//class Number extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//        margin: EdgeInsets.only(top: 200),
//        child: Provide<Counter>(
//            builder:(builder,child,counter){
//            return Text('${counter.value}',
//            style: Theme.of(context).textTheme.display1,);
//        })
//    );
//  }
//}
//
//class MyButton extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: RaisedButton(
//            onPressed: (){
//              Provide.value<Counter>(context).increment();
//            },
//            child: Text('++'),
//          ),
//    );
//  }
//}

