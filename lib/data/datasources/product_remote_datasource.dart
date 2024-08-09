import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pos_superbootcamp/data/models/cart_model.dart';
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
        imageName =
            '${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
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

  Future<Either<String, Unit>> updateProduct(
      ProductModel product, File? newImage) async {
    log("product image name: ${product.imageName}");
    try {
      String? newImageName;
      String? newImageUrl;

      if (newImage != null) {
        if (product.imageName != null) {
          final oldImageRef = FirebaseStorage.instance
              .ref()
              .child('product_images/${product.imageName}');
          await oldImageRef.delete();
        }
        newImageName =
            '${DateTime.now().millisecondsSinceEpoch}_${newImage.path.split('/').last}';
        final newImageRef = FirebaseStorage.instance
            .ref()
            .child('product_images/$newImageName');
        await newImageRef.putFile(newImage);
        newImageUrl = await newImageRef.getDownloadURL();
      }

      final productCol = FirebaseFirestore.instance.collection('products');
      final doc = productCol.doc(product.id);

      final productToUpdate = product.copyWith(
        imageName: newImage != null ? newImageName : product.imageName,
        imageUrl: newImage != null ? newImageUrl : product.imageUrl,
      );

      log({productToUpdate.toJson()}.toString());

      await doc.update(productToUpdate.toJson());

      return right(unit);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<void> updateProductQuantity(
      {required String productId, required int quantity}) async {
    final doc =
        FirebaseFirestore.instance.collection('products').doc(productId);

    await doc.update(
      {
        'stock': quantity,
      },
    );
  }

  Future<Either<String, Unit>> deleteProduct(ProductModel product) async {
    try {
      if (product.imageName != null) {
        final imageRef = FirebaseStorage.instance
            .ref()
            .child('product_images/${product.imageName}');
        await imageRef.delete();
      }

      final productCol = FirebaseFirestore.instance.collection('products');
      final doc = productCol.doc(product.id);

      await doc.delete();

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

  Stream<List<CartModel>> getAllCartItemsByUserId({required String uid}) {
    final cartItems = FirebaseFirestore.instance
        .collection('carts')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CartModel.fromJson(doc.data()))
            .toList());
    return cartItems;
  }

  Future<Either<String, Unit>> addProductToCart({
    required String userId,
    required ProductModel product,
    required int quantity,
  }) async {
    final cartCol = FirebaseFirestore.instance.collection('carts');
    try {
      final querySnapshot = await cartCol
          .where('userId', isEqualTo: userId)
          .where('id', isEqualTo: product.id)
          .get();

      if (querySnapshot.docs.isEmpty) {
        final cartDoc = cartCol.doc();
        final cartToAdd = CartModel(
          id: product.id,
          name: product.name,
          price: product.price,
          quantity: quantity,
          priceTotal: product.price! * quantity,
          imageName: product.imageName,
          imageUrl: product.imageUrl,
          cartId: cartDoc.id,
          userId: userId,
        );
        await cartDoc.set(cartToAdd.toJson());
      } else {
        final doc = querySnapshot.docs.first;
        final currentQuantity = doc['quantity'] as int;
        await doc.reference.update(
          {
            'quantity': currentQuantity + quantity,
            'priceTotal': product.price! * (currentQuantity + quantity),
          },
        );
      }
      return right(unit);
    } on FirebaseException catch (e) {
      return left(e.message!);
    }
  }

  Future<void> updateCartItemQuantity(
      {required CartModel cart, required int value}) async {
    final doc = FirebaseFirestore.instance.collection('carts').doc(cart.cartId);

    await doc.update(
      {
        'quantity': value,
        'priceTotal': (value * cart.price!),
      },
    );
  }

  Future<void> deleteItemfromCart({required CartModel cart}) async {
    final doc = FirebaseFirestore.instance.collection('carts').doc(cart.cartId);
    await doc.delete();
  }
}
