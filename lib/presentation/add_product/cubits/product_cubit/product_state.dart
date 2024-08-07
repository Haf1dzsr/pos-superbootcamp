part of 'product_cubit.dart';

@freezed
class ProductState with _$ProductState {
  const factory ProductState.initial() = _Initial;
  const factory ProductState.loading() = _Loading;
  const factory ProductState.success() = _Success;
  const factory ProductState.error(String message) = _Error;
  const factory ProductState.imagePicked(File image) = _ImagePicked;
  const factory ProductState.imageNotPicked() = _ImageNotPicked;
}
