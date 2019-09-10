import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import './router_handler.dart';

class Routes{
  static String root = '/';
  static String detailPage = '/detail';
  static void configureRoutes(Router router){
    router.notFoundHandler = new Handler(
      handlerFunc:(BuildContext context,Map<String,List<String>> params){
        print('error ===> root was not found！！');
      }
    );
    router.define(detailPage, handler: detailsHandler);

  }
}