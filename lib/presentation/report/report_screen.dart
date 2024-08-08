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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.white,
        toolbarHeight: kToolbarHeight + 60,
        title: ValueListenableBuilder(
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
      ),
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
          child: StreamBuilder<List<OrderModel>>(
            stream: OrderRemoteDatasource.instance
                .getOrdersByUserId(uid: currentUser!.uid),
            builder: (context, snapshot) {
              log("snapshot: ${snapshot.data}");
              final List<OrderModel> order = snapshot.data ?? [];
              final List<OrderModel> orderDone =
                  order.where((item) => item.orderStatus == 'Success').toList();

              List<OrderModel> filterOrders(
                  List<OrderModel> orders, String range) {
                final now = DateTime.now();
                final startOfDay = DateTime(now.year, now.month, now.day);

                switch (range) {
                  case "Hari ini":
                    return orders.where((order) {
                      final createdAt = order.createdAt!.toDate();
                      return createdAt.year == now.year &&
                          createdAt.month == now.month &&
                          createdAt.day == now.day;
                    }).toList();
                  case "Minggu ini":
                    final startOfWeek =
                        startOfDay.subtract(Duration(days: now.weekday - 1));
                    final endOfWeek = startOfWeek
                        .add(const Duration(days: 7))
                        .subtract(const Duration(seconds: 1));
                    return orders.where((order) {
                      final createdAt = order.createdAt!.toDate();
                      return createdAt.isAfter(startOfWeek) &&
                          createdAt.isBefore(endOfWeek);
                    }).toList();
                  case "Bulan ini":
                    return orders.where((order) {
                      final createdAt = order.createdAt!.toDate();
                      return createdAt.year == now.year &&
                          createdAt.month == now.month;
                    }).toList();
                  case "Tahun ini":
                    return orders.where((order) {
                      final createdAt = order.createdAt!.toDate();
                      return createdAt.year == now.year;
                    }).toList();
                  default:
                    return orders;
                }
              }

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
                builder: (context, value, _) {
                  final filteredOrders = filterOrders(orderDone, value);
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
          ),
        ),
      ),
    );
  }
}
