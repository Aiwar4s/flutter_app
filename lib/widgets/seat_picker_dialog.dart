import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

Future<int?> showSeatPickerDialog(BuildContext context, int maxSeats) async {
  int selectedSeats = 1;
  return showDialog<int>(
    context: context,
    builder: (BuildContext context){
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState){
          return AlertDialog(
            title: const Text('Select number of seats'),
            content: NumberPicker(
              value: selectedSeats,
              minValue: 1,
              maxValue: maxSeats,
              onChanged: (value) => setState(() => selectedSeats = value),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(selectedSeats),
                child: const Text('Ok'),
              ),
            ],
          );
        }
      );
    }
  );
}