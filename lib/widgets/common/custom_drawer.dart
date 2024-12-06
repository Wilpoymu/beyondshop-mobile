import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/customer_provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userData = authProvider.userData;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Text(
                (userData?['name'] as String?)?.substring(0, 1).toUpperCase() ??
                    'U',
                style: const TextStyle(fontSize: 24),
              ),
            ),
            accountName: Text(userData?['name'] ?? 'Usuario'),
            accountEmail: Text(userData?['email'] ?? ''),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.inventory),
                  title: const Text('Productos'),
                  onTap: () {
                    Navigator.pop(context); // Cierra el drawer
                    Navigator.pushNamed(context, '/products');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: const Text('Órdenes'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/orders');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('Clientes'),
                  onTap: () {
                    Navigator.pop(context); // Cierra el drawer
                    Provider.of<CustomerProvider>(context, listen: false)
                        .fetchCustomers();
                    Navigator.pushNamed(context, '/customer/list');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Tomar Foto y Ubicación'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/photo-location');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Cerrar Sesión'),
                  onTap: () async {
                    Navigator.pop(context); // Cierra el drawer
                    await authProvider.logout(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
