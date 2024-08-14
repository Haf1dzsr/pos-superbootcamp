import 'package:another_stepper/dto/stepper_data.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:pos_superbootcamp/common/themes/app_color.dart';

class StepperDataWidget extends StatelessWidget {
  const StepperDataWidget({super.key});

  final String orderStatus = "Success";
  @override
  Widget build(BuildContext context) {
    return AnotherStepper(
      activeBarColor: AppColor.primary,
      inActiveBarColor: AppColor.grey.withOpacity(0.5),
      barThickness: 0.75,
      activeIndex: 0,
      stepperList: [
        StepperData(
          title: StepperText(
            "Order Created",
            textStyle: TextStyle(
              color: Colors.grey,
              fontWeight: orderStatus == "Order Created" ||
                      orderStatus == "Payment Pending" ||
                      orderStatus == "Payment On Review" ||
                      orderStatus == "Success"
                  ? FontWeight.bold
                  : FontWeight.w500,
            ),
          ),
          iconWidget: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: orderStatus == "Order Created" ||
                      orderStatus == "Payment Pending" ||
                      orderStatus == "Payment On Review" ||
                      orderStatus == "Success"
                  ? AppColor.primary
                  : AppColor.primary.withOpacity(0.5),
              borderRadius: const BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            child: const Icon(
              Icons.check,
              color: AppColor.white,
              size: 12,
            ),
          ),
        ),
        StepperData(
          title: StepperText(
            "Payment Pending",
            textStyle: TextStyle(
              color: Colors.grey,
              fontWeight: orderStatus == "Payment Pending" ||
                      orderStatus == "Payment On Review" ||
                      orderStatus == "Success"
                  ? FontWeight.bold
                  : FontWeight.w500,
            ),
          ),
          iconWidget: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: orderStatus == "Payment Pending" ||
                      orderStatus == "Payment On Review" ||
                      orderStatus == "Success"
                  ? AppColor.primary
                  : AppColor.primary.withOpacity(0.5),
              borderRadius: const BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            child: const Icon(
              Icons.check,
              color: AppColor.white,
              size: 12,
            ),
          ),
        ),
        StepperData(
          title: StepperText(
            "Payment On Review",
            textStyle: TextStyle(
              color: Colors.grey,
              fontWeight:
                  orderStatus == "Payment On Review" || orderStatus == "Success"
                      ? FontWeight.bold
                      : FontWeight.w500,
            ),
          ),
          iconWidget: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color:
                  orderStatus == "Payment On Review" || orderStatus == "Success"
                      ? AppColor.primary
                      : AppColor.primary.withOpacity(0.5),
              borderRadius: const BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            child: const Icon(
              Icons.check,
              color: AppColor.white,
              size: 12,
            ),
          ),
        ),
        StepperData(
          title: StepperText(
            "Success",
            textStyle: TextStyle(
              color: Colors.grey,
              fontWeight:
                  orderStatus == "Success" ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          iconWidget: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: orderStatus == "Success"
                  ? AppColor.primary
                  : AppColor.primary.withOpacity(0.5),
              borderRadius: const BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            child: const Icon(
              Icons.check,
              color: AppColor.white,
              size: 12,
            ),
          ),
        ),
      ],
      stepperDirection: Axis.horizontal,
      inverted: true,
      verticalGap: 60,
    );
  }
}
