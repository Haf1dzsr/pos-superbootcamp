import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_superbootcamp/common/constants/validators.dart';
import 'package:pos_superbootcamp/common/themes/app_color.dart';
import 'package:pos_superbootcamp/common/themes/app_font.dart';
import 'package:pos_superbootcamp/common/widgets/button.dart';
import 'package:pos_superbootcamp/common/widgets/custom_textformfield.dart';
import 'package:pos_superbootcamp/presentation/app_route_names.dart';
import 'package:pos_superbootcamp/presentation/auth/blocs/register/register_bloc.dart';
import 'package:pos_superbootcamp/presentation/auth/screens/login_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
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
                  'Daftar untuk menikmati kemudahan fitur Pick-up & Delivery milik Banabams',
                  style: appTheme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 48),
                CustomTextFormField(
                  textInputAction: TextInputAction.next,
                  label: 'Nama',
                  hint: 'Masukkan namamu',
                  controller: nameC,
                  validator: Validator.nameValidator,
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  textInputAction: TextInputAction.next,
                  label: 'Nomor Handphone',
                  hint: 'Masukkan Nomor Handphonemu',
                  controller: phoneC,
                  validator: Validator.phoneNumberValidator,
                ),
                const SizedBox(height: 16),
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
                        textInputAction: TextInputAction.next,
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
                    }),
                const SizedBox(height: 48),
                BlocConsumer<RegisterBloc, RegisterState>(
                  listener: (context, state) {
                    state.maybeWhen(
                      orElse: () {},
                      success: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Berhasil mendaftarkan akun baru, silahkan cek email untuk verifikasi',
                            ),
                          ),
                        );
                        context.pushReplacementNamed(AppRoutes.nrLogin);
                      },
                      failure: (message) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColor.error,
                            content: Text(message),
                          ),
                        );
                      },
                    );
                  },
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () {
                        return Button.filled(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<RegisterBloc>().add(
                                    RegisterEvent.register(
                                      name: nameC.text,
                                      phoneNumber: phoneC.text,
                                      email: emailC.text,
                                      password: passC.text,
                                    ),
                                  );
                            }
                          },
                          label: 'Buat Akun',
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
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        text: 'Sudah punya akun? ',
                        style: appTheme.textTheme.bodySmall,
                        children: [
                          TextSpan(
                            text: 'Login',
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
