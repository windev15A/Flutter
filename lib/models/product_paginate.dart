// To parse this JSON data, do
//
//     final productsData = productsDataFromJson(jsonString);

import 'dart:convert';

import 'package:language/models/product.dart';

ProductsData productsDataFromJson(String str) =>
    ProductsData.fromJson(json.decode(str));

String productsDataToJson(ProductsData data) => json.encode(data.toJson());

class ProductsData {
  ProductsData({
    this.currentPage,
    this.lastPage,
    this.data,
    this.total,
  });
  int currentPage;
  int lastPage;
  List<Product> data;
  int total;

  factory ProductsData.fromJson(Map<String, dynamic> json) => ProductsData(
        currentPage: json["current_page"],
        lastPage: json["last_page"],
        data: List<Product>.from(json["data"].map((x) => Product.fromJson(x))),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "last_page": lastPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "total": total,
      };
}
