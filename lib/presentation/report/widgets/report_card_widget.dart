import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_superbootcamp/common/extensions/datetime_ext.dart';
import 'package:pos_superbootcamp/common/extensions/int_ext.dart';
import 'package:pos_superbootcamp/common/themes/app_color.dart';
import 'package:pos_superbootcamp/common/themes/app_font.dart';
import 'package:pos_superbootcamp/data/models/order_model.dart';
import 'package:pos_superbootcamp/presentation/app_route_names.dart';

class ReportCardWidget extends StatelessWidget {
  const ReportCardWidget({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(AppRoutes.nrReportDetail, extra: order);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColor.grey),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.paymentMethod ?? "",
                      style:
                          appTheme.textTheme.titleSmall!.copyWith(fontSize: 10),
                    ),
                    Text(
                      order.createdAt?.toDate().toFormattedTime() ?? "",
                      style: appTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    order.orderStatus ?? "",
                    style: appTheme.textTheme.titleSmall!.copyWith(
                      fontSize: 10,
                      color: AppColor.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            const Divider(
              color: AppColor.grey,
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.primary, width: 2),
                    color: AppColor.primary,
                  ),
                  child: ClipOval(
                    child: Image.network(
                      order.products?[0].imageUrl ?? "",
                      width: 40,
                      height: 40,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.products?.map((e) => e.name).join(", ") ?? "",
                      style:
                          appTheme.textTheme.titleSmall!.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Harga",
                      style: appTheme.textTheme.bodySmall!.copyWith(
                        fontSize: 8,
                      ),
                    ),
                    Text(
                      order.priceTotal?.currencyFormatRp ?? "",
                      style: appTheme.textTheme.titleSmall!.copyWith(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
