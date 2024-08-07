import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_superbootcamp/common/constants/validators.dart';
import 'package:pos_superbootcamp/common/themes/app_color.dart';
import 'package:pos_superbootcamp/common/themes/app_font.dart';
import 'package:pos_superbootcamp/common/widgets/button.dart';
import 'package:pos_superbootcamp/common/widgets/custom_textformfield.dart';
import 'package:pos_superbootcamp/presentation/app_route_names.dart';
import 'package:pos_superbootcamp/presentation/auth/blocs/login/login_bloc.dart';
import 'package:pos_superbootcamp/presentation/auth/screens/register_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailC = TextEditingController();

  final TextEditingController passC = TextEditingController();

  final ValueNotifier<bool> obscureText = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        physics: const RangeMaintainingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                Text(
                  'Selamat Datang',
                  style: appTheme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                Text(
                  'Silahkan masukkan data informasi kamu yang sudah terdaftar',
                  style: appTheme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 48),
                CustomTextFormField(
                  textInputAction: TextInputAction.next,
                  label: 'E-mail',
                  hint: 'Masukkan E-mailmu',
                  controller: emailC,
                  validator: Validator.emailValidator,
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder(
                  valueListenable: obscureText,
                  builder: (context, value, child) {
                    return CustomTextFormField(
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      label: 'Kata Sandi',
                      hint: 'Masukkan kata sandimu',
                      obscureText: obscureText.value,
                      suffixIcon: IconButton(
                        onPressed: () {
                          obscureText.value = !obscureText.value;
                        },
                        icon: obscureText.value
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_outlined),
                      ),
                      controller: passC,
                      validator: Validator.passwordValidator,
                    );
                  },
                ),
                const SizedBox(height: 48),
                BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    state.maybeWhen(
                      orElse: () {},
                      success: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Login berhasil'),
                          ),
                        );
                        context.pushReplacementNamed(AppRoutes.nrMain);
                      },
                      failure: (message) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              message == 'verify-your-email-first'
                                  ? 'Silahkan verifikasi email kamu terlebih dahulu'
                                  : message,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () {
                        return Button.filled(
                          height: 40,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<LoginBloc>().add(
                                    LoginEvent.login(emailC.text, passC.text),
                                  );
                            } // BuildContext context
                          },
                          label: 'Login',
                          textColor: AppColor.white,
                        );
                      },
                      loading: () {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(AppColor.primary),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.topCenter,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        text: 'Belum punya akun? ',
                        style: appTheme.textTheme.bodySmall,
                        children: [
                          TextSpan(
                            text: 'Buat Akun',
                            style: appTheme.textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
