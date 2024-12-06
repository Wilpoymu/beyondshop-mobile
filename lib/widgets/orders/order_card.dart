import 'package:flutter/material.dart';
import '../../models/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Client: ${order.clientId.name}'),
            Text('Total Price: \$${order.totalPrice}'),
            Text('Order Date: ${order.orderDate.toLocal()}'),
            ...order.productsDetails.map((productDetail) => Text(
              'Product: ${productDetail.productId?.name ?? 'Unknown'} - Quantity: ${productDetail.quantity} - Price: \$${productDetail.price}',
            )),
          ],
        ),
      ),
    );
  }
}
