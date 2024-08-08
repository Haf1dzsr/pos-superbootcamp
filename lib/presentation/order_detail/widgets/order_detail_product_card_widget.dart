import 'package:flutter/material.dart';
import 'package:pos_superbootcamp/common/extensions/int_ext.dart';
import 'package:pos_superbootcamp/common/themes/app_color.dart';
import 'package:pos_superbootcamp/common/themes/app_font.dart';
import 'package:pos_superbootcamp/data/models/cart_model.dart';

class OrderDetailProductCardWidget extends StatelessWidget {
  const OrderDetailProductCardWidget({super.key, required this.cartItem});

  final CartModel cartItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                alignment: Alignment.center,
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColor.primary,
                    width: 2,
                  ),
                ),
                child: Image.network(
                  width: 85,
                  height: 85,
                  fit: BoxFit.cover,
                  cartItem.imageUrl ?? '',
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: Text(
                      cartItem.name ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cartItem.priceTotal!.currencyFormatRp,
                        style: appTheme.textTheme.titleLarge!
                            .copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: SizedBox(
              child: Row(
                children: [
                  const Text(
                    'qty:  ',
                    style: TextStyle(fontSize: 20, color: AppColor.primary100),
                  ),
                  Text(
                    '${cartItem.quantity}',
                    style:
                        const TextStyle(fontSize: 20, color: AppColor.primary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
