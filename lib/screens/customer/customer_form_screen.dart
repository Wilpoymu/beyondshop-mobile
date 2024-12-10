
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/customer.dart';
import '../../providers/customer_provider.dart';

class CustomerFormScreen extends StatefulWidget {
  final Customer? customer;

  const CustomerFormScreen({super.key, this.customer});

  @override
  _CustomerFormScreenState createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends State<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _address;
  late String _phone;
  int? _document;

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _name = widget.customer!.name;
      _address = widget.customer!.address;
      _phone = widget.customer!.phone;
      _document = widget.customer!.document;
    } else {
      _name = '';
      _address = '';
      _phone = '';
      _document = null;
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final customerProvider = Provider.of<CustomerProvider>(context, listen: false);

      if (widget.customer != null) {
        final updatedCustomer = Customer(
          id: widget.customer!.id,
          name: _name,
          address: _address,
          phone: _phone,
          document: _document,
          createdAt: widget.customer!.createdAt,
          updatedAt: DateTime.now(),
        );
        customerProvider.updateCustomer(updatedCustomer);
      } else {
        final newCustomer = Customer(
          id: DateTime.now().toString(),
          name: _name,
          address: _address,
          phone: _phone,
          document: _document,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        customerProvider.addCustomer(newCustomer);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer != null ? 'Edit Customer' : 'Create Customer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                textInputAction: TextInputAction.next,
                onSaved: (value) {
                  _name = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a name.';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _address,
                decoration: const InputDecoration(labelText: 'Address'),
                textInputAction: TextInputAction.next,
                onSaved: (value) {
                  _address = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide an address.';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _phone,
                decoration: const InputDecoration(labelText: 'Phone'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                onSaved: (value) {
                  _phone = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a phone number.';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _document?.toString(),
                decoration: const InputDecoration(labelText: 'Document'),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _document = int.tryParse(value!);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a document number.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}