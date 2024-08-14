import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_superbootcamp/common/constants/images.dart';
import 'package:pos_superbootcamp/common/extensions/int_ext.dart';
import 'package:pos_superbootcamp/common/themes/app_color.dart';
import 'package:pos_superbootcamp/common/themes/app_font.dart';
import 'package:pos_superbootcamp/common/widgets/button.dart';
import 'package:pos_superbootcamp/common/widgets/dash_divider.dart';
import 'package:pos_superbootcamp/data/datasources/product_remote_datasource.dart';
import 'package:pos_superbootcamp/data/models/cart_model.dart';
import 'package:pos_superbootcamp/data/models/order_model.dart';
import 'package:pos_superbootcamp/data/models/product_model.dart';
import 'package:pos_superbootcamp/presentation/app_route_names.dart';
import 'package:pos_superbootcamp/presentation/payment/cubits/cubit/order_cubit.dart';
import 'package:pos_superbootcamp/presentation/payment/widgets/payment_option_card_widget.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen({super.key});

  final currentUser = FirebaseAuth.instance.currentUser;

  ValueNotifier<int> biayaAdmin = ValueNotifier(0);
  ValueNotifier<String> selectedPaymentMethod = ValueNotifier('');

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
          'Pembayaran',
          style: appTheme.textTheme.titleSmall,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: ValueListenableBuilder(
          valueListenable: selectedPaymentMethod,
          builder: (context, value, selectedPayment) {
            return ValueListenableBuilder(
              valueListenable: biayaAdmin,
              builder: (context, value, biaya) {
                return Column(
                  children: [
                    PaymentOptionCardWidget(
                      biayaAdmin: 1000,
                      title: 'BCA',
                      imageUrl: Images.paymentBca,
                      color: selectedPaymentMethod.value == 'BCA'
                          ? AppColor.primary100
                          : AppColor.white,
                      onTap: () {
                        selectedPaymentMethod.value = 'BCA';
                        biayaAdmin.value = 1000;
                      },
                    ),
                    const SizedBox(height: 16),
                    PaymentOptionCardWidget(
                      biayaAdmin: 2000,
                      title: 'BRI',
                      imageUrl: Images.paymentBri,
                      color: selectedPaymentMethod.value == 'BRI'
                          ? AppColor.primary100
                          : AppColor.white,
                      onTap: () {
                        selectedPaymentMethod.value = 'BRI';
                        biayaAdmin.value = 2000;
                      },
                    ),
                    const SizedBox(height: 16),
                    PaymentOptionCardWidget(
                      biayaAdmin: 2000,
                      title: 'Mandiri',
                      imageUrl: Images.paymentMandiri,
                      color: selectedPaymentMethod.value == 'Mandiri'
                          ? AppColor.primary100
                          : AppColor.white,
                      onTap: () {
                        selectedPaymentMethod.value = 'Mandiri';
                        biayaAdmin.value = 2000;
                      },
                    ),
                    const SizedBox(height: 16),
                    PaymentOptionCardWidget(
                      biayaAdmin: 1000,
                      title: 'Sea Bank',
                      imageUrl: Images.paymentSeaBank,
                      color: selectedPaymentMethod.value == 'SeaBank'
                          ? AppColor.primary100
                          : AppColor.white,
                      onTap: () {
                        selectedPaymentMethod.value = 'SeaBank';
                        biayaAdmin.value = 1000;
                      },
                    ),
                    const SizedBox(height: 16),
                    PaymentOptionCardWidget(
                      biayaAdmin: 1000,
                      title: 'Gopay',
                      imageUrl: Images.paymentGopay,
                      color: selectedPaymentMethod.value == 'Gopay'
                          ? AppColor.primary100
                          : AppColor.white,
                      onTap: () {
                        selectedPaymentMethod.value = 'Gopay';
                        biayaAdmin.value = 1000;
                      },
                    ),
                    const SizedBox(height: 16),
                    PaymentOptionCardWidget(
                      biayaAdmin: 1000,
                      title: 'Dana',
                      imageUrl: Images.paymentDana,
                      color: selectedPaymentMethod.value == 'Dana'
                          ? AppColor.primary100
                          : AppColor.white,
                      onTap: () {
                        selectedPaymentMethod.value = 'Dana';
                        biayaAdmin.value = 1000;
                      },
                    ),
                    const SizedBox(height: 16),
                    PaymentOptionCardWidget(
                      biayaAdmin: 2000,
                      title: 'Shopee Pay',
                      imageUrl: Images.paymentShopeePay,
                      color: selectedPaymentMethod.value == 'ShopeePay'
                          ? AppColor.primary100
                          : AppColor.white,
                      onTap: () {
                        selectedPaymentMethod.value = 'ShopeePay';
                        biayaAdmin.value = 2000;
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        decoration: const BoxDecoration(color: AppColor.white),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0),
          child: StreamBuilder<List<CartModel>>(
            stream: ProductRemoteDatasource.instance
                .getAllCartItemsByUserId(uid: currentUser!.uid),
            builder: (context, snapshot) {
              final data = snapshot.data ?? [];

              int cartPriceTotal = 0;
              for (var item in data) {
                cartPriceTotal += item.priceTotal!;
              }

              return StreamBuilder<List<ProductModel>>(
                stream: ProductRemoteDatasource.instance
                    .getProducts(uid: currentUser!.uid),
                builder: (context, snapshot) {
                  final products = snapshot.data ?? [];
                  return ValueListenableBuilder(
                    valueListenable: biayaAdmin,
                    builder: (context, value, biaya) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const DashDivider(),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Biaya Admin",
                                style: appTheme.textTheme.titleMedium,
                              ),
                              Text(
                                biayaAdmin.value.currencyFormatRp,
                                style: appTheme.textTheme.titleMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Harga",
                                style: appTheme.textTheme.titleMedium,
                              ),
                              Text(
                                (cartPriceTotal + biayaAdmin.value)
                                    .currencyFormatRp,
                                style: appTheme.textTheme.titleMedium,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          BlocConsumer<OrderCubit, OrderState>(
                            listener: (context, state) {
                              state.maybeWhen(
                                success: (order) async {
                                  for (var item in data) {
                                    for (var product in products) {
                                      if (product.id == item.id) {
                                        await ProductRemoteDatasource.instance
                                            .updateProductQuantity(
                                          productId: item.id!,
                                          quantity:
                                              product.stock! - item.quantity!,
                                        );
                                      }
                                    }
                                  }
                                  await ProductRemoteDatasource.instance
                                      .deleteAllCartItemsByUserId(
                                    uid: currentUser!.uid,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Order berhasil dibuat'),
                                    ),
                                  );
                                  context.pushNamed(AppRoutes.nrOrderDetail,
                                      extra: order);
                                },
                                orElse: () {},
                              );
                            },
                            builder: (context, state) {
                              return state.maybeWhen(
                                loading: () {
                                  return const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                        AppColor.primary),
                                  );
                                },
                                orElse: () {
                                  return Button.filled(
                                    onPressed: () {
                                      final now = Timestamp.now();
                                      final order = OrderModel(
                                        userId: currentUser!.uid,
                                        products: data,
                                        biayaAdmin: biayaAdmin.value,
                                        orderStatus: 'Success',
                                        paymentMethod:
                                            selectedPaymentMethod.value,
                                        priceTotal:
                                            cartPriceTotal + biayaAdmin.value,
                                        createdAt: now,
                                      );

                                      if (selectedPaymentMethod.value != '') {
                                        context.read<OrderCubit>().createOrder(
                                              order: order,
                                              uid: currentUser!.uid,
                                            );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Pilih metode pembayaran terlebih dahulu',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    label: 'Lanjutkan',
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
