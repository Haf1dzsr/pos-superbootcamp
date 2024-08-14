import 'dart:convert';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  final String? id;
  final String? name;
  final int? price;
  late final int? quantity;
  final int? priceTotal;
  String? imageName;
  String? imageUrl;
  final String? cartId;
  final String? userId;

  CartModel({
    this.id,
    this.name,
    this.price,
    this.quantity,
    this.priceTotal,
    this.imageName,
    this.imageUrl,
    this.cartId,
    this.userId,
  });

  CartModel copyWith({
    String? id,
    String? name,
    int? price,
    int? quantity,
    int? priceTotal,
    String? imageName,
    String? imageUrl,
    String? cartId,
    String? userId,
  }) =>
      CartModel(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        priceTotal: priceTotal ?? this.priceTotal,
        imageName: imageName ?? this.imageName,
        imageUrl: imageUrl ?? this.imageUrl,
        cartId: cartId ?? this.cartId,
        userId: userId ?? this.userId,
      );

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        quantity: json["quantity"],
        priceTotal: json["priceTotal"],
        imageName: json["imageName"],
        imageUrl: json["imageUrl"],
        cartId: json["cartId"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "quantity": quantity,
        "priceTotal": priceTotal,
        "imageName": imageName,
        "imageUrl": imageUrl,
        "cartId": cartId,
        "userId": userId,
      };
}
