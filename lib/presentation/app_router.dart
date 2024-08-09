import 'package:go_router/go_router.dart';
import 'package:pos_superbootcamp/data/models/order_model.dart';
import 'package:pos_superbootcamp/data/models/product_model.dart';
import 'package:pos_superbootcamp/presentation/add_product/add_product_screen.dart';
import 'package:pos_superbootcamp/presentation/app_route_names.dart';
import 'package:pos_superbootcamp/presentation/auth/screens/login_screen.dart';
import 'package:pos_superbootcamp/presentation/auth/screens/register_screen.dart';
import 'package:pos_superbootcamp/presentation/cart/cart_screen.dart';
import 'package:pos_superbootcamp/presentation/edit_product/edit_product_screen.dart';
import 'package:pos_superbootcamp/presentation/globals.dart';
import 'package:pos_superbootcamp/presentation/home/home_screen.dart';
import 'package:pos_superbootcamp/presentation/inventory/inventory_screen.dart';
import 'package:pos_superbootcamp/presentation/main/main_screen.dart';
import 'package:pos_superbootcamp/presentation/order_detail/order_detail_screen.dart';
import 'package:pos_superbootcamp/presentation/order_detail/preview_pdf_screen.dart';
import 'package:pos_superbootcamp/presentation/payment/payment_screen.dart';
import 'package:pos_superbootcamp/presentation/product_detail/product_detail_screen.dart';
import 'package:pos_superbootcamp/presentation/report/report_detail_screen.dart';
import 'package:pos_superbootcamp/presentation/report/report_screen.dart';
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
      builder: (context, state) => HomeScreen(),
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
    GoRoute(
      path: AppRoutes.nrCart,
      name: AppRoutes.nrCart,
      builder: (context, state) => CartScreen(),
    ),
    GoRoute(
      path: AppRoutes.nrInventory,
      name: AppRoutes.nrInventory,
      builder: (context, state) => const InventoryScreen(),
    ),
    GoRoute(
      path: AppRoutes.nrEditProduct,
      name: AppRoutes.nrEditProduct,
      builder: (context, state) {
        final ProductModel product = state.extra as ProductModel;
        return EditProductScreen(
          product: product,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.nrPayment,
      name: AppRoutes.nrPayment,
      builder: (context, state) => PaymentScreen(),
    ),
    GoRoute(
      path: AppRoutes.nrOrderDetail,
      name: AppRoutes.nrOrderDetail,
      builder: (context, state) {
        final OrderModel order = state.extra as OrderModel;
        return OrderDetailScreen(order: order);
      },
    ),
    GoRoute(
      path: AppRoutes.nrReport,
      name: AppRoutes.nrReport,
      builder: (context, state) => ReportScreen(),
    ),
    GoRoute(
      path: AppRoutes.nrReportDetail,
      name: AppRoutes.nrReportDetail,
      builder: (context, state) {
        final OrderModel order = state.extra as OrderModel;
        return ReportDetailScreen(order: order);
      },
    ),
    GoRoute(
      path: AppRoutes.nrPreviewPdf,
      name: AppRoutes.nrPreviewPdf,
      builder: (context, state) {
        final OrderModel order = state.extra as OrderModel;
        return PreviewPdfScreen(order: order);
      },
    ),
  ],
);
