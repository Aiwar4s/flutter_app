import 'package:flutter/material.dart';
import 'package:flutter_app/Entities/Trip.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:flutter_app/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../entities/user.dart';
import '../../services/trip_service.dart';

class ViewTripScreen extends StatefulWidget {
  final int tripId;

  const ViewTripScreen({super.key, required this.tripId});

  @override
  _ViewTripScreenState createState() => _ViewTripScreenState();
}

class _ViewTripScreenState extends State<ViewTripScreen> {
  bool _isLoading = true;
  Trip? trip;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTrip();
    });
  }

  Future<void> _loadTrip() async {
    try{
      trip = await TripService().getTrip(widget.tripId);
    } catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      Navigator.pop(context);
    } finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).user;
    bool loggedIn = user != null;

    return Scaffold(
      appBar: CustomAppBar(title: 'Trip Details', loggedIn: loggedIn),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Text(DateFormat('yyyy-MM-dd HH:mm').format(trip!.date)),
              const SizedBox(height: 10),
              Text('${trip!.departure} - ${trip!.destination}'),
              const SizedBox(height: 10),
              Text('Price: ${trip!.price}'),
              const SizedBox(height: 10),
              Text('Seats: ${trip!.seatsTaken}/${trip!.seats}'),
              const SizedBox(height: 10),
              Text('Driver: ${trip!.user!.name}'),
            ],
          )
      )
    );
  }
}