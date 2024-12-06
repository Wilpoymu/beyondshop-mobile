
import 'package:flutter/material.dart';

class CustomerEditScreen extends StatefulWidget {
  const CustomerEditScreen({super.key});

  @override
  _CustomerEditScreenState createState() => _CustomerEditScreenState();
}

class _CustomerEditScreenState extends State<CustomerEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _updateCustomer() async {
    if (!_formKey.currentState!.validate()) return;

    // Update customer logic here

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final int customerId = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateCustomer,
                child: const Text('Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}