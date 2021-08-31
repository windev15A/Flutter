import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:language/models/Message.dart';
import 'package:language/models/product.dart';
import 'package:language/models/product_paginate.dart';

class CallApi {
  final String _url = "http://192.168.1.33:8000/api/server";
  testServer() async {
    http.Response response = await http.get(Uri.parse(_url));

    try {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  List<Product> parseProducts(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Product>((json) => Product.fromJson(json)).toList();
  }

  Future<ProductsData> getProductsData(currentPage) async {
    http.Response response = await http.get(
        Uri.parse("http://192.168.1.33:8000/api/products?page=$currentPage"));
    try {
      if (response.statusCode == 200) {
        return productsDataFromJson(response.body);
      } else {
        print('Erreur ${response.statusCode}');
      }
    } catch (e) {
      print("Erreur serveur $e");
    }
  }

  Future<Message> storeData(Product product) async {
    http.Response response =  await http.post(Uri.parse("http://192.168.1.33:8000/api/products"), headers: {
      'Accept': 'application/json',
    }, body: {
      "name": product.name,
      "slug": product.slug,
      "description": product.description,
      "price": product.price.toString(),
      "image" : product.image
    });
    if(response.statusCode == 200 ){
      print(response.body);
      return messageFromJson(response.body);
    }else{

      print(response.statusCode);
    }
  }

  Future<Message> editData(Product product) async {
    http.Response response =  await http.put(Uri.parse("http://192.168.1.33:8000/api/products/${product.id}"),
        headers: {
          'Accept': 'application/json',
        },
        body: {
          "id": product.id.toString(),
          "name": product.name,
          "slug": product.slug,
          "description": product.description,
          "price": product.price.toString(),
          "image" : product.image
        });
    if(response.statusCode == 200 ){
      return messageFromJson(response.body);
    }else{
      print(response.statusCode);
      return messageFromJson(response.body);
    }
  }

  Future<Message> deleteProduct(int id) async {
    http.Response response = await http.delete(
        Uri.parse("http://192.168.1.33:8000/api/products/$id"));
    try {
      if (response.statusCode == 200) {
        return messageFromJson(response.body);
      } else {
        print('Erreur ${response.statusCode}');
      }
    } catch (e) {
      print("Erreur serveur $e");
    }
  }
}
