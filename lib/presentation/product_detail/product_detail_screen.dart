import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_superbootcamp/common/extensions/int_ext.dart';
import 'package:pos_superbootcamp/common/themes/app_color.dart';
import 'package:pos_superbootcamp/common/themes/app_font.dart';
import 'package:pos_superbootcamp/common/widgets/button.dart';
import 'package:pos_superbootcamp/data/datasources/product_remote_datasource.dart';
import 'package:pos_superbootcamp/data/models/product_model.dart';
import 'package:pos_superbootcamp/presentation/product_detail/cubits/add_product_to_cart/add_product_to_cart_cubit.dart';

class ProductDetailScreen extends StatelessWidget {
  ProductDetailScreen({super.key, required this.product});

  final currentUser = FirebaseAuth.instance.currentUser;

  final ProductModel product;

  ValueNotifier<int> priceTotal = ValueNotifier(0);
  ValueNotifier<int> totalItem = ValueNotifier(1);

  void updateTotalPrice() {
    priceTotal.value = product.price! * totalItem.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left,
            size: 24,
          ),
        ),
        title: Text(
          'Detail Produk',
          style: appTheme.textTheme.titleSmall,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 48),
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColor.primary,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    product.imageUrl ?? '',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: AppColor.greyFill,
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
            Text(
              product.name ?? '',
              style: appTheme.textTheme.displaySmall!.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 180,
                  child: Text(
                    product.price!.currencyFormatRp,
                    style: appTheme.textTheme.bodySmall,
                  ),
                ),
                SizedBox(
                  child: ValueListenableBuilder(
                    valueListenable: totalItem,
                    builder: (context, value, _) => Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColor.primary,
                          child: IconButton(
                            onPressed: () {
                              if (totalItem.value == 1) {
                                return;
                              }

                              totalItem.value--;
                            },
                            icon: const Icon(
                              Icons.remove,
                              color: AppColor.white,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          totalItem.value.toString(),
                          style: appTheme.textTheme.displaySmall!
                              .copyWith(fontSize: 24),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        CircleAvatar(
                          backgroundColor: AppColor.primary,
                          child: IconButton(
                            onPressed: () {
                              totalItem.value++;
                            },
                            icon: const Icon(
                              Icons.add,
                              color: AppColor.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: ValueListenableBuilder(
          valueListenable: totalItem,
          builder: (context, totItem, _) {
            return ValueListenableBuilder(
              valueListenable: priceTotal,
              builder: (context, totPrice, _) {
                return Button.filled(
                  onPressed: () async {
                    await ProductRemoteDatasource.instance.addProductToCart(
                      userId: currentUser!.uid,
                      product: product,
                      quantity: totItem,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.8,
                        ),
                        backgroundColor: AppColor.primary,
                        content: Text(
                          'Produk ${product.name} berhasil ditambahkan ke keranjang',
                        ),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  height: 40,
                  width: MediaQuery.of(context).size.width - 32,
                  fontSize: 14,
                  icon: BlocConsumer<AddProductToCartCubit,
                      AddProductToCartState>(
                    listener: (context, state) {
                      state.maybeWhen(
                        success: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Produk berhasil ditambahkan'),
                            ),
                          );
                        },
                        error: (failure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(failure),
                            ),
                          );
                        },
                        orElse: () {},
                      );
                    },
                    builder: (context, state) {
                      return state.maybeWhen(
                        loading: () {
                          return const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(AppColor.white),
                          );
                        },
                        orElse: () {
                          return const Icon(
                            Icons.shopping_cart,
                            color: AppColor.white,
                            size: 16,
                          );
                        },
                      );
                    },
                  ),
                  label:
                      'Tambah ke Keranjang - ${(product.price! * totItem).currencyFormatRp}',
                  textColor: AppColor.white,
                );
              },
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
