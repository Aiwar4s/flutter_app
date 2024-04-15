import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Entities/Trip.dart';
import '../screens/trip/view_trip_screen.dart';

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
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ViewTripScreen(tripId: trip.id)));
          },
          title: Text('${trip.departure} - ${trip.destination}'),
          subtitle: Text("Price: ${trip.price}€, Seats left: ${trip.seats-trip.seatsTaken}\nDate: ${DateFormat("yyyy-MM-dd hh:mm").format(trip.date)}"),
          trailing: const Icon(Icons.arrow_right)
      ),
    );
  }
}