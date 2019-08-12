// To parse this JSON data, do
//     final CategoryResponse = CategoryResponseFromJson(jsonString);

import 'dart:convert';
List<CategoryModel> getCategoryModelList(String str) => categoryResponseFromJson(str).data;
CategoryResponse categoryResponseFromJson(String str) => CategoryResponse.fromJson(json.decode(str));
String categoryResponseToJson(CategoryResponse data) => json.encode(data.toJson());

class CategoryResponse {
  String code;
  String message;
  List<CategoryModel> data;

  CategoryResponse({
    this.code,
    this.message,
    this.data,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) => new CategoryResponse(
    code: json["code"],
    message: json["message"],
    data: new List<CategoryModel>.from(
        json["data"].map((x) =>
            CategoryModel.fromJson(x)
        )
    ),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": new List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CategoryModel {
  String mallCategoryId;
  String mallCategoryName;
  List<BxMallSubDto> bxMallSubDto;
  dynamic comments;
  String image;

  CategoryModel({
    this.mallCategoryId,
    this.mallCategoryName,
    this.bxMallSubDto,
    this.comments,
    this.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => new CategoryModel(
    mallCategoryId: json["mallCategoryId"],
    mallCategoryName: json["mallCategoryName"],
    bxMallSubDto: new List<BxMallSubDto>.from(json["bxMallSubDto"].map((x) => BxMallSubDto.fromJson(x))),
    comments: json["comments"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "mallCategoryId": mallCategoryId,
    "mallCategoryName": mallCategoryName,
    "bxMallSubDto": new List<dynamic>.from(bxMallSubDto.map((x) => x.toJson())),
    "comments": comments,
    "image": image,
  };
}

class BxMallSubDto {
  String mallSubId;
  String mallCategoryId;
  String mallSubName;
  String comments;

  BxMallSubDto({
    this.mallSubId,
    this.mallCategoryId,
    this.mallSubName,
    this.comments,
  });

  factory BxMallSubDto.fromJson(Map<String, dynamic> json) => new BxMallSubDto(
    mallSubId: json["mallSubId"],
    mallCategoryId: json["mallCategoryId"],
    mallSubName: json["mallSubName"],
    comments: json["comments"] == null ? null : json["comments"],
  );

  Map<String, dynamic> toJson() => {
    "mallSubId": mallSubId,
    "mallCategoryId": mallCategoryId,
    "mallSubName": mallSubName,
    "comments": comments == null ? null : comments,
  };
}
