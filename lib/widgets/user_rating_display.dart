import 'package:flutter/material.dart';
import 'package:flutter_app/entities/user.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class UserRatingDisplay extends StatelessWidget {
  final User user;

  const UserRatingDisplay({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return user.averageRating == 0.0
        ? const Text('Unrated')
        : Row(
            children: [
              Text('${user.averageRating!.toStringAsFixed(1)} '),
              RatingBarIndicator(
                  rating: user.averageRating!.toDouble(),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.teal,
                  ),
                  itemSize: 20.0,
                  itemCount: 5,
              )
            ]
          );
  }
}