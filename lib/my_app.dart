import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_superbootcamp/presentation/app_router.dart';
import 'package:pos_superbootcamp/presentation/auth/blocs/login/login_bloc.dart';
import 'package:pos_superbootcamp/presentation/auth/blocs/register/register_bloc.dart';

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
