import 'package:flutter/material.dart';
import 'package:flutter_app/Entities/Trip.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:flutter_app/screens/base_screen.dart';
import 'package:flutter_app/screens/trip/trip_chat_screen.dart';
import 'package:flutter_app/services/rating_service.dart';
import 'package:flutter_app/widgets/confirm_delete_dialog.dart';
import 'package:flutter_app/widgets/seat_picker_dialog.dart';
import 'package:flutter_app/widgets/user_rating_display.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../entities/rating.dart';
import '../../entities/user.dart';
import '../../services/trip_service.dart';
import '../../widgets/rating_dialog.dart';
import '../user_profile_screen.dart';
import 'edit_trip_screen.dart';

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
                : RefreshIndicator(
                onRefresh: _loadTrip,
              child: Padding(
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
                                    title: Text('Price: ${trip?.price}€'),
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
                                    title: Row(
                                      children: [
                                        const Text('Driver: '),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => UserProfileScreen(user: trip!.user!)
                                              )
                                            );
                                          },
                                          child: Text(
                                            trip!.user!.username,
                                            style: const TextStyle(
                                              color: Colors.teal,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 18
                                            )
                                          )
                                        )
                                      ]
                                    ),
                                    subtitle: UserRatingDisplay(user: trip!.user!),
                                    trailing: loggedIn && _userJoined() && trip!.date.isBefore(DateTime.now())
                                        ? ElevatedButton.icon(
                                      onPressed: () => {
                                        RatingService().getMyRating(trip!.user!.id).then((existingRating) {
                                          showRatingDialog(
                                              context,
                                              'driver',
                                                  (rating, comment){
                                                existingRating != null
                                                    ? _updateRating(rating, comment, existingRating, trip!.user!)
                                                    : _createRating(rating, comment, trip!.user!);
                                              },
                                                  () => _deleteRating(trip!.user!, existingRating!),
                                              existingRating
                                          );
                                        }).catchError((e){
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                        })
                                      },
                                      icon: const Icon(Icons.star),
                                      label: const Text('Rate'),
                                    ) : null,
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
                                            title: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => UserProfileScreen(user: userTrip.user))
                                                  );
                                                },
                                                child: Text(
                                                    userTrip.user.username,
                                                    style: const TextStyle(
                                                        color: Colors.teal,
                                                        fontWeight: FontWeight.w900,
                                                        fontSize: 18
                                                    )
                                                )
                                            ),
                                            subtitle: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Seats: ${userTrip.seats}'),
                                                  UserRatingDisplay(user: userTrip.user),
                                                ]
                                            ),
                                            trailing: loggedIn && _userCreated() && trip!.date.isBefore(DateTime.now())
                                                ? ElevatedButton.icon(
                                              onPressed: () => {
                                                RatingService().getMyRating(userTrip.user.id).then((existingRating) {
                                                  showRatingDialog(
                                                      context,
                                                      'passenger',
                                                          (rating, comment){
                                                        existingRating != null
                                                            ? _updateRating(rating, comment, existingRating, userTrip.user)
                                                            : _createRating(rating, comment, userTrip.user);
                                                      },
                                                          () => _deleteRating(userTrip.user, existingRating!),
                                                      existingRating
                                                  );
                                                }).catchError((e){
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                                })
                                              },
                                              icon: const Icon(Icons.star),
                                              label: const Text('Rate'),
                                            ) : null,
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
                      if(loggedIn && trip!.userTrips!.any((userTrip) => userTrip.user.id == user.id) && trip!.date.isAfter(DateTime.now()))
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
                      if(loggedIn && trip!.user!.id == user.id && trip!.date.isAfter(DateTime.now()))
                        SizedBox(
                          width: buttonWidth,
                          child: ElevatedButton.icon(
                            onPressed: () async{
                              final updatedTrip = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => EditTripScreen(trip: trip!))
                              );
                              if(updatedTrip != null){
                                setState(() {
                                  trip = updatedTrip;
                                });
                              }
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit Trip'),
                          ),
                        ),
                      if(loggedIn && (trip!.user!.id == user.id || user.isAdmin) && trip!.date.isAfter(DateTime.now()))
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

  _userJoined(){
    return trip!.userTrips!.any((userTrip) => userTrip.user.id == Provider.of<UserProvider>(context).user!.id);
  }

  _userCreated(){
    return trip!.user!.id == Provider.of<UserProvider>(context).user!.id;
  }

  _createRating(int stars, String comment, User ratedUser){
    setState(() {
      _isLoading = true;
    });
    Rating rating = Rating(
        id: 0,
        stars: stars,
        comment: comment,
        user: Provider.of<UserProvider>(context, listen: false).user!,
        ratedUser: ratedUser,
        createdAt: DateTime.now()
    );
    RatingService().createRating(ratedUser.id, rating).then((value) {
      _loadTrip();
    }).catchError((e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      setState(() {
        _isLoading = false;
      });
    });
  }

  _updateRating(int stars, String comment, Rating rating, User ratedUser){
    setState(() {
      _isLoading = true;
    });
    rating.stars = stars;
    rating.comment = comment;
    RatingService().updateRating(ratedUser.id, rating).then((value) {
      _loadTrip(); // Refresh the screen
    }).catchError((e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      setState(() {
        _isLoading = false;
      });
    });
  }

  _deleteRating(User ratedUser, Rating rating){
    setState(() {
      _isLoading = true;
    });
    RatingService().deleteRating(ratedUser.id, rating.id).then((value) {
      _loadTrip(); // Refresh the screen
    }).catchError((e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      setState(() {
        _isLoading = false;
      });
    });
  }
}