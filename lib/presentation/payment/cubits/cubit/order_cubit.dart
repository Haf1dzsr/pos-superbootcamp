import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pos_superbootcamp/data/datasources/order_remote_datasource.dart';
import 'package:pos_superbootcamp/data/models/order_model.dart';

part 'order_state.dart';
part 'order_cubit.freezed.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(const OrderState.initial());

  Future<void> createOrder(
      {required OrderModel order, required String uid}) async {
    emit(const OrderState.loading());

    final result = await OrderRemoteDatasource.instance.createOrder(
      order: order,
      userId: uid,
    );

    result.fold(
      (l) => emit(OrderState.error(l)),
      (r) => emit(const OrderState.success()),
    );
  }
}
