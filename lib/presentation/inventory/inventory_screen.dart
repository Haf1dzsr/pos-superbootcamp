import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_superbootcamp/common/themes/app_color.dart';
import 'package:pos_superbootcamp/common/widgets/button.dart';
import 'package:pos_superbootcamp/data/datasources/product_remote_datasource.dart';
import 'package:pos_superbootcamp/data/models/product_model.dart';
import 'package:pos_superbootcamp/presentation/app_route_names.dart';
import 'package:pos_superbootcamp/presentation/inventory/widgets/inventory_product_card_widget.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.85,
                      child: GridView.builder(
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
                          return InventoryProductCardWidget(
                              product: products[index]);
                        },
                      ),
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
