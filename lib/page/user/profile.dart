import 'package:flutter/material.dart';

import '../../models/customer.dart';
import '../../services/user.service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.customer});
  final Customer customer;

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
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
                controller: _phoneController,
                readOnly: (widget.customer.phoneNumber != null && widget.customer.phoneNumber!.isNotEmpty),
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
                validator: (value) {
                  String pattern = r'/^\d{9-11}$/';
                  RegExp regex = RegExp(pattern);
                  if (value != null && !regex.hasMatch(value)) {
                    return 'Vui lòng nhập đúng định dạng. VD 0123456789';
                  } 
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                readOnly: (widget.customer.email != null && widget.customer.email!.isNotEmpty),
                decoration: const InputDecoration(labelText: 'Email:'),
                validator: (value) {
                  String pattern = r'/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/';
                  RegExp regex = RegExp(pattern);
                  if (value != null && !regex.hasMatch(value)) {
                    return 'Vui lòng nhập đúng định dạng. VD anhnv@espace.edu.vn';
                  } 
                  return null;
                },
              ),
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(labelText: 'Tên'),
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
