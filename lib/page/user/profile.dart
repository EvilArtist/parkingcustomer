import 'package:flutter/material.dart';
import 'package:smart_parking_customer/page/splash_screen.dart';

import '../../models/customer.dart';
import '../../services/user.service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

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
  Customer? _customer;
  CustomerService customerService = CustomerService();
  void updateProfile() async {
    if (_formKey.currentState!.validate()) {
      // Create a CustomerProfile instance and call the updateProfile method
      final customerProfile = Customer(
        id: _customer!.id,
        userNo: _customer!.userNo,
        userName: _customer!.userNo,
        email: _customer!.email ?? _emailController.text,
        phoneNumber: _customer!.phoneNumber ?? _phoneController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        company: _companyController.text,
      );

      Customer updatedCustomer =
          await customerService.updateProfile(customerProfile);
      if (mounted) {
        setState(() {
          _customer = updatedCustomer;
        });
      }
    }
  }

  InputDecoration getBoxDecorator() {
    return const InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))));
  }

  @override
  void initState() {
    super.initState();
    getCustomer();
  }

  void getCustomer() async {
    var customer = await customerService.getUserInfo();
    if (mounted) {
      setState(() {
        _customer = customer;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (_customer == null) {
      return const SplashScreen();
    }
    SizedBox marginText = const SizedBox(height: 16.0);
    SizedBox marginLabel = const SizedBox(height: 4.0);
    _companyController.value = TextEditingValue(text: _customer!.company ?? '');
    _firstNameController.value = TextEditingValue(text: _customer!.firstName);
    _lastNameController.value = TextEditingValue(text: _customer!.lastName);
    _companyController.value = TextEditingValue(text: _customer!.company ?? '');
    _phoneController.value =
        TextEditingValue(text: _customer!.phoneNumber ?? '');
    _emailController.value = TextEditingValue(text: _customer!.email ?? '');
    return Card(
        child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
                title: const Text("Thông tin cá nhân"),
                backgroundColor: Colors.white,
                collapsedShape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Họ'),
                          marginLabel,
                          TextFormField(
                            controller: _firstNameController,
                            decoration: getBoxDecorator(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập họ';
                              }
                              return null;
                            },
                          ),
                          marginText,
                          const Text('Tên'),
                          marginLabel,
                          TextFormField(
                            controller: _lastNameController,
                            decoration: getBoxDecorator(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập tên';
                              }
                              return null;
                            },
                          ),
                          marginText,
                          const Text('Số điện thoại'),
                          marginLabel,
                          TextFormField(
                            controller: _phoneController,
                            readOnly: (_customer!.phoneNumber != null &&
                                _customer!.phoneNumber!.isNotEmpty),
                            decoration: getBoxDecorator(),
                            validator: (value) {
                              String pattern = r'^\d{9,11}$';
                              RegExp regex = RegExp(pattern);
                              if (value != null && !regex.hasMatch(value)) {
                                return 'Vui lòng nhập đúng định dạng. VD 0123456789';
                              }
                              return null;
                            },
                          ),
                          marginText,
                          const Text('Email'),
                          marginLabel,
                          TextFormField(
                            controller: _emailController,
                            readOnly: (_customer!.email != null &&
                                _customer!.email!.isNotEmpty),
                            decoration: getBoxDecorator(),
                            validator: (value) {
                              String pattern =
                                  r'^[\w-\.]+@([\w-]+\.){0,2}[\w-]{2,4}$';
                              RegExp regex = RegExp(pattern);
                              if (value != null && !regex.hasMatch(value)) {
                                return 'Vui lòng nhập đúng định dạng. VD anhnv@espace.edu.vn';
                              }
                              return null;
                            },
                          ),
                          marginText,
                          const Text('Công ty'),
                          marginLabel,
                          TextFormField(
                            controller: _companyController,
                            decoration: getBoxDecorator(),
                          ),
                          const SizedBox(height: 16.0),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                updateProfile();
                              },
                              child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text('Cập nhật')),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ])));
  }
}
