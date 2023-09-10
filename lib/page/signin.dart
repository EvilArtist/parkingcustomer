import 'package:smart_parking_customer/page/navigation.dart';
import 'package:smart_parking_customer/page/signup.dart';
import 'package:smart_parking_customer/services/auth.service.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.phoneNumber = "", this.fromOTPPage = false});
  final String phoneNumber;
  final bool fromOTPPage;
  @override
  State<LoginPage> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<LoginPage> {
  bool loading = false;
  final emailcon = TextEditingController();
  final passwordcon = TextEditingController();

  final gradient =
      const LinearGradient(colors: [Colors.lightBlue, Colors.purpleAccent]);

  void login() async {
    AuthService authService = AuthService();

    try {
      context.loaderOverlay.show();
      await authService.login(
          emailOrPhone: emailcon.text, password: passwordcon.text);
      if (!mounted) return;
      context.loaderOverlay.hide();
      await Navigator.push(context,
          MaterialPageRoute(builder: (context) => const MainNavigation()));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    emailcon.text = widget.phoneNumber;
    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 1.0,
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
                                "Đăng nhập",
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Email hoặc số điện thoại:'),
                                        TextField(
                                          keyboardType: TextInputType.text,
                                          controller: emailcon,
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20, 10, 20, 10),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25))),
                                          ),
                                        ),
                                        widget.fromOTPPage
                                            ? const Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.check_circle,
                                                          color: Colors.green),
                                                      Text(
                                                          'Số điện thoại đã được xác minh'),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(
                                                height: 20,
                                              ),
                                        const Text('Password:'),
                                        TextField(
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          controller: passwordcon,
                                          obscureText: true,
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20, 10, 20, 10),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25))),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                            onPressed: () {},
                                            child: const Text(
                                              "Forgot password?",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.all(20)),
                                          ),
                                          child: const Text("Login"),
                                          onPressed: () {
                                            login();
                                          }),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Chưa có tài khoản",
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
                                                          const SignupPage()));
                                            },
                                            child: const Text("Đăng ký")),
                                      ],
                                    ),
                                  ],
                                ),
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
          ),
        ));
  }
}
