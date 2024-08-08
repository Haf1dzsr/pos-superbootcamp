import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos_superbootcamp/data/models/cart_model.dart';

OrderModel orderModelFromJson(String str) =>
    OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  final String? orderId;
  final String? userId;
  final int? priceTotal;
  final int? biayaAdmin;
  final String? paymentMethod;
  final Timestamp? createdAt;
  final String? orderStatus;
  final List<CartModel>? products;

  OrderModel({
    this.orderId,
    this.userId,
    this.priceTotal,
    this.biayaAdmin,
    this.paymentMethod,
    this.createdAt,
    this.orderStatus,
    this.products,
  });

  OrderModel copyWith({
    String? orderId,
    String? userId,
    int? priceTotal,
    int? biayaAdmin,
    String? paymentMethod,
    Timestamp? createdAt,
    String? orderStatus,
    List<CartModel>? products,
  }) =>
      OrderModel(
        orderId: orderId ?? this.orderId,
        userId: userId ?? this.userId,
        priceTotal: priceTotal ?? this.priceTotal,
        biayaAdmin: biayaAdmin ?? this.biayaAdmin,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        createdAt: createdAt ?? this.createdAt,
        orderStatus: orderStatus ?? this.orderStatus,
        products: products ?? this.products,
      );

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        orderId: json["orderId"],
        userId: json["userId"],
        priceTotal: json["priceTotal"],
        biayaAdmin: json["biayaAdmin"],
        paymentMethod: json["paymentMethod"],
        createdAt: json["createdAt"],
        orderStatus: json["orderStatus"],
        products: json["products"] == null
            ? []
            : List<CartModel>.from(
                json["products"]!.map((x) => CartModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "userId": userId,
        "priceTotal": priceTotal,
        "biayaAdmin": biayaAdmin,
        "paymentMethod": paymentMethod,
        "createdAt": createdAt,
        "orderStatus": orderStatus,
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}
