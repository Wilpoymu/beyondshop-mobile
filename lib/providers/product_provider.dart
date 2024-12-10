import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products {
    return [..._products];
  }

  Future<void> fetchProducts() async {
    try {
      final responseData = await ApiService.get('products');
      if (responseData is List) {
        final List<Product> loadedProducts = [];
        for (var productData in responseData) {
          loadedProducts.add(Product.fromJson(productData));
        }
        _products = loadedProducts;
        notifyListeners();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      print('Error fetching products: $error');
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final responseData = await ApiService.post('products', product.toJson());
      final newProduct = Product.fromJson(responseData);
      _products.add(newProduct);
      notifyListeners();
    } catch (error) {
      print('Error adding product: $error');
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    try {
      final responseData = await ApiService.put('products/$id', product.toJsonWithId());
      if (responseData.isEmpty) {
        // Handle 204 No Content response
        final prodIndex = _products.indexWhere((prod) => prod.id == id);
        if (prodIndex >= 0) {
          _products[prodIndex] = product;
          notifyListeners();
        }
      } else {
        final updatedProduct = Product.fromJson(responseData);
        final prodIndex = _products.indexWhere((prod) => prod.id == id);
        if (prodIndex >= 0) {
          _products[prodIndex] = updatedProduct;
          notifyListeners();
        }
      }
    } catch (error) {
      print('Error updating product: $error');
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await ApiService.delete('products/$id');
      _products.removeWhere((prod) => prod.id == id);
      notifyListeners();
    } catch (error) {
      print('Error deleting product: $error');
      rethrow;
    }
  }
}
