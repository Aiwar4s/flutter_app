import 'package:flutter/material.dart';
import 'package:flutter_app/entities/user.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class UserRatingDisplay extends StatelessWidget {
  final User user;
  final double itemSize;

  const UserRatingDisplay({super.key, required this.user, this.itemSize = 20.0});

  @override
  Widget build(BuildContext context) {
    return user.averageRating == 0.0
        ? Text(
        'Unrated',
        style: TextStyle(
          fontSize: itemSize * 0.7,
        ),
    )
        : Row(
            children: [
              RatingBarIndicator(
                  rating: user.averageRating!.toDouble(),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.teal,
                  ),
                  itemSize: itemSize,
                  itemCount: 5,
              ),
              Padding(
                padding: EdgeInsets.only(top: itemSize * 0.1),
                child: Text(
                  ' ${user.averageRating!.toStringAsFixed(1)}',
                  style: TextStyle(
                    fontSize: itemSize * 0.7,
                  ),
                ),
              )
            ]
          );
  }
}