import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:pos_superbootcamp/data/models/order_model.dart';

class OrderRemoteDatasource {
  static final OrderRemoteDatasource instance =
      OrderRemoteDatasource._internal();
  OrderRemoteDatasource._internal();
  factory OrderRemoteDatasource() => instance;

  Future<Either<String, OrderModel>> createOrder({
    required OrderModel order,
    required String userId,
  }) async {
    final orderCol = FirebaseFirestore.instance.collection('orders');
    try {
      final doc = orderCol.doc();
      final orderToAdd = OrderModel(
        orderId: doc.id,
        userId: userId,
        products: order.products,
        biayaAdmin: order.biayaAdmin,
        orderStatus: order.orderStatus,
        paymentMethod: order.paymentMethod,
        priceTotal: order.priceTotal,
        createdAt: order.createdAt,
      );
      await doc.set(orderToAdd.toJson());
      return right(orderToAdd);
    } catch (e) {
      return left(e.toString());
    }
  }

  Stream<List<OrderModel>> getOrdersByUserId({required String uid}) {
    final orders = FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderModel.fromJson(doc.data()))
          .toList();
    });
    return orders;
  }
}
