import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:smart_parking_customer/page/reservation_card.dart';
import 'package:smart_parking_customer/page/user/add_card.dart';
import 'package:smart_parking_customer/services/auth.service.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:fast_rsa/fast_rsa.dart';

import '../models/card.dart';
import '../models/customer.dart';
import '../services/user.service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

const codeLength = 16;
const keyLength = 4;
const String prefix = 'QR_';
const prefKey = 'MY_CARD_CODE';

class _MyHomePageState extends State<MyHomePage> {
  String _myQRCode = getRandomString(codeLength);
  final EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  final authService = AuthService();
  final userService = CustomerService();
  Customer _customer =
      Customer(id: 'id', userNo: '', userName: '', firstName: '', lastName: '');
  List<dynamic> _cardList = [];

  CardDetails? _currentCard;
  void _updateDisplayTime() async {
    var cardList = [];
    // final format = DateFormat('dd/MM/yyyy');
    for (var card in _customer.subscriptions) {
      var rsa = await encodeQR(card.code!);

      cardList.add({
        'rsa': rsa,
        'presentedCard': card,
      });
    }
    cardList.add(
        {'rsa': '', 'vehicle': '', 'licensePlate': '', 'presentedCard': null});
    if (mounted) {
      setState(() {
        _cardList = cardList;
        _currentCard = _cardList[0]['presentedCard'];
      });
    }
  }

  @override
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    context.loaderOverlay.show();
    final customer = await userService.getUserInfo();
    final String code = await encryptedSharedPreferences.getString(prefKey);
    var myReservations = await userService.getMyReservations();
    _customer.setReservations(myReservations);
    setState(() {
      _customer = customer;
    });
    if (code.isNotEmpty && code.length == codeLength) {
      setState(() {
        _myQRCode = code;
      });
    } else {
      _myQRCode = getRandomString(codeLength);
      await encryptedSharedPreferences.setString(prefKey, _myQRCode);
    }
    _updateDisplayTime();
    _timer = Timer.periodic(
        const Duration(minutes: 5), (Timer timer) => _updateDisplayTime());
    if (context.mounted) {
      context.loaderOverlay.hide();
    }
  }

  encodeQR(String qrCode) async {
    DateTime now = DateTime.now();
    String privateKey =
        '${formatNumber(now.hour, 2)}${formatNumber(now.minute, 2)}';
    String date =
        '${formatNumber(now.day, 2)}${formatNumber(now.month, 2)}${formatNumber(now.year, 4)}';
    String concatString = mixString(qrCode, privateKey);
    String rsa = await RSA.hash(concatString + date, Hash.SHA256);
    return prefix +
        qrCode +
        privateKey +
        rsa.substring(0, 32 - concatString.length);
  }

  formatNumber(int number, int length) {
    return number.toString().padLeft(length, '0');
  }

  mixString(String qrCode, String privateKey) {
    if (qrCode.length < 16) {
      return mixString(_myQRCode, privateKey);
    }
    String concatString = prefix +
        qrCode.substring(0, 4) +
        privateKey.substring(0, 1) +
        qrCode.substring(4, 8) +
        privateKey.substring(1, 2) +
        qrCode.substring(8, 12) +
        privateKey.substring(2, 3) +
        qrCode.substring(12, 16) +
        privateKey.substring(3, 4);
    return concatString;
  }

  late Timer _timer;
  List<String> list = <String>['00', '01'];
  @override
  _MyHomePageState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void extendSubscription() {}

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return ChangeNotifierProvider(
        create: (context) => _customer,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 35, 0, 35),
            child: Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 35, right: 35, top: 10, bottom: 10),
                    child: Row(children: <Widget>[
                      Expanded(
                        child: Text(
                            '${_customer.firstName} ${_customer.lastName}',
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                      Expanded(
                          child: Text(
                              '${(_customer.wallet == null ? '' : _customer.wallet!.amount)} ₫',
                              textAlign: TextAlign.right,
                              style: Theme.of(context).textTheme.titleMedium))
                    ]),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                      (_currentCard != null
                          ? (_currentCard?.licensePlate ?? '')
                          : ''),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 10,
                  ),
                  CarouselSlider(
                      options: CarouselOptions(
                        height: 0.75 * MediaQuery.of(context).size.width,
                        viewportFraction: 0.75,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentCard = _cardList[index]['presentedCard'];
                          });
                        },
                      ),
                      items: _cardList.map((item) {
                        String itemRsa = item['rsa'];
                        return itemRsa.isEmpty
                            ? Padding(
                                padding: EdgeInsets.only(
                                    left: 0.025 *
                                        MediaQuery.of(context).size.width,
                                    right: 0.025 *
                                        MediaQuery.of(context).size.width),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        elevation: MaterialStateProperty.all<double>(
                                            0),
                                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                            const EdgeInsets.all(0)),
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                            Colors.white),
                                        shadowColor: MaterialStateProperty.all(
                                            Colors.black),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20.0),
                                                side: const BorderSide(color: Color(0x3FCACACA))))),
                                    child: const Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'THÊM THẺ MỚI',
                                          style: TextStyle(fontSize: 20),
                                        )),
                                    onPressed: () async {
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AddCard()));
                                    }))
                            : Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                color: const Color.fromARGB(255, 255, 255, 255),
                                elevation: 0,
                                child: Container(
                                  width:
                                      0.8 * MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xFFF2F2F2)),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                      padding: const EdgeInsets.all(40),
                                      child: Column(children: [
                                        QrImageView(data: itemRsa, version: 5),
                                      ])),
                                ));
                      }).toList()),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Column(children: [
                            Icon(
                              Icons.history_rounded,
                              size: 36,
                            ),
                            Text("Tra cứu")
                          ]),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Column(children: [
                            Icon(
                              Icons.payment_rounded,
                              size: 36,
                            ),
                            Text("Gia hạn")
                          ]),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Column(children: [
                            Icon(
                              Icons.lock,
                              size: 36,
                            ),
                            Text("Khoá thẻ")
                          ]),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: Consumer<Customer>(
                          builder: (context, customer, child) =>
                              ListView.builder(
                                  itemCount:
                                      min(customer.reservations.length, 1),
                                  itemBuilder: ((context, index) =>
                                      ReservationCard(
                                          reservation:
                                              customer.reservations[index])))))
                ],
              ),
            )));
  }
}
