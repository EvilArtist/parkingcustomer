import 'package:smart_parking_customer/page/signin.dart';
import 'package:smart_parking_customer/services/auth.service.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'otpinput.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool loading = false;
  final phoneNumberController = TextEditingController();
  final passwordcon = TextEditingController();
  final gradient =
      const LinearGradient(colors: [Colors.lightBlue, Colors.purpleAccent]);

  void signup() async {
    AuthService authService = AuthService();
    try {
      context.loaderOverlay.show();
      await authService.signup(
          phoneNumber: phoneNumberController.text, password: passwordcon.text);
      if (!mounted) return;
      context.loaderOverlay.hide();
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  OTPInputPage(phoneNumber: phoneNumberController.text)));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
          child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Color.fromARGB(0xFF, 0xEC, 0xF0, 0xF1)),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 15,
                ),
                const Center(
                  child: Text(
                    "Smart Parking",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    width: MediaQuery.of(context).size.height * 0.4,
                    height: MediaQuery.of(context).size.height * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "Đăng ký",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          ),
                          const SizedBox(
                            height: 45,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Số điện thoại:'),
                                    TextField(
                                      keyboardType: TextInputType.phone,
                                      controller: phoneNumberController,
                                      decoration: const InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(20, 10, 20, 10),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25))),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text('Mật khẩu:'),
                                    TextField(
                                      keyboardType: TextInputType.emailAddress,
                                      controller: passwordcon,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(20, 10, 20, 10),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25))),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.all(20)),
                                      ),
                                      child: const Text("Đăng ký"),
                                      onPressed: () {
                                        signup();
                                      }),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Đã có tài khoản",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginPage()));
                                        },
                                        child: const Text("Đăng nhập")),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
