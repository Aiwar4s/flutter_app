import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../Entities/Trip.dart';
import '../screens/trip/view_trip_screen.dart';

class TripTile extends StatelessWidget{
  final Trip trip;
  final VoidCallback onRefresh;
  final bool showRating;

  const TripTile({super.key, required this.trip, required this.onRefresh, this.showRating = true});

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Container(
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
            leading: const Icon(Icons.assistant_navigation),
            title: Text(
                '${trip.departure} - ${trip.destination}',
                style: const TextStyle(
                    color: Colors.teal,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                )
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person),
                    Text("Seats left: ${trip.seats-trip.seatsTaken}/${trip.seats}"),
                  ],
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    const Icon(Icons.calendar_month),
                    Text(" ${DateFormat("yyyy-MM-dd hh:mm").format(trip.date)}")
                  ]
                ),
                const SizedBox(height: 5.0),
                if(trip.driverRating > 0 && showRating)
                RatingBarIndicator(
                  rating: trip.driverRating.toDouble(),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.teal,
                  ),
                  itemSize: 20.0,
                  itemCount: 5,
                )
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    '${trip.price}€',
                    style: const TextStyle(
                        color: Colors.teal,
                        fontSize: 20.0
                    )
                ),
                const Icon(Icons.arrow_right)
              ],
            )
        ),
      )
    );
  }
}