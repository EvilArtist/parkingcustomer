import 'package:flutter/material.dart';

import '../../models/customer.dart';
import '../../services/user.service.dart';

class ProfilePage extends StatefulWidget {
  Customer customer;
  ProfilePage({super.key, required this.customer});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  void updateProfile() async {
    if (_formKey.currentState!.validate()) {
      // Create a CustomerProfile instance and call the updateProfile method
      final customerProfile = Customer(
        id: widget.customer.id,
        userNo: widget.customer.userNo,
        userName: widget.customer.userNo,
        email: 'john.doe@example.com',
        phoneNumber: '+1234567890',
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        company: 'ABC Company',
      );

      CustomerService customerService = CustomerService();
      customerService.updateProfile(customerProfile);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Họ'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập họ';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Tên'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(labelText: 'Tên'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  updateProfile();
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}