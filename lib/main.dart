import 'package:beyondshop/screens/products/products_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/order_provider.dart'; // Import the OrderProvider
import 'providers/customer_provider.dart'; // Import the CustomerProvider
import 'models/product.dart' as product_model; // Import the Product model
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/products/product_detail_screen.dart';
import 'screens/products/product_search_screen.dart';
import 'screens/products/product_form_screen.dart';
import 'screens/orders/orders_list_screen.dart'; // Import the OrdersListScreen
import 'models/order.dart'; // Import the Order model
import 'screens/orders/order_detail_screen.dart'; // Import the OrderDetailScreen
import 'screens/orders/order_form_screen.dart'; // Import the OrderFormScreen
import 'screens/customer/customer_list_screen.dart';
import 'screens/customer/customer_details_screen.dart';
import 'screens/customer/customer_create_screen.dart';
import 'screens/customer/customer_edit_screen.dart';
import 'screens/customer/customer_form_screen.dart';
import 'models/customer.dart'; // Import the Customer model
import 'screens/photo_location_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()), // Add OrderProvider
        ChangeNotifierProvider(create: (_) => CustomerProvider()), // Add CustomerProvider
      ],
      child: MaterialApp(
        title: 'Beyond Shop',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            elevation: 1,
          ),
        ),
        // Definimos las rutas iniciales
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthenticationWrapper(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/products': (context) => const ProductsListScreen(),
          '/product-detail': (context) => ProductDetailScreen(product: ModalRoute.of(context)!.settings.arguments as product_model.Product),
          '/product-search': (context) => const ProductSearchScreen(),
          '/product-form': (context) => const ProductFormScreen(),
          '/orders': (context) => const OrdersListScreen(), // Add OrdersListScreen route
          '/order-detail': (context) => OrderDetailScreen(ModalRoute.of(context)!.settings.arguments as Order),
          '/order-form': (context) => const OrderFormScreen(), // Add OrderFormScreen route
          '/customer/list': (context) => const CustomerListScreen(),
          '/customer/details': (context) => const CustomerDetailsScreen(),
          '/customer/create': (context) => const CustomerFormScreen(),
          '/customer/edit': (context) => CustomerFormScreen(customer: ModalRoute.of(context)!.settings.arguments as Customer),
          '/photo-location': (context) => PhotoLocationScreen(),
        },
      ),
    );
  }
}

// Wrapper para manejar la autenticación
class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({super.key});

  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  Future<bool>? _authStatusFuture;

  @override
  void initState() {
    super.initState();
    _authStatusFuture = Provider.of<AuthProvider>(context, listen: false).checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _authStatusFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Error al verificar el estado de autenticación')),
          );
        }
        return snapshot.data == true ? const HomeScreen() : const LoginScreen();
      },
    );
  }
}