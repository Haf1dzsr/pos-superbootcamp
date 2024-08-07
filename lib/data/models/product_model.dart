// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(
    json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  String? name;
  String? description;
  int? price;
  String? imageName;
  String? imageUrl;

  ProductModel({
    this.name,
    this.description,
    this.price,
    this.imageName,
    this.imageUrl,
  });

  ProductModel copyWith({
    String? name,
    String? description,
    int? price,
    String? imageName,
    String? imageUrl,
  }) =>
      ProductModel(
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price,
        imageName: imageName ?? this.imageName,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        name: json["name"],
        description: json["description"],
        price: json["price"],
        imageName: json["imageName"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "price": price,
        "imageName": imageName,
        "imageUrl": imageUrl,
      };
}

final List<ProductModel> products = [
  ProductModel(
    name: 'Product 1',
    description: 'Description 1',
    price: 10000,
    imageName: 'assets/images/product_1.png',
  ),
  ProductModel(
    name: 'Product 1',
    description: 'Description 1',
    price: 10000,
    imageName: 'assets/images/product_1.png',
  ),
  ProductModel(
    name: 'Product 1',
    description: 'Description 1',
    price: 10000,
    imageName: 'assets/images/product_1.png',
  ),
  ProductModel(
    name: 'Product 1',
    description: 'Description 1',
    price: 10000,
    imageName: 'assets/images/product_1.png',
  ),
];
