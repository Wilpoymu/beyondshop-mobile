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
              Navigator.pop(context); // Cierra el drawer
              await authProvider.logout(context);
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Bienvenido,',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontSize: 32,
                              color: Colors.white,
                            ),
                      ),
                      if (userData != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          userData['username'] ?? 'Usuario',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          userData['email'] ?? '',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontSize: 18,
                                color: Colors.white70,
                              ),
                        ),
                      ],
                      const SizedBox(height: 32),
                      // Removed the ElevatedButton here
                    ],
                  ),
                ),
              ),
              const CustomFooter(),
            ],
          ),
        ],
      ),
    );
  }
}
