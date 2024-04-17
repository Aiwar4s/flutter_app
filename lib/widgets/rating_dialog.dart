import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../entities/rating.dart';

void showRatingDialog(BuildContext context, String userType, Function(int, String) onRatingUpdate, Function onDelete, [Rating? existingRating]){
  int rating = existingRating?.stars ?? 0;
  String comment = existingRating?.comment ?? '';

  showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('Rate the $userType'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Theme(
                  data: ThemeData(
                    highlightColor: Colors.teal,
                    splashColor: Colors.teal,
                  ),
                  child: RatingBar.builder(
                    initialRating: rating.toDouble(),
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.teal,
                    ),
                    onRatingUpdate: (value) {
                      rating = value.toInt();
                    },
                  )
              ),
              const SizedBox(height: 40),
              TextField(
                controller: TextEditingController(text: comment),
                decoration: const InputDecoration(
                  hintText: 'Comment (optional)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => comment = value,
                maxLength: 250,
              )
            ]
          ),
          actions: <Widget> [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if(existingRating != null)
                  TextButton(
                    child: const Text('Delete'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red.withOpacity(0.7),
                    ),
                    onPressed: () {
                      onDelete();
                      Navigator.of(context).pop();
                    },
                  ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: const Text('Submit'),
                      onPressed: () {
                        onRatingUpdate(rating, comment);
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                )
              ]
            ),
          ]
        );
      }
  );
}