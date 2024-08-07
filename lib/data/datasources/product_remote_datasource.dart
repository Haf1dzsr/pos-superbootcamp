import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pos_superbootcamp/data/models/product_model.dart';

class ProductRemoteDatasource {
  static final ProductRemoteDatasource instance =
      ProductRemoteDatasource._internal();
  ProductRemoteDatasource._internal();
  factory ProductRemoteDatasource() => instance;

  Future<Either<String, Unit>> addProduct(
      ProductModel product, File? image) async {
    try {
      String? imageName;
      String? imageUrl;

      if (image != null) {
        imageName = image.path.split('/').last;
        final storageRef =
            FirebaseStorage.instance.ref().child('product_images/$imageName');
        await storageRef.putFile(image);
        imageUrl = await storageRef.getDownloadURL();
      }

      final productToAdd =
          product.copyWith(imageName: imageName, imageUrl: imageUrl);
      await FirebaseFirestore.instance
          .collection('products')
          .add(productToAdd.toJson());
      return right(unit);
    } catch (e) {
      return left(e.toString());
    }
  }
}
