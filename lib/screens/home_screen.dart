import 'package:flutter/material.dart';
import 'package:flutter_app/Entities/Trip.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:flutter_app/screens/base_screen.dart';
import 'package:flutter_app/screens/trip/create_trip_screen.dart';
import 'package:flutter_app/services/trip_service.dart';
import 'package:flutter_app/widgets/city_picker.dart';
import 'package:flutter_app/widgets/trip_list_tile.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{
  List<Trip> trips = [];
  bool _isLoading = false;
  String? departure;
  String? destination;

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshTrips();
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
    setState(() {
      _isLoading = true;
    });
    var newTrips = await TripService().getTrips(departure, destination);
    setState(() {
      trips = newTrips;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context){
    final loggedIn = Provider.of<UserProvider>(context).user != null;
    return BaseScreen(
        title: 'Trips',
        loggedIn: loggedIn,
        child: Consumer<UserProvider>(
            builder: (context, userProvider, child){
              return Scaffold(
                  floatingActionButton: loggedIn ? FloatingActionButton(
                    shape: const CircleBorder(),
                    onPressed: () async{
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateTripScreen())).then((_){
                        _refreshTrips();
                      });
                    },
                    child: const Icon(Icons.add),
                  ) : null,
                  body: Column(
                      children: [
                        CityPicker(
                          onCitySelected: (city) {
                              setState(() {
                                departure = city;
                              });
                              _refreshTrips();
                            },
                            onValidated: (isValid) {},
                            excludedCity: destination ?? '',
                            type: 'departure',
                        ),
                        CityPicker(
                          onCitySelected: (city) {
                            setState((){
                              destination = city;
                            });
                            _refreshTrips();
                          },
                          onValidated: (isValid) {},
                          excludedCity: departure ?? '',
                          type: 'destination',
                        ),
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: _refreshTrips,
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: _isLoading ?
                                const Center(child: CircularProgressIndicator()) :
                                Stack(
                                  children: [
                                    ListView.builder(
                                      itemCount: trips.length,
                                      itemBuilder: (context, index){
                                        final trip = trips[index];
                                        return TripTile(trip: trip, onRefresh: _refreshTrips);
                                      },
                                    ),
                                    if(trips.isEmpty) const Center(child: Text('No trips found'))
                                  ],
                                )
                            ),
                          ),
                        ),
                      ]
                  )
              );
            }
        )
    );
  }
}
