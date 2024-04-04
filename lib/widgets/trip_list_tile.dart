import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Entities/Trip.dart';

class TripTile extends StatelessWidget{
  final Trip trip;

  const TripTile({super.key, required this.trip});

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
          onTap: () { //TODO: Implement onTap
          },
          title: Text('${trip.departure} - ${trip.destination}'),
          subtitle: Text("Price: ${trip.price}€, Seats: ${trip.seats}\nDate: ${DateFormat("yyyy-MM-dd hh:mm").format(trip.date)}"),
          trailing: const Icon(Icons.arrow_right)
      ),
    );
  }
}