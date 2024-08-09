import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pos_superbootcamp/common/themes/app_color.dart';
import 'package:pos_superbootcamp/common/themes/app_font.dart';
import 'package:pos_superbootcamp/common/widgets/custom_dropdown.dart';
import 'package:pos_superbootcamp/data/datasources/order_remote_datasource.dart';
import 'package:pos_superbootcamp/data/models/order_model.dart';
import 'package:pos_superbootcamp/presentation/report/widgets/report_card_widget.dart';

class ReportScreen extends StatelessWidget {
  ReportScreen({super.key});

  final currentUser = FirebaseAuth.instance.currentUser;
  ValueNotifier<String> rangeSelected = ValueNotifier("Semua");
  ValueNotifier<String> productNameNotifier = ValueNotifier('');
  ValueNotifier<double?> minPriceNotifier = ValueNotifier(null);
  ValueNotifier<double?> maxPriceNotifier = ValueNotifier(null);
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();

  List<OrderModel> filterOrders(
    List<OrderModel> orders,
    String range,
    String productName,
    double? minPrice,
    double? maxPrice,
  ) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    List<OrderModel> filteredOrders;

    switch (range) {
      case "Hari ini":
        filteredOrders = orders.where((order) {
          final createdAt = order.createdAt!.toDate();
          return createdAt.year == now.year &&
              createdAt.month == now.month &&
              createdAt.day == now.day;
        }).toList();
        break;
      case "Minggu ini":
        final startOfWeek =
            startOfDay.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek
            .add(const Duration(days: 7))
            .subtract(const Duration(seconds: 1));
        filteredOrders = orders.where((order) {
          final createdAt = order.createdAt!.toDate();
          return createdAt.isAfter(startOfWeek) &&
              createdAt.isBefore(endOfWeek);
        }).toList();
        break;
      case "Bulan ini":
        filteredOrders = orders.where((order) {
          final createdAt = order.createdAt!.toDate();
          return createdAt.year == now.year && createdAt.month == now.month;
        }).toList();
        break;
      case "Tahun ini":
        filteredOrders = orders.where((order) {
          final createdAt = order.createdAt!.toDate();
          return createdAt.year == now.year;
        }).toList();
        break;
      default:
        filteredOrders = orders;
    }

    if (minPrice != null) {
      filteredOrders = filteredOrders.where((order) {
        return order.priceTotal! >= minPrice;
      }).toList();
    }

    if (maxPrice != null) {
      filteredOrders = filteredOrders.where((order) {
        return order.priceTotal! <= maxPrice;
      }).toList();
    }

    if (productName.isNotEmpty) {
      filteredOrders = filteredOrders.where((order) {
        return order.products!.any((product) {
          return product.name!
              .toLowerCase()
              .contains(productName.toLowerCase());
        });
      }).toList();
    }

    return filteredOrders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.white,
        toolbarHeight:
            kToolbarHeight + MediaQuery.of(context).size.height * 0.225,
        title: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: rangeSelected,
              builder: (context, value, _) {
                return CustomDropdown<String>(
                  label: "Pilih Range",
                  value: rangeSelected.value,
                  items: const [
                    "Semua",
                    "Hari ini",
                    "Minggu ini",
                    "Bulan ini",
                    "Tahun ini"
                  ],
                  onChanged: (value) {
                    rangeSelected.value = value ?? "Semua";
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: productNameController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    productNameController.clear();
                    productNameNotifier.value = '';
                  },
                  icon: const Icon(Icons.clear_rounded),
                ),
                labelText: 'Nama Produk',
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                productNameNotifier.value = value;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          minPriceController.clear();
                          minPriceNotifier.value = null;
                        },
                        icon: const Icon(Icons.clear_rounded),
                      ),
                      labelText: 'Harga Min',
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      minPriceNotifier.value = double.tryParse(value);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: maxPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          maxPriceController.clear();
                          maxPriceNotifier.value = null;
                        },
                        icon: const Icon(Icons.clear_rounded),
                      ),
                      labelText: 'Harga Max',
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      maxPriceNotifier.value = double.tryParse(value);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
          child: StreamBuilder<List<OrderModel>>(
            stream: OrderRemoteDatasource.instance
                .getOrdersByUserId(uid: currentUser!.uid),
            builder: (context, snapshot) {
              log("snapshot: ${snapshot.data}");
              final List<OrderModel> order = snapshot.data ?? [];
              final List<OrderModel> orderDone =
                  order.where((item) => item.orderStatus == 'Success').toList();

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(AppColor.primary),
                  ),
                );
              } else if (orderDone.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/empty_cart.svg",
                        width: 200,
                        height: 200,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Anda belum memiliki orderan selesai',
                        style: appTheme.textTheme.bodyMedium!
                            .copyWith(color: AppColor.grey),
                      ),
                    ],
                  ),
                );
              }
              return ValueListenableBuilder(
                valueListenable: rangeSelected,
                builder: (context, rangeValue, _) {
                  return ValueListenableBuilder(
                    valueListenable: productNameNotifier,
                    builder: (context, productName, child) {
                      return ValueListenableBuilder(
                        valueListenable: minPriceNotifier,
                        builder: (context, minPrice, _) {
                          return ValueListenableBuilder(
                            valueListenable: maxPriceNotifier,
                            builder: (context, maxPrice, _) {
                              final filteredOrders = filterOrders(orderDone,
                                  rangeValue, productName, minPrice, maxPrice);
                              log("filteredOrders: $filteredOrders");
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: filteredOrders.length,
                                itemBuilder: (context, index) {
                                  final item = filteredOrders[index];
                                  return ReportCardWidget(order: item);
                                },
                              );
                            },
                          );
                        },
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
