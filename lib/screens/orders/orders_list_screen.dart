import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/orders/order_card.dart';
import 'order_detail_screen.dart'; // Import the OrderDetailScreen

class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/home');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('/order-form');
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<OrderProvider>(context, listen: false).fetchOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return const Center(child: Text('An error occurred!'));
          } else {
            return Consumer<OrderProvider>(
              builder: (ctx, orderProvider, child) => ListView.builder(
                itemCount: orderProvider.orders.length,
                itemBuilder: (ctx, i) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OrderDetailScreen(orderProvider.orders[i]),
                      ),
                    );
                  },
                  child: OrderCard(orderProvider.orders[i]),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
