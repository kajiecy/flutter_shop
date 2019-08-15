// To parse this JSON data, do
//
//     final mallGoodsResponse = mallGoodsResponseFromJson(jsonString);

import 'dart:convert';

class MallGoodsResponse {
  String code;
  String message;
  List<MallGoodsModel> data;

  MallGoodsResponse({
    this.code,
    this.message,
    this.data,
  });
  static List<MallGoodsModel> getMallGoodsModelList(String str) => MallGoodsResponse.fromJson(json.decode(str)).data;

  factory MallGoodsResponse.fromRawJson(String str) => MallGoodsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MallGoodsResponse.fromJson(Map<String, dynamic> json) => new MallGoodsResponse(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : new List<MallGoodsModel>.from(json["data"].map((x) => MallGoodsModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "message": message == null ? null : message,
    "data": data == null ? null : new List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class MallGoodsModel {
  String image;
  double oriPrice;
  double presentPrice;
  String goodsName;
  String goodsId;

  MallGoodsModel({
    this.image,
    this.oriPrice,
    this.presentPrice,
    this.goodsName,
    this.goodsId,
  });

  factory MallGoodsModel.fromRawJson(String str) => MallGoodsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MallGoodsModel.fromJson(Map<String, dynamic> json) => new MallGoodsModel(
    image: json["image"] == null ? null : json["image"],
    oriPrice: json["oriPrice"] == null ? null : json["oriPrice"].toDouble(),
    presentPrice: json["presentPrice"] == null ? null : json["presentPrice"].toDouble(),
    goodsName: json["goodsName"] == null ? null : json["goodsName"],
    goodsId: json["goodsId"] == null ? null : json["goodsId"],
  );

  Map<String, dynamic> toJson() => {
    "image": image == null ? null : image,
    "oriPrice": oriPrice == null ? null : oriPrice,
    "presentPrice": presentPrice == null ? null : presentPrice,
    "goodsName": goodsName == null ? null : goodsName,
    "goodsId": goodsId == null ? null : goodsId,
  };
}
