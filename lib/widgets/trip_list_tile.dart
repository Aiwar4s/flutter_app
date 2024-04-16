import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Entities/Trip.dart';
import '../screens/trip/view_trip_screen.dart';

class TripTile extends StatelessWidget{
  final Trip trip;
  final VoidCallback onRefresh;

  const TripTile({super.key, required this.trip, required this.onRefresh});

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
          onTap: () async {
            final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ViewTripScreen(tripId: trip.id)));
            if(result == 'refresh'){
              onRefresh();
            }
          },
          title: Text('${trip.departure} - ${trip.destination}'),
          subtitle: Text("Price: ${trip.price}€, Seats left: ${trip.seats-trip.seatsTaken}\nDate: ${DateFormat("yyyy-MM-dd hh:mm").format(trip.date)}"),
          trailing: const Icon(Icons.arrow_right)
      ),
    );
  }
}