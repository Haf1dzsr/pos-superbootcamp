import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_superbootcamp/common/extensions/datetime_ext.dart';
import 'package:pos_superbootcamp/common/extensions/int_ext.dart';
import 'package:pos_superbootcamp/common/themes/app_color.dart';
import 'package:pos_superbootcamp/common/themes/app_font.dart';
import 'package:pos_superbootcamp/data/models/order_model.dart';
import 'package:pos_superbootcamp/presentation/order_detail/widgets/order_detail_product_card_widget.dart';
import 'package:pos_superbootcamp/presentation/order_detail/widgets/stepper_data_widget.dart';

class OrderDetailScreen extends StatelessWidget {
  OrderDetailScreen({super.key, required this.order});

  final OrderModel order;
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            context.pop();
            context.pop();
            context.pop();
          },
          icon: const Icon(
            Icons.chevron_left,
            size: 24,
          ),
        ),
        title: Text(
          'Detail Pesanan',
          style: appTheme.textTheme.titleSmall,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const StepperDataWidget(),
            const SizedBox(height: 24),
            Text(
              'Produk dipesan',
              style: appTheme.textTheme.headlineSmall!.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: order.products!.length,
              itemBuilder: (item, index) {
                final product = order.products![index];
                return OrderDetailProductCardWidget(cartItem: product);
              },
            ),
            const SizedBox(width: 32),
            //! Detail Pesanan
            Text(
              'Detail Pesanan',
              style: appTheme.textTheme.headlineSmall!.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(20.0),
                // border: Border.all(color: AppColor.grey),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Waktu Pemesanan',
                        style: appTheme.textTheme.bodySmall!
                            .copyWith(color: AppColor.grey),
                      ),
                      Text(
                        order.createdAt!.toDate().toFormattedTime(),
                        style: appTheme.textTheme.bodySmall!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Metode Pembayaran',
                        style: appTheme.textTheme.bodySmall!
                            .copyWith(color: AppColor.grey),
                      ),
                      Text(
                        order.paymentMethod ?? '',
                        style: appTheme.textTheme.bodySmall!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            //! Detail Harga
            Text(
              'Detail Harga',
              style: appTheme.textTheme.headlineSmall!.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(20.0),
                // border: Border.all(color: AppColor.grey),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Biaya Admin',
                        style: appTheme.textTheme.bodySmall!
                            .copyWith(color: AppColor.grey),
                      ),
                      Text(
                        order.biayaAdmin!.currencyFormatRp,
                        style: appTheme.textTheme.bodySmall!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Harga',
                        style: appTheme.textTheme.bodySmall!
                            .copyWith(color: AppColor.grey),
                      ),
                      Text(
                        order.priceTotal!.currencyFormatRp,
                        style: appTheme.textTheme.bodySmall!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
