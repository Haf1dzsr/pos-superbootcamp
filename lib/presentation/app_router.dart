import 'package:go_router/go_router.dart';
import 'package:pos_superbootcamp/presentation/app_route_names.dart';
import 'package:pos_superbootcamp/presentation/auth/screens/login_screen.dart';
import 'package:pos_superbootcamp/presentation/auth/screens/register_screen.dart';
import 'package:pos_superbootcamp/presentation/globals.dart';
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
  ],
);
