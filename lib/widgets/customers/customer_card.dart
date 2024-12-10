
import 'package:flutter/material.dart';
import '../../models/customer.dart';

class CustomerCard extends StatelessWidget {
  final Customer customer;

  const CustomerCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            customer.name.isNotEmpty ? customer.name.substring(0, 1).toUpperCase() : 'U',
            style: const TextStyle(fontSize: 24),
          ),
        ),
        title: Text(customer.name.isNotEmpty ? customer.name : 'Unknown'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Document: ${customer.document ?? 'N/A'}'),
            Text('Address: ${customer.address}'),
            Text('Phone: ${customer.phone}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.pushNamed(context, '/customer/edit', arguments: customer);
          },
        ),
      ),
    );
  }
}