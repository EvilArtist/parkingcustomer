import 'package:eparking_customer/models/country.dart';
import 'package:eparking_customer/models/parking.dart';
import 'package:eparking_customer/services/country.service.dart';
import 'package:eparking_customer/services/reservation.service.dart';
import 'package:eparking_customer/services/user.service.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../models/customer.dart';

class ParkingSearchPage extends StatefulWidget {
  const ParkingSearchPage({super.key});
  // final Account account;
  @override
  State<ParkingSearchPage> createState() => _ParkingSearchPageState();
}

class _ParkingSearchPageState extends State<ParkingSearchPage> {
  List<Province> _provinces = [];
  List<District> _districts = [];
  List<Ward> _wards = [];
  Province? selectedProvince;
  District? selectedDistrict;
  late Customer customer;
  Ward? selectedWard;
  final CountryService countryService = CountryService();
  final CustomerService customerService = CustomerService();
  final ReservationService reservationService = ReservationService();
  List<ParkingCapacity> parkingCapacities = [];
  Future getAllProvinces() async {
    if (mounted) {
      context.loaderOverlay.show();
    }
    var provinces = await countryService.getAllProvinces();
    if (provinces.isNotEmpty) {
      await getAllDistrict(provinces[0].code);
    }
    if (mounted) {
      setState(() {
        _provinces = provinces;
        selectedProvince = _provinces[0];
      });
    }
  }

  void getCustomer() async {
    customer = await customerService.getUserInfo();
  }

  Future getAllDistrict(provinceCode) async {
    if (mounted) {
      context.loaderOverlay.show();
    }
    var districts =
        await countryService.getAllDistrictsByProvince(provinceCode);
    if (districts.isNotEmpty) {
      getAllWards(districts[0].code);
    }
    if (mounted) {
      setState(() {
        _districts = districts;
        _wards = [];
        selectedDistrict = _districts[0];
      });
    }
  }

  Future getAllWards(districtCode) async {
    if (mounted) {
      context.loaderOverlay.show();
    }
    var wards = await countryService.getAllWardsByProvince(districtCode);
    if (mounted) {
      setState(() {
        _wards = wards;
        if (_wards.isNotEmpty) {
          selectedWard = _wards[0];
        }
      });

      context.loaderOverlay.hide();
    }
  }

  search() async {
    context.loaderOverlay.show();
    try {
      final data = await reservationService.searchParking(
          province: selectedProvince!.fullName,
          ward: selectedWard!.fullName,
          district: selectedDistrict!.fullName,
          vehicleType: 'XE_MAY');
      if (mounted) {
        context.loaderOverlay.hide();
        setState(() {
          parkingCapacities = data;
        });
      }
    } catch (e) {
      if (mounted) {
        context.loaderOverlay.hide();
        setState(() {
          parkingCapacities = [];
        });
      }
    }
  }

  reserve(String parkingId, String cardCode, Duration timeComming) async {
    if (mounted) {
      context.loaderOverlay.show();
    }
    await reservationService.reserve(parkingId, cardCode, timeComming);
    if (mounted) {
      context.loaderOverlay.hide();
    }
  }

  displayCardSelector(ParkingCapacity selectedParking) {
    List<String> allowVehicleTypes = [];
    for (var c in selectedParking.capacities!) {
      for (var v in c.vehicleTypes) {
        allowVehicleTypes.add(v.id);
      }
    }
    final listCard = customer.subscriptions
        .where((s) => allowVehicleTypes.any((c) => c == s.vehicleTypeCode))
        .toList();
    if (listCard.isEmpty) {
      return;
    }
    if (listCard.length == 1) {
      displayTimeSelector(selectedParking.id, listCard[0].subscriptionId!);
    }
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 500,
        child: Column(
          children: [
            Text(
              "Chọn xe",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Expanded(
                child: ListView.builder(
              itemCount: listCard.length,
              itemBuilder: (context, index) => ListTile(
                subtitle: Text(
                  listCard[index].vehicleType!,
                ),
                title: Text(
                  listCard[index].licensePlate!,
                ),
                leading: const Icon(Icons.motorcycle),
                onTap: () {
                  Navigator.pop(context);
                  displayTimeSelector(
                      selectedParking.id, listCard[index].subscriptionId!);
                },
              ),
            ))
          ],
        ),
      ),
    );
  }

  displayTimeSelector(String selectedParkingId, String subscriptionId) {
    final timesSelect = [
      {'value': const Duration(minutes: 30), 'display': '30 phút'},
      {'value': const Duration(hours: 1), 'display': '1 giờ'},
      {
        'value': const Duration(hours: 1, minutes: 30),
        'display': '1 giờ 30 phút'
      },
      {'value': const Duration(hours: 2), 'display': '2 giờ'},
      {'value': const Duration(hours: 3), 'display': '3 giờ'}
    ];
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 500,
        child: Column(
          children: [
            Text(
              "Tôi sẽ đến trong:",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: timesSelect.length,
                    itemBuilder: (context, index) {
                      final time = timesSelect[index];
                      return ListTile(
                        subtitle: Text(
                          time['display'].toString(),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          reserve(selectedParkingId, subscriptionId,
                              time['value'] as Duration);
                        },
                      );
                    }))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getAllProvinces();
    getCustomer();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(children: [
        FittedBox(
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      "Smart Parking",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Tỉnh/Thành phố",
                      )),
                  DropdownButtonFormField(
                      items: _provinces
                          .map((e) => DropdownMenuItem(
                              value: e, child: Text(e.fullName)))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          getAllDistrict(value.code);
                        }
                        selectedProvince = value;
                      },
                      value: selectedProvince),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Quận/huyện",
                      )),
                  DropdownButtonFormField(
                    items: _districts
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e.fullName)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        getAllWards(value.code);
                      }
                    },
                    value: selectedDistrict,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Quận/huyện",
                      )),
                  DropdownButtonFormField(
                    items: _wards
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e.fullName)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedWard = value;
                      });
                    },
                    value: selectedWard,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                          onPressed: search,
                          child: const Padding(
                              padding: EdgeInsets.all(12),
                              child: Text('Tìm kiếm'))))
                ],
              ),
            ),
          ),
        ),
        Expanded(
            child: ListView.builder(
          itemCount: parkingCapacities.length,
          itemBuilder: (context, index) {
            final parking = parkingCapacities[index];
            final available = parking.capacities![0].available ?? 0;
            Color color = Colors.green.shade400;
            if (available <= 3) {
              color = Colors.red.shade700;
            } else if (available <= 20) {
              color = Colors.amber.shade700;
            }
            return Card(
                elevation: 2,
                color: available <= 3 ? const Color(0xFFC2C2C2) : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                borderOnForeground: true,
                margin:
                    const EdgeInsets.symmetric(horizontal: 1.0, vertical: 6.0),
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFF2F2F2)),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: available <= 3
                          ? const Color(0xFFC2C2C2)
                          : Colors.white,
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(parking.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(parking.address?.fullAddress ?? ''),
                                  ],
                                )),
                                const SizedBox(width: 20),
                                Column(children: [
                                  Text(
                                    available.toString(),
                                    style: TextStyle(color: color),
                                  ),
                                  const Text("Slot")
                                ])
                              ]),
                          Row(
                            children: [
                              ElevatedButton(
                                child: const Text("Đặt chỗ"),
                                onPressed: () {
                                  displayCardSelector(parking);
                                },
                              )
                            ],
                          )
                        ]))));
          },
        ))
      ])
    ]);
  }
}
