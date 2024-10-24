import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/common/custom_drawer.dart';
import '../widgets/common/custom_footer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userData = authProvider.userData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bienvenido,',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  if (userData != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      userData['name'] ?? 'Usuario',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userData['email'] ?? '',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ],
              ),
            ),
          ),
          CustomFooter(),
        ],
      ),
    );
  }
}