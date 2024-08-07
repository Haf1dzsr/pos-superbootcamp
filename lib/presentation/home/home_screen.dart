import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_superbootcamp/common/themes/app_color.dart';
import 'package:pos_superbootcamp/common/widgets/button.dart';
import 'package:pos_superbootcamp/data/models/product_model.dart';
import 'package:pos_superbootcamp/presentation/app_route_names.dart';
import 'package:pos_superbootcamp/presentation/home/widgets/product_card_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 180 / 210,
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCardWidget(product: products[index]);
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
