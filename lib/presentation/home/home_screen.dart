import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_superbootcamp/common/themes/app_color.dart';
import 'package:pos_superbootcamp/common/widgets/button.dart';
import 'package:pos_superbootcamp/data/datasources/product_remote_datasource.dart';
import 'package:pos_superbootcamp/data/models/product_model.dart';
import 'package:pos_superbootcamp/presentation/app_route_names.dart';
import 'package:pos_superbootcamp/presentation/home/widgets/product_card_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          Badge(
            label: const Text('1'),
            offset: const Offset(-10, 0),
            child: Container(
              margin: const EdgeInsets.only(
                right: 16,
              ),
              decoration: const BoxDecoration(
                color: AppColor.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                  color: AppColor.white,
                ),
                onPressed: () {
                  context.pushNamed(AppRoutes.nrCart);
                },
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<List<ProductModel>>(
                stream: ProductRemoteDatasource.instance.getProducts(),
                builder: (context, snapshot) {
                  final products = snapshot.data ?? [];
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        snapshot.error.toString(),
                        style: const TextStyle(color: AppColor.error),
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(AppColor.primary),
                      ),
                    );
                  } else if (products.isEmpty) {
                    return const Center(
                      child: Text('Belum ada produk'),
                    );
                  } else if (snapshot.hasData) {
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1.8 / 2.4,
                        crossAxisCount: 2,
                        mainAxisSpacing: 16.0,
                        crossAxisSpacing: 16.0,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return ProductCardWidget(product: products[index]);
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('Terjadi Kesalahan'),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Button.filled(
        width: MediaQuery.of(context).size.width * 0.45,
        onPressed: () {
          context.pushNamed(AppRoutes.nrAddProduct);
        },
        label: 'Tambah Produk',
        fontSize: 14,
        icon: const Icon(
          Icons.add,
          color: AppColor.white,
          size: 16,
        ),
      ),
    );
  }
}
