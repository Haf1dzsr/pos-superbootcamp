import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_superbootcamp/data/datasources/product_remote_datasource.dart';
import 'package:pos_superbootcamp/data/models/product_model.dart';

part 'edit_product_state.dart';
part 'edit_product_cubit.freezed.dart';

class EditProductCubit extends Cubit<EditProductState> {
  EditProductCubit() : super(const EditProductState.initial());

  Future<void> updateProduct(
      String id,
      String name,
      String description,
      int price,
      int stock,
      File? image,
      String imageName,
      String imageUrl) async {
    emit(const _Loading());

    final product = ProductModel(
      id: id,
      name: name,
      description: description,
      price: price,
      stock: stock,
      imageName: imageName,
      imageUrl: imageUrl,
    );
    final result =
        await ProductRemoteDatasource.instance.updateProduct(product, image);

    result.fold(
      (l) => emit(_Error(l)),
      (r) => emit(const _Success()),
    );
  }

  Future<void> pickImage() async {
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      emit(_ImagePicked(File(pickedFile.path)));
    } else {
      emit(const _ImageNotPicked());
    }
  }

  Future<void> deleteProduct(ProductModel product) async {
    emit(const _Loading());
    final result =
        await ProductRemoteDatasource.instance.deleteProduct(product);

    result.fold(
      (l) => emit(_Error(l)),
      (r) => emit(const _Deleted()),
    );
  }
}
