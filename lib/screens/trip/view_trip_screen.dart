import 'package:flutter/material.dart';
import 'package:flutter_app/Entities/Trip.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:flutter_app/screens/base_screen.dart';
import 'package:flutter_app/screens/trip/trip_chat_screen.dart';
import 'package:flutter_app/widgets/confirm_delete_dialog.dart';
import 'package:flutter_app/widgets/seat_picker_dialog.dart';
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
    double buttonWidth = MediaQuery.of(context).size.width * 0.8;

    return BaseScreen(
        title: 'Trip Details',
        loggedIn: loggedIn,
        child: Scaffold(
            body: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Expanded(
                        child: ListView(
                          children: [
                            Card(
                                child: ListTile(
                                  leading: const Icon(Icons.calendar_today),
                                  title: Text(DateFormat('yyyy-MM-dd HH:mm').format(trip!.date)),
                                )
                            ),
                            Card(
                                child: ListTile(
                                  leading: const Icon(Icons.location_on),
                                  title: Text('${trip?.departure} - ${trip?.destination}'),
                                )
                            ),
                            Card(
                                child: ListTile(
                                  leading: const Icon(Icons.money),
                                  title: Text('Price: ${trip?.price}'),
                                )
                            ),
                            Card(
                                child: ListTile(
                                  leading: const Icon(Icons.people),
                                  title: Text('Seats: ${trip?.seatsTaken}/${trip?.seats}'),
                                )
                            ),
                            Card(
                                child: ListTile(
                                  leading: const Icon(Icons.person),
                                  title: Text('Driver: ${trip?.user?.username}'),
                                )
                            ),
                            Card(
                              child: ListTile(
                                  leading: const Icon(Icons.description),
                                  title: const Text('Description:'),
                                  subtitle: Text(trip!.description)),
                            ),
                            Card(
                                child: Column(
                                    children: [
                                      const ListTile(
                                        leading: Icon(Icons.group),
                                        title: Text('Joined Users:'),
                                      ),
                                      ...trip!.userTrips!.map((userTrip){
                                        return ListTile(
                                          leading: const Icon(Icons.person),
                                          title: Text(userTrip.user.username),
                                          subtitle: Text('Seats: ${userTrip.seats}'),
                                        );
                                      })
                                    ]
                                )
                            ),
                            if(loggedIn && (trip!.userTrips!.any((userTrip) => userTrip.user.id == user.id) || trip!.user!.id == user.id))
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                                  child: ElevatedButton.icon(
                                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TripChatScreen(tripId: trip!.id))),
                                      icon: const Icon(Icons.chat),
                                      label: const Text('Open Chat')
                                  )
                              )
                          ],
                        )
                    ),
                    if(loggedIn && trip != null && trip!.seatsTaken < trip!.seats && !trip!.userTrips!.any((userTrip) => userTrip.user.id == user.id) && trip!.user!.id != user.id)
                      SizedBox(
                        width: buttonWidth,
                        child: ElevatedButton.icon(
                          onPressed: (){
                            showSeatPickerDialog(context, trip!.seats - trip!.seatsTaken).then((seats){
                              if(seats != null) {
                                _joinTrip(seats);
                              }
                            });
                          },
                          icon: const Icon(Icons.person_add),
                          label: const Text('Join Trip'),
                        ),
                      ),
                    if(loggedIn && trip!.userTrips!.any((userTrip) => userTrip.user.id == user.id))
                      SizedBox(
                        width: buttonWidth,
                        child: ElevatedButton.icon(
                          onPressed: (){
                            _leaveTrip();
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.red.withOpacity(0.7)),
                          ),
                          icon: const Icon(Icons.person_remove),
                          label: const Text('Leave Trip'),
                        ),
                      ),
                    if(loggedIn && trip!.user!.id == user.id)
                      SizedBox(
                        width: buttonWidth,
                        child: ElevatedButton.icon(
                          onPressed: (){
                            // TODO: Implement edit trip
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit Trip'),
                        ),
                      ),
                    if(loggedIn && (trip!.user!.id == user.id || user.isAdmin))
                      SizedBox(
                          width: buttonWidth,
                          child: ElevatedButton.icon(
                            onPressed: (){
                              showDialog(context: context, builder: (BuildContext context) {
                                return ConfirmDeleteDialog(
                                    onDelete: (){
                                      _deleteTrip();
                                      Navigator.of(context).pop();
                                    },
                                    type: 'trip');
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.red.withOpacity(0.7)),
                            ),
                            icon: const Icon(Icons.delete),
                            label: const Text('Delete Trip'),
                          )
                      ),
                  ],
                )
            )
        )
    );
  }

  _joinTrip(int seats){
    setState(() {
      _isLoading = true;
    });
    TripService().joinTrip(trip!.id, seats).then((value) {
      setState(() {
        trip = value;
        _isLoading = false;
      });
    }).catchError((e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      TripService().getTrip(trip!.id).then((value) => {
        setState(() {
          trip = value;
          _isLoading = false;
        })
      }).catchError((e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        Navigator.pop(context);
      });
      setState(() {
        _isLoading = false;
      });
    });
  }

  _leaveTrip(){
    setState(() {
      _isLoading = true;
    });
    TripService().leaveTrip(trip!.id).then((value) {
      setState(() {
        trip = value;
        _isLoading = false;
      });
    }).catchError((e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      TripService().getTrip(trip!.id).then((value) => {
        setState(() {
          trip = value;
          _isLoading = false;
        })
      }).catchError((e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        Navigator.pop(context);
      });
    });
  }

  _deleteTrip(){
    setState(() {
      _isLoading = true;
    });
    TripService().deleteTrip(trip!.id).then((value) {
      Navigator.pop(context, 'refresh');
    }).catchError((e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      setState(() {
        _isLoading = false;
      });
    });
  }
}