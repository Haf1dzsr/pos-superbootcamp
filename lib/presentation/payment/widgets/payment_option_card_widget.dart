import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pos_superbootcamp/common/themes/app_color.dart';
import 'package:pos_superbootcamp/common/themes/app_font.dart';

class PaymentOptionCardWidget extends StatelessWidget {
  PaymentOptionCardWidget({
    super.key,
    required this.biayaAdmin,
    required this.title,
    required this.imageUrl,
    this.color = AppColor.white,
    required this.onTap,
  });

  final int biayaAdmin;
  final String title;
  final String imageUrl;
  Color color;
  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: AppColor.grey,
          ),
          color: color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: appTheme.textTheme.labelLarge!.copyWith(fontSize: 16),
            ),
            SvgPicture.asset(
              imageUrl,
              width: 36,
            ),
          ],
        ),
      ),
    );
  }
}
