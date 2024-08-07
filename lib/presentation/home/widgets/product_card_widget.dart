import 'package:flutter/material.dart';
import 'package:pos_superbootcamp/common/extensions/int_ext.dart';
import 'package:pos_superbootcamp/common/themes/app_color.dart';
import 'package:pos_superbootcamp/common/themes/app_font.dart';
import 'package:pos_superbootcamp/data/models/product_model.dart';

class ProductCardWidget extends StatelessWidget {
  const ProductCardWidget({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(right: 16, bottom: 4),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: AppColor.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: 76,
              height: 76,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.primary,
              ),
              child: Image.asset(
                product.imageName ?? '',
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image_not_supported,
                    color: AppColor.white,
                  );
                },
              ),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Text(
                product.name!,
                style: appTheme.textTheme.titleMedium,
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(product.price!.currencyFormatRp),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.primary,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 14,
                      color: AppColor.white,
                    ),
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
