import 'package:flutter/material.dart';
import '../../models/order.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Client: ${order.clientId.name}'),
            Text('Total Price: \$${order.totalPrice}'),
            Text('Order Date: ${order.orderDate.toLocal()}'),
            const Text('Products:'),
            ...order.productsDetails.map((productDetail) => ListTile(
              title: Text(productDetail.productId?.name ?? 'Unknown'),
              subtitle: Text('Quantity: ${productDetail.quantity} - Price: \$${productDetail.price}'),
            )),
          ],
        ),
      ),
    );
  }
}
