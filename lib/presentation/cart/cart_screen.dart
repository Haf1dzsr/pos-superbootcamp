import 'package:flutter/material.dart';
import 'package:pos_superbootcamp/common/themes/app_color.dart';
import 'package:pos_superbootcamp/common/themes/app_font.dart';
import 'package:pos_superbootcamp/data/datasources/product_remote_datasource.dart';
import 'package:pos_superbootcamp/data/models/cart_model.dart';
import 'package:pos_superbootcamp/presentation/cart/widgets/cart_item_card_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
            }),
      ),
    );
  }
}
