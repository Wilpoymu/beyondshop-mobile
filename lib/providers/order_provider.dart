import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/api_service.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  Future<void> fetchOrders() async {
    try {
      final data = await ApiService.get('orders');
      _orders = data.map<Order>((order) => Order.fromJson(order)).toList();
      notifyListeners();
    } catch (error) {
      throw Exception('Failed to load orders');
    }
  }
}
