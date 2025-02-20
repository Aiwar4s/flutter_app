import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/providers/city_provider.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:flutter_app/screens/base_screen.dart';
import 'package:flutter_app/screens/trip/view_trip_screen.dart';
import 'package:flutter_app/widgets/city_picker.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';

import '../../Entities/Trip.dart';
import '../../services/trip_service.dart';

class CreateTripScreen extends StatefulWidget{
  const CreateTripScreen({super.key});

  @override
  _CreateTripScreenState createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  List<String> cities = [];
  String departureCity = '';
  String destinationCity = '';
  DateTime selectedDateTime = DateTime.now().add(const Duration(hours: 2));
  int seats = 1;
  num price = 0;
  String description = '';
  String dateTimeError = '';
  String priceError = '';

  bool _isLoading = true;

  List<bool> isFieldValid = [false, false];

  @override
  void initState() {
    super.initState();
    loadCities();
  }

  void loadCities() async {
    await Provider.of<CityProvider>(context, listen: false).loadCities();
    cities = Provider
        .of<CityProvider>(context, listen: false)
        .cities;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final CurrencyTextInputFormatter priceFormatter = CurrencyTextInputFormatter(
        locale: 'lt_LT',
        decimalDigits: 0
    );

    return BaseScreen(
        title: 'New Trip',
        loggedIn: Provider.of<UserProvider>(context).user != null,
        child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Form(
                  key: _formKey,
                  child: Column(
                      children: [
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Departure City:')
                        ),
                        CityPicker(
                            onCitySelected: (city) {
                              setState(() {
                                departureCity = city;
                              });
                            },
                            onValidated: (isValid){
                              isFieldValid[0] = isValid;
                            },
                            excludedCity: destinationCity,
                          validate: true,
                        ),
                        const SizedBox(height: 10),
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Destination City:')
                        ),
                        CityPicker(
                            onCitySelected: (city) {
                              setState(() {
                                destinationCity = city;
                              });
                            },
                            onValidated: (isValid) {
                              isFieldValid[1] = isValid;
                            },
                            excludedCity: departureCity,
                          validate: true,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text('Date and Time: '),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  shadowColor: Colors.grey,
                                ),
                                onPressed: () {
                                  _selectDateTime(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${selectedDateTime.year}-${selectedDateTime.month}-${selectedDateTime.day} ${selectedDateTime.hour}:${selectedDateTime.minute}',
                                          style: const TextStyle(color: Colors.black),
                                        )
                                    ),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if(dateTimeError.isNotEmpty)
                          Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(dateTimeError, style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12
                              ))
                          ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.always,
                                  decoration: const InputDecoration(
                                    labelText: 'Price',
                                  ),
                                  initialValue: '0 EUR',
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[priceFormatter],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      priceError = 'Please enter a price';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                  setState(() {
                                    price = priceFormatter.getUnformattedValue();
                                    if(price >= 100){
                                      priceError = 'Price should be less than 100 EUR';
                                    } else {
                                      priceError = '';

                                    }
                                  });
                                  }
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DropdownButtonFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Seats',
                                ),
                                value: seats,
                                items: List<int>.generate(10, (i) => (i+1)).map((int value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value.toString()),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    seats=value as int;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please enter the number of seats';
                                  }
                                  return null;
                                },
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Description',
                          ),
                          maxLines: 3,
                          onChanged: (value) {
                            description = value;
                          },
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                            icon: const Icon(Icons.add),
                            onPressed: (departureCity == '' || destinationCity == '' || isFieldValid.contains(false) || dateTimeError != '' || priceError != '') ? null : (){
                              if(_formKey.currentState!.validate()){
                                _createTrip();
                              }
                            },
                            label: const Text('Create Trip'),
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width * 0.9, 50)),
                          )
                        ),
                        if(priceError != '')
                          Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(priceError, style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12
                              )
                              )
                          )
                      ]
                  )
              ),
            )
        )
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showOmniDateTimePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now().add(const Duration(hours: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDateTime && picked.isAfter(DateTime.now().add(const Duration(hours: 1)))){
      setState(() {
        selectedDateTime = DateTime(
            picked.year, picked.month, picked.day, picked.hour,
            picked.minute);
        dateTimeError = '';
      });
    } else if(!selectedDateTime.isAfter(DateTime.now().add(const Duration(hours: 1)))){
      setState(() {
        dateTimeError = 'Selected time should be at least 1 hour from now';
      });
    }
  }

  void _createTrip() async {
    setState(() {
      _isLoading = true;
    });

    Trip trip = Trip(
      id: -1,
      departure: departureCity,
      destination: destinationCity,
      date: selectedDateTime,
      seats: seats,
      price: price,
      seatsTaken: 0,
      description: description
    );

    try{
      Trip newTrip = await TripService().createTrip(trip);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ViewTripScreen(tripId: newTrip.id)));
    } catch (e){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to create trip')));
    } finally {
      setState(() {
        isFieldValid = [false, false];
        _isLoading = false;
      });
    }
  }
}