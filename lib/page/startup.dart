import 'dart:async';

import 'package:eparking_customer/page/navigation.dart';
import 'package:eparking_customer/page/signin.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../models/login.dart';
import '../services/auth.service.dart';

class Startup extends StatefulWidget {
  const Startup({super.key});

  @override
  State<Startup> createState() => _StartupState();
}

class _StartupState extends State<Startup> {
  final Stream<Account> user = (() {
    late final StreamController<Account> controller;
    controller = StreamController<Account>(
      onListen: () async {
        AuthService authService = AuthService();
        Account account = await authService.loadAccount();
        controller.add(account);
        await controller.close();
      },
    );
    return controller.stream;
  })();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'EParking Customer Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF206412)),
          useMaterial3: true,
        ),
        home: LoaderOverlay(
            child: StreamBuilder<Account>(
          stream: user,
          builder: (BuildContext context, AsyncSnapshot<Account> snapshot) {
            if (snapshot.hasError) {
              return const LoginPage();
            } else {
              if (snapshot.data == null) {
                return const LoginPage();
              } else if (snapshot.data?.expiredDate != null &&
                  snapshot.data!.expiredDate.isBefore(DateTime.now())) {
                return const LoginPage();
              } else {
                return const MainNavigation();
              }
            }
          },
        )));
  }
}
