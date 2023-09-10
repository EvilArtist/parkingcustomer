import 'package:smart_parking_customer/page/signin.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pinput/pinput.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/auth.service.dart';

class OTPInputPage extends StatefulWidget {
  const OTPInputPage({super.key, required this.phoneNumber});
  final String phoneNumber;
  @override
  State<OTPInputPage> createState() => _OTPInputState();
}

class _OTPInputState extends State<OTPInputPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final controller = TextEditingController();
  final focusNode = FocusNode();

  bool isOPTCompleted = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void verify() async {
    AuthService authService = AuthService();
    try {
      context.loaderOverlay.show();
      final verified = await authService.confirmPhoneNumber(
          token: controller.text, phoneNumber: widget.phoneNumber);
      if (!mounted) return;
      context.loaderOverlay.hide();
      if (!verified) {
        controller.clear();
      } else {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage(
                      phoneNumber: widget.phoneNumber,
                      fromOTPPage: true,
                    )));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    const borderColor = Color.fromRGBO(30, 60, 87, 1);
    const gradient =
        LinearGradient(colors: [Colors.lightBlue, Colors.purpleAccent]);
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: GoogleFonts.poppins(
        fontSize: 22,
        color: const Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: const BoxDecoration(),
    );

    final cursor = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 56,
          height: 3,
          decoration: BoxDecoration(
            color: borderColor,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
    final preFilledWidget = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 56,
          height: 3,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Color.fromARGB(0xFF, 0xEC, 0xF0, 0xF1)),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.only(
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
                            "Nhập mã xác nhận:",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Pinput(
                            length: 6,
                            pinAnimationType: PinAnimationType.scale,
                            controller: controller,
                            focusNode: focusNode,
                            androidSmsAutofillMethod:
                                AndroidSmsAutofillMethod.smsRetrieverApi,
                            useNativeKeyboard: true,
                            keyboardType: TextInputType.number,
                            defaultPinTheme: defaultPinTheme,
                            showCursor: true,
                            cursor: cursor,
                            preFilledWidget: preFilledWidget,
                            onCompleted: (s) {
                              setState(() {
                                isOPTCompleted = true;
                              });
                            },
                            onChanged: (value) => {
                              if (value.length < 6)
                                {
                                  setState(() {
                                    isOPTCompleted = false;
                                  })
                                }
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 8,
                              ),
                              const Text(
                                "Chưa nhận được tin nhắn",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: const Text("Gửi lại")),
                            ],
                          ),
                          const Expanded(
                            child: SizedBox.expand(),
                          ),
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(20)),
                                ),
                                onPressed: isOPTCompleted ? verify : null,
                                child: const Text("Xác nhận"),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(30),
          //   child: Align(
          //     alignment: Alignment.bottomCenter,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         const Text(
          //           "Đã có tài khoản",
          //           style: TextStyle(
          //             color: Colors.black,
          //           ),
          //         ),
          //         TextButton(
          //             onPressed: () {
          //               Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                       builder: (context) => const LoginPage()));
          //             },
          //             child: const Text("Đăng nhập")),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
