import 'package:eparking_customer/services/reservation.service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/reservation.dart';

class ReservationCard extends StatelessWidget {
  final Reservation reservation;
  ReservationCard({super.key, required this.reservation});
  final ReservationService reservationService = ReservationService();
  cancleReservation(Reservation reservation) async {
    await reservationService.cancel(reservation.id);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${reservation.vehicleType!.text}: ${reservation.licensePlate}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            reservation.parking!.name!,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          Text(
            reservation.parking!.fullAddress!,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('kk:mm dd/MM/yyy')
                    .format(reservation.reservationTime!.toLocal()),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              reservation.status == 'Created'
                  ? ElevatedButton(
                      style: Theme.of(context).elevatedButtonTheme.style,
                      child: const Text("Huỷ bỏ"),
                      onPressed: () => cancleReservation(reservation),
                    )
                  : Text(reservation.status!)
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    ));
  }
}
