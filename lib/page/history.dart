import 'package:eparking_customer/models/reservation.dart';
import 'package:eparking_customer/services/user.service.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'reservation_card.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<Reservation> _reservations = [];
  final CustomerService customerService = CustomerService();
  @override
  void initState() {
    super.initState();
    getReservation();
  }

  void getReservation() async {
    if (mounted) {
      context.loaderOverlay.show();
    }
    var reservations = await customerService.getMyReservations();

    if (mounted) {
      setState(() {
        _reservations = reservations;
      });
      context.loaderOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _reservations.length,
        itemBuilder: ((context, index) =>
            ReservationCard(reservation: _reservations[index])));
  }
}
