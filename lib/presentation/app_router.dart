import 'package:go_router/go_router.dart';
import 'package:pos_superbootcamp/data/models/product_model.dart';
import 'package:pos_superbootcamp/presentation/add_product/add_product_screen.dart';
import 'package:pos_superbootcamp/presentation/app_route_names.dart';
import 'package:pos_superbootcamp/presentation/auth/screens/login_screen.dart';
import 'package:pos_superbootcamp/presentation/auth/screens/register_screen.dart';
import 'package:pos_superbootcamp/presentation/globals.dart';
import 'package:pos_superbootcamp/presentation/home/home_screen.dart';
import 'package:pos_superbootcamp/presentation/main/main_screen.dart';
import 'package:pos_superbootcamp/presentation/product_detail/product_detail_screen.dart';
import 'package:pos_superbootcamp/presentation/splash/splash_screen.dart';

final GoRouter appGlobalRouter = GoRouter(
  navigatorKey: AppGlobals.navigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: AppRoutes.nrSplash,
      name: AppRoutes.nrSplash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.nrLogin,
      name: AppRoutes.nrLogin,
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.nrRegister,
      name: AppRoutes.nrRegister,
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.nrMain,
      name: AppRoutes.nrMain,
      builder: (context, state) => MainScreen(),
    ),
    GoRoute(
      path: AppRoutes.nrHome,
      name: AppRoutes.nrHome,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.nrAddProduct,
      name: AppRoutes.nrAddProduct,
      builder: (context, state) => const AddProductScreen(),
    ),
    GoRoute(
      path: AppRoutes.nrProductDetail,
      name: AppRoutes.nrProductDetail,
      builder: (context, state) {
        final ProductModel product = state.extra as ProductModel;
        return ProductDetailScreen(
          product: product,
        );
      },
    ),
  ],
);
