
import 'package:flutter/material.dart';

class CustomerCreateScreen extends StatefulWidget {
  const CustomerCreateScreen({super.key});

  @override
  _CustomerCreateScreenState createState() => _CustomerCreateScreenState();
}

class _CustomerCreateScreenState extends State<CustomerCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveCustomer() async {
    if (!_formKey.currentState!.validate()) return;

    // Save customer logic here

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Cliente'),
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
                onPressed: _saveCustomer,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}