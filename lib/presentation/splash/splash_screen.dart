import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_superbootcamp/common/constants/images.dart';
import 'package:pos_superbootcamp/data/utils/auth_helper.dart';
import 'package:pos_superbootcamp/presentation/app_route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> checkLoginStatus() async {
    String? token = await AuthHelper.instance.getToken();

    if (token != null) {
      context.pushReplacementNamed(AppRoutes.nrMain);
    } else {
      context.pushReplacementNamed(AppRoutes.nrLogin);
    }
  }

  @override
  initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        await checkLoginStatus();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(Images.logo),
      ),
    );
  }
}
