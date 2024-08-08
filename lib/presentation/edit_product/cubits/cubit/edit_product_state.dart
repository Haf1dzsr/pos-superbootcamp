part of 'edit_product_cubit.dart';

@freezed
class EditProductState with _$EditProductState {
  const factory EditProductState.initial() = _Initial;
  const factory EditProductState.loading() = _Loading;
  const factory EditProductState.success() = _Success;
  const factory EditProductState.error(String message) = _Error;
  const factory EditProductState.imagePicked(File image) = _ImagePicked;
  const factory EditProductState.imageNotPicked() = _ImageNotPicked;
  const factory EditProductState.deleted() = _Deleted;
}
