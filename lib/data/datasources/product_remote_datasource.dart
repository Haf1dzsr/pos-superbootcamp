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

      final productCol = FirebaseFirestore.instance.collection('products');
      final doc = productCol.doc();

      final productToAdd = product.copyWith(
          id: doc.id, imageName: imageName, imageUrl: imageUrl);
      await doc.set(productToAdd.toJson());

      return right(unit);
    } catch (e) {
      return left(e.toString());
    }
  }

  Stream<List<ProductModel>> getProducts() {
    return FirebaseFirestore.instance.collection('products').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromJson(doc.data()))
            .toList());
  }
}
