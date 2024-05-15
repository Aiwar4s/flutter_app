import 'package:flutter/material.dart';
import 'package:flutter_app/Entities/Trip.dart';
import 'package:flutter_app/services/trip_service.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class EditTripScreen extends StatefulWidget {
  final Trip trip;

  const EditTripScreen({super.key, required this.trip});

  @override
  _EditTripScreenState createState() => _EditTripScreenState();
}

class _EditTripScreenState extends State<EditTripScreen> {
  late DateTime selectedDateTime;
  late String description;
  late TextEditingController descriptionController;

  String dateTimeError = '';

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.trip.date;
    description = widget.trip.description;
    descriptionController = TextEditingController(text: description);
    descriptionController.selection = TextSelection.fromPosition(
      TextPosition(offset: descriptionController.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Trip'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text('Date and Time: '),
                        ),
                        ElevatedButton(
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
                      ],
                    ),
                    if(dateTimeError.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          dateTimeError,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 50),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      onChanged: (value) {
                        description = value;
                      },
                    ),
                  ],
                ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.cancel),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.red.withOpacity(0.7)),
                        ),
                        label: const Text('Cancel'),
                      )
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _updateTrip();
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Update Trip'),
                      )
                  ),
                ]
            ),
          ]
        )
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showOmniDateTimePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now().add(const Duration(hours: 2)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDateTime && picked.isAfter(DateTime.now().add(const Duration(hours: 1)))){
      setState(() {
        selectedDateTime = picked;
        dateTimeError = '';
      });
    } else {
      setState(() {
        dateTimeError = 'Selected time should be at least 1 hour from now';
      });
    }
  }

  void _updateTrip() {
    widget.trip.date = selectedDateTime;
    widget.trip.description = description;

    TripService().editTrip(widget.trip).then((updatedTrip) {
      Navigator.of(context).pop(updatedTrip);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update trip'),
        ),
      );
    });

    // Call the function to update the trip in the backend
    // updateTrip(widget.trip);
  }
}