import 'package:smart_parking_customer/page/navigation.dart';
import 'package:smart_parking_customer/services/auth.service.dart';
import 'package:flutter/material.dart';

import '../../models/card.dart';
import '../../models/vehicle_type.dart';
import '../../services/user.service.dart';

class AddCard extends StatefulWidget {
  const AddCard({super.key});

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  final userService = CustomerService();
  final authService = AuthService();
  List<VehicleType> _vehicleTypes = [];
  CardCreate cardCreate = CardCreate();

  @override
  void initState() {
    super.initState();
    getVehicleTypes();
  }

  void getVehicleTypes() async {
    var vehicleTypes = await userService.getVehicleTypes();
    if (mounted) {
      setState(() {
        _vehicleTypes = vehicleTypes;
      });
    }
  }

  void submitCreateCard(context) async {
    await userService.createCard(cardCreate);
    await userService.refreshUser();

    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const MainNavigation()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Thêm thẻ"),
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Loại xe:'),
              DropdownButtonHideUnderline(
                  child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                      ),
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(25),
                      items: _vehicleTypes
                          .map((e) => DropdownMenuItem(
                              value: e.id, child: Text(e.text)))
                          .toList(),
                      onChanged: (s) {
                        cardCreate.vehicleTypeCode = s;
                      })),
              const SizedBox(
                height: 20,
              ),
              const Text('Biển số: '),
              TextField(
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                ),
                onChanged: (t) {
                  cardCreate.licensePlate = t;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Màu sắc: '),
              TextField(
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      borderSide:
                          BorderSide(color: Color(0xFFCACACA), width: 1)),
                ),
                onChanged: (t) {
                  cardCreate.color = t;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(20)),
                    ),
                    onPressed: () {
                      submitCreateCard(context);
                    },
                    child: const Text("THÊM THẺ")),
              )
            ],
          ),
        )
      ]),
    );
  }
}
