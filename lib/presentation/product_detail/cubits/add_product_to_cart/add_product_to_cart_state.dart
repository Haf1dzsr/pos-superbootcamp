part of 'add_product_to_cart_cubit.dart';

@freezed
class AddProductToCartState with _$AddProductToCartState {
  const factory AddProductToCartState.initial() = _Initial;
  const factory AddProductToCartState.loading() = _Loading;
  const factory AddProductToCartState.success() = _Success;
  const factory AddProductToCartState.error(String message) = _Error;
}
