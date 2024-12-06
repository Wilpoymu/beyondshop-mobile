import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/api_service.dart';

class CustomerProvider with ChangeNotifier {
  List<Customer> _customers = [];
  bool _isLoading = false;

  List<Customer> get customers => _customers;
  bool get isLoading => _isLoading;

  Future<void> fetchCustomers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('customers');
      _customers = (response as List).map((data) => Customer.fromJson(data)).toList();
    } catch (e) {
      print('Error fetching customers: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCustomer(Customer customer) async {
    try {
      final response = await ApiService.post('customers', customer.toJson());
      _customers.add(Customer.fromJson(response));
      notifyListeners();
    } catch (e) {
      print('Error adding customer: $e');
    }
  }

  Future<void> updateCustomer(Customer customer) async {
    try {
      await ApiService.put('customers/${customer.id}', customer.toJson());
      final index = _customers.indexWhere((c) => c.id == customer.id);
      if (index != -1) {
        _customers[index] = customer;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating customer: $e');
    }
  }

  Future<void> deleteCustomer(String id) async {
    try {
      await ApiService.delete('customers/$id');
      _customers.removeWhere((customer) => customer.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting customer: $e');
    }
  }
}