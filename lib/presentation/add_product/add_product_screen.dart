import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_superbootcamp/common/constants/validators.dart';
import 'package:pos_superbootcamp/common/themes/app_color.dart';
import 'package:pos_superbootcamp/common/themes/app_font.dart';
import 'package:pos_superbootcamp/common/widgets/button.dart';
import 'package:pos_superbootcamp/common/widgets/custom_textformfield.dart';
import 'package:pos_superbootcamp/presentation/add_product/cubits/product_cubit/product_cubit.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController productNameC = TextEditingController();

  final TextEditingController productDescC = TextEditingController();

  final TextEditingController productPriceC = TextEditingController();

  final TextEditingController productStockC = TextEditingController();

  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: AppColor.white,
          ),
          onPressed: () {
            context.pop();
          },
        ),
        centerTitle: true,
        title: Text(
          'Tambah Produk',
          style: appTheme.textTheme.labelLarge!.copyWith(
            color: AppColor.white,
            fontSize: 16,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 16.0),
                BlocBuilder<ProductCubit, ProductState>(
                  builder: (context, state) {
                    return Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColor.primary, width: 2),
                      ),
                      child: state.maybeWhen(
                        initial: () => const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: AppColor.greyFill,
                        ),
                        imagePicked: (image) {
                          _image = image;
                          return ClipOval(
                            child: Image.file(
                              image,
                              fit: BoxFit.cover,
                              width: 150,
                              height: 150,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: AppColor.greyFill,
                                );
                              },
                            ),
                          );
                        },
                        orElse: () {
                          return const Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: AppColor.greyFill,
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Button.outlined(
                  onPressed: () async {
                    context.read<ProductCubit>().pickImage();
                  },
                  color: Colors.transparent,
                  textColor: AppColor.primary,
                  label: 'Pilih Gambar',
                  width: MediaQuery.of(context).size.width * 0.45,
                ),
                const SizedBox(height: 48),
                CustomTextFormField(
                  textInputAction: TextInputAction.next,
                  label: 'Nama Produk',
                  hint: "Masukkan Nama Produk",
                  controller: productNameC,
                  validator: (value) => Validator.requiredValidator(value),
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  textInputAction: TextInputAction.next,
                  label: 'Deskripsi Produk',
                  hint: "Masukkan Deskripsi Produk",
                  controller: productDescC,
                  validator: (value) => Validator.requiredValidator(value),
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  textInputAction: TextInputAction.next,
                  label: 'Harga Produk',
                  hint: "Masukkan Harga Produk",
                  controller: productPriceC,
                  validator: (value) => Validator.numberValidator(value),
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  textInputAction: TextInputAction.done,
                  label: 'Stok Produk',
                  hint: "Masukkan Stok Produk",
                  validator: (value) => Validator.numberValidator(value),
                  controller: productStockC,
                ),
                const SizedBox(height: 48),
                BlocConsumer<ProductCubit, ProductState>(
                  listener: (context, state) {
                    state.maybeWhen(
                      success: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Produk berhasil ditambahkan'),
                          ),
                        );
                        context.pop();
                      },
                      error: (failure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(failure),
                          ),
                        );
                      },
                      orElse: () {},
                    );
                  },
                  builder: (context, state) {
                    return state.maybeWhen(
                      loading: () {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      orElse: () {
                        return Button.filled(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<ProductCubit>().addProduct(
                                    productNameC.text,
                                    productDescC.text,
                                    int.parse(productPriceC.text),
                                    int.parse(productStockC.text),
                                    _image,
                                  );
                            }
                          },
                          label: 'Simpan',
                          color: AppColor.primary,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
