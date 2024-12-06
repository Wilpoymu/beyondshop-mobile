import 'package:flutter/material.dart';
import '../../models/order.dart';
import '../../models/customer.dart';
import '../../models/product.dart' as product_model; // Use alias for product
import '../../services/api_service.dart';

class OrderFormScreen extends StatefulWidget {
  final Order? order;

  const OrderFormScreen({super.key, this.order});

  @override
  _OrderFormScreenState createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  Customer? _selectedCustomer;
  List<ProductDetail> _productsDetails = [];
  double _totalPrice = 0.0;
  List<Customer> _customers = [];
  List<product_model.Product> _products = [];
  product_model.Product? _selectedProduct;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
    _fetchProducts();
    if (widget.order != null) {
      _initializeForm(widget.order!);
    }
  }

  void _initializeForm(Order order) {
    _selectedCustomer = _customers.firstWhere((customer) => customer.id == order.clientId.id, orElse: () => Customer(
      id: order.clientId.id,
      document: order.clientId.document,
      name: order.clientId.name,
      address: order.clientId.address,
      phone: order.clientId.phone,
      createdAt: order.clientId.createdAt,
      updatedAt: order.clientId.updatedAt,
    ));
    _productsDetails = order.productsDetails;
    _totalPrice = order.totalPrice;
  }

  Future<void> _fetchCustomers() async {
    final data = await ApiService.get('customers');
    setState(() {
      _customers = data.map<Customer>((json) => Customer.fromJson(json)).toList();
      if (widget.order != null) {
        _initializeForm(widget.order!);
      }
    });
  }

  Future<void> _fetchProducts() async {
    final data = await ApiService.get('products');
    setState(() {
      _products = data.map<product_model.Product>((json) => product_model.Product.fromJson(json)).toList();
    });
  }

  void _addProduct() {
    if (_selectedProduct != null && _quantity > 0) {
      final productDetail = ProductDetail(
        productId: _selectedProduct,
        quantity: _quantity,
        price: _selectedProduct!.price * _quantity,
        unitPrice: _selectedProduct!.price,
        id: '',
      );
      setState(() {
        _productsDetails.add(productDetail);
        _totalPrice += productDetail.price;
      });
    }
  }

  void _removeProduct(ProductDetail productDetail) {
    setState(() {
      _productsDetails.remove(productDetail);
      _totalPrice -= productDetail.price;
    });
  }

  Future<void> _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      final orderData = {
        'clientId': _selectedCustomer!.id,
        'productsDetails': _productsDetails.map((pd) => {
          'productId': pd.productId!.id,
          'quantity': pd.quantity,
          'price': pd.price,
          'unitPrice': pd.unitPrice,
        }).toList(),
      };

      try {
        if (widget.order == null) {
          await ApiService.post('orders', orderData);
        } else {
          await ApiService.put('orders/${widget.order!.id}', orderData);
        }
        Navigator.of(context).pushReplacementNamed('/orders'); // Navigate back to orders screen
      } catch (error) {
        // Handle error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.order == null ? 'Create Order' : 'Edit Order'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<Customer>(
                  value: _selectedCustomer,
                  items: _customers
                      .map((customer) => DropdownMenuItem(
                            value: customer,
                            child: Text(customer.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCustomer = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Select Customer'),
                  validator: (value) =>
                      value == null ? 'Please select a customer' : null,
                ),
                DropdownButtonFormField<product_model.Product>(
                  value: _selectedProduct,
                  items: _products
                      .map((product) => DropdownMenuItem(
                            value: product,
                            child: Text(product.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedProduct = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Select Product'),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                  initialValue: '1',
                  onChanged: (value) {
                    setState(() {
                      _quantity = int.parse(value);
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: _addProduct,
                  child: const Text('Add Product'),
                ),
                SizedBox(
                  height: 200, // Set a fixed height for the ListView
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _productsDetails.length,
                    itemBuilder: (ctx, i) => ListTile(
                      title: Text(_productsDetails[i].productId!.name),
                      subtitle: Text('Quantity: ${_productsDetails[i].quantity} - Price: \$${_productsDetails[i].price}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeProduct(_productsDetails[i]),
                      ),
                    ),
                  ),
                ),
                Text('Total Price: \$$_totalPrice'),
                ElevatedButton(
                  onPressed: _submitOrder,
                  child: const Text('Submit Order'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
