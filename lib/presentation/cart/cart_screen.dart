import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pos_superbootcamp/common/extensions/int_ext.dart';
import 'package:pos_superbootcamp/common/themes/app_color.dart';
import 'package:pos_superbootcamp/common/themes/app_font.dart';
import 'package:pos_superbootcamp/common/widgets/button.dart';
import 'package:pos_superbootcamp/common/widgets/dash_divider.dart';
import 'package:pos_superbootcamp/data/datasources/product_remote_datasource.dart';
import 'package:pos_superbootcamp/data/models/cart_model.dart';
import 'package:pos_superbootcamp/presentation/cart/widgets/cart_item_card_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.chevron_left,
            size: 24,
          ),
        ),
        title: Text(
          'Keranjang',
          style: appTheme.textTheme.titleSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: StreamBuilder<List<CartModel>>(
          stream: ProductRemoteDatasource.instance.getAllCartItemsByUserId(),
          builder: (context, snapshot) {
            final cartItems = snapshot.data ?? [];
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: const TextStyle(color: AppColor.error),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (cartItems.isEmpty) {
              return const Center(
                child: Text('Keranjang masih kosong'),
              );
            } else if (cartItems.isNotEmpty) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartItems[index];
                  return CartItemCardWidget(cartItem: cartItem);
                },
              );
            } else {
              return const Center(
                child: Text('Terjadi Kesalahan'),
              );
            }
          },
        ),
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(color: AppColor.white),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0),
          child: StreamBuilder<List<CartModel>>(
            stream: ProductRemoteDatasource.instance.getAllCartItemsByUserId(),
            builder: (context, snapshot) {
              final data = snapshot.data ?? [];

              int cartPriceTotal = 0;
              for (var item in data) {
                cartPriceTotal += item.priceTotal!;
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const DashDivider(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Harga",
                        style: appTheme.textTheme.titleMedium,
                      ),
                      Text(
                        cartPriceTotal.currencyFormatRp,
                        style: appTheme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Button.filled(
                    onPressed: () {
                      if (data.isEmpty) {
                        return showDialog(
                          context: context,
                          builder: (context2) {
                            return AlertDialog(
                              content: SizedBox(
                                width: MediaQuery.of(context2).size.width - 32,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/empty_cart.svg',
                                      placeholderBuilder:
                                          SvgPicture.defaultPlaceholderBuilder,
                                      width: 80,
                                      height: 120,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Keranjang anda masih kosong',
                                      style: appTheme.textTheme.labelLarge!
                                          .copyWith(fontSize: 20),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      'Anda belum menambahkan item apapun ke keranjang anda',
                                      style: appTheme.textTheme.titleMedium!
                                          .copyWith(color: AppColor.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                Button.filled(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  label: 'OK',
                                )
                              ],
                            );
                          },
                        );
                      } else {
                        //!
                        // cart isn't empty handler
                      }
                    },
                    height: 40,
                    width: MediaQuery.of(context).size.width - 32,
                    fontSize: 14,
                    label: 'Bayar',
                    textColor: AppColor.white,
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
