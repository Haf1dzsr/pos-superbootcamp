import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_superbootcamp/common/constants/validators.dart';
import 'package:pos_superbootcamp/common/themes/app_color.dart';
import 'package:pos_superbootcamp/common/themes/app_font.dart';
import 'package:pos_superbootcamp/common/widgets/button.dart';
import 'package:pos_superbootcamp/common/widgets/custom_textformfield.dart';
import 'package:pos_superbootcamp/data/models/product_model.dart';
import 'package:pos_superbootcamp/presentation/edit_product/cubits/cubit/edit_product_cubit.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key, required this.product});

  final ProductModel product;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController productNameC = TextEditingController();

  final TextEditingController productDescC = TextEditingController();

  final TextEditingController productPriceC = TextEditingController();

  final TextEditingController productStockC = TextEditingController();

  File? _image;

  @override
  void initState() {
    productNameC.text = widget.product.name!;
    productDescC.text = widget.product.description!;
    productPriceC.text = widget.product.price!.toString();
    productStockC.text = widget.product.stock!.toString();
    super.initState();
  }

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
          'Edit Produk',
          style: appTheme.textTheme.labelLarge!.copyWith(
            color: AppColor.white,
            fontSize: 16,
          ),
        ),
        actions: [
          BlocConsumer<EditProductCubit, EditProductState>(
            listener: (context, state) {
              state.maybeWhen(
                deleted: () {
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Produk berhasil dihapus'),
                    ),
                  );
                },
                orElse: () {},
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                initial: () {
                  return IconButton(
                    onPressed: () {
                      context
                          .read<EditProductCubit>()
                          .deleteProduct(widget.product);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: AppColor.white,
                    ),
                  );
                },
                loading: () {
                  return const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(AppColor.white),
                  );
                },
                orElse: () {
                  return IconButton(
                    onPressed: () {
                      context
                          .read<EditProductCubit>()
                          .deleteProduct(widget.product);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: AppColor.white,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 16.0),
                widget.product.imageUrl != null
                    ? ClipOval(
                        child: Image.network(
                          widget.product.imageUrl!,
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
                      )
                    : BlocBuilder<EditProductCubit, EditProductState>(
                        builder: (context, state) {
                          return Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: AppColor.primary, width: 2),
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
                    log("image selected last result: $_image");
                    await context.read<EditProductCubit>().pickImage();
                  },
                  color: Colors.transparent,
                  textColor: AppColor.primary,
                  label: 'Ubah Gambar',
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
                BlocConsumer<EditProductCubit, EditProductState>(
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
                      imagePicked: (image) {
                        return Button.filled(
                          onPressed: () {
                            log("image selected from screen: $_image");
                            log("image selected from cubit: $image");
                            if (formKey.currentState!.validate()) {
                              context.read<EditProductCubit>().updateProduct(
                                    widget.product.id!,
                                    productNameC.text,
                                    productDescC.text,
                                    int.parse(productPriceC.text),
                                    int.parse(productStockC.text),
                                    image,
                                    widget.product.imageName!,
                                    widget.product.imageUrl!,
                                  );
                            }
                          },
                          label: 'Simpan',
                          color: AppColor.primary,
                        );
                      },
                      orElse: () {
                        return Button.filled(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<EditProductCubit>().updateProduct(
                                    widget.product.id!,
                                    productNameC.text,
                                    productDescC.text,
                                    int.parse(productPriceC.text),
                                    int.parse(productStockC.text),
                                    null,
                                    widget.product.imageName!,
                                    widget.product.imageUrl!,
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
