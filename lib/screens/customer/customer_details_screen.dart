import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/customer.dart';
import '../../providers/customer_provider.dart';

class CustomerDetailsScreen extends StatelessWidget {
  const CustomerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Customer customer = ModalRoute.of(context)!.settings.arguments as Customer;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Cliente'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/customer/edit', arguments: customer);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Delete'),
                  content: const Text('Are you sure you want to delete this customer?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                Provider.of<CustomerProvider>(context, listen: false).deleteCustomer(customer.id);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${customer.name}', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Document: ${customer.document ?? 'N/A'}'),
            const SizedBox(height: 8),
            Text('Address: ${customer.address}'),
            const SizedBox(height: 8),
            Text('Phone: ${customer.phone}'),
            const SizedBox(height: 8),
            Text('Created At: ${customer.createdAt}'),
            const SizedBox(height: 8),
            Text('Updated At: ${customer.updatedAt}'),
          ],
        ),
      ),
    );
  }
}