import 'package:flutter/material.dart';
import 'package:flutter_app/Entities/Trip.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:flutter_app/screens/base_screen.dart';
import 'package:flutter_app/services/trip_service.dart';
import 'package:flutter_app/widgets/trip_list_tile.dart';
import 'package:provider/provider.dart';

class CreatedTripsScreen extends StatefulWidget{
  const CreatedTripsScreen({super.key});

  @override
  _CreatedTripsScreenState createState() => _CreatedTripsScreenState();
}

class _CreatedTripsScreenState extends State<CreatedTripsScreen> with WidgetsBindingObserver{
  List<Trip> trips = [];

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose(){
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    if(state == AppLifecycleState.resumed){
      _refreshTrips();
    }
  }

  Future<void> _refreshTrips() async{
    var newTrips = await TripService().getCreatedTrips();
    setState(() {
      trips = newTrips;
    });
  }

  @override
  Widget build(BuildContext context){
    final loggedIn = Provider.of<UserProvider>(context).user != null;
    return BaseScreen(
        title: 'My Trips',
        loggedIn: loggedIn,
        child: Consumer<UserProvider>(
            builder: (context, userProvider, child){
              return Scaffold(
                body: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: RefreshIndicator(
                        onRefresh: () async{
                          await _refreshTrips();
                        },
                        child: FutureBuilder<List<Trip>>(
                            future: TripService().getCreatedTrips(),
                            builder: (context, snapshot){
                              if(snapshot.connectionState == ConnectionState.waiting){
                                return const Center(child: CircularProgressIndicator());
                              } else if(snapshot.hasError){
                                return const Center(child: Text('Error: Failed to load trips'));
                              } else {
                                trips= snapshot.data!;
                                return ListView.builder(
                                    itemCount: trips.length,
                                    itemBuilder: (context, index){
                                      final trip = trips[index];
                                      return TripTile(trip: trip, onRefresh: _refreshTrips);
                                    }
                                );
                              }
                            }
                        )
                    )
                ),
              );
            }
        )
    );
  }
}
