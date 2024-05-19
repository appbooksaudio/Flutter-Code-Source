import 'package:ejazapp/data/models/book.dart';

enum OrderStatus { pending, onDelivery, success, cancelled }

class Order {
  final int? id;
  final Book? book;
  final DateTime? orderTime;
  OrderStatus orderStatus;

  Order({
    this.id,
    this.book,
    this.orderTime,
    this.orderStatus = OrderStatus.pending,
  });
}

List<Order> mockOrderList = [];
List<Order> mockPastOrderList = [];
