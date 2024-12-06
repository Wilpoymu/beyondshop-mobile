import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order.dart';
import '../../providers/order_provider.dart';
import '../../screens/orders/order_form_screen.dart';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order ID: ${order.id.substring(order.id.length - 4)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => OrderFormScreen(order: order),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Confirm Delete'),
                              content: const Text('Are you sure you want to delete this order?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await Provider.of<OrderProvider>(context, listen: false).deleteOrder(order.id);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
