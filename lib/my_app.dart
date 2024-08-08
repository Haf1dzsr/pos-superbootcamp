import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_superbootcamp/presentation/add_product/cubits/product_cubit/product_cubit.dart';
import 'package:pos_superbootcamp/presentation/app_router.dart';
import 'package:pos_superbootcamp/presentation/auth/blocs/login/login_bloc.dart';
import 'package:pos_superbootcamp/presentation/auth/blocs/register/register_bloc.dart';
import 'package:pos_superbootcamp/presentation/edit_product/cubits/cubit/edit_product_cubit.dart';
import 'package:pos_superbootcamp/presentation/product_detail/cubits/add_product_to_cart/add_product_to_cart_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterBloc(),
        ),
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
        BlocProvider(
          create: (context) => ProductCubit(),
        ),
        BlocProvider(
          create: (context) => AddProductToCartCubit(),
        ),
        BlocProvider(
          create: (context) => EditProductCubit(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routeInformationProvider: appGlobalRouter.routeInformationProvider,
        routeInformationParser: appGlobalRouter.routeInformationParser,
        routerDelegate: appGlobalRouter.routerDelegate,
        theme: ThemeData(
          useMaterial3: true,
        ),
      ),
    );
  }
}
