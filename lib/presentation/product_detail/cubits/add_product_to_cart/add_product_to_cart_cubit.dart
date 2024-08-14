import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pos_superbootcamp/data/datasources/product_remote_datasource.dart';
import 'package:pos_superbootcamp/data/models/product_model.dart';

part 'add_product_to_cart_state.dart';
part 'add_product_to_cart_cubit.freezed.dart';

class AddProductToCartCubit extends Cubit<AddProductToCartState> {
  AddProductToCartCubit() : super(const AddProductToCartState.initial());

  Future<void> addProductToCart({
    required String userId,
    required ProductModel product,
    required int quantity,
  }) async {
    emit(const AddProductToCartState.loading());
    final result = await ProductRemoteDatasource.instance.addProductToCart(
      userId: userId,
      product: product,
      quantity: quantity,
    );
    result.fold(
      (l) => emit(_Error(l)),
      (r) => emit(const _Success()),
    );
  }
}
