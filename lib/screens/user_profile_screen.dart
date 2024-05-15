import 'package:flutter/material.dart';
import 'package:flutter_app/screens/base_screen.dart';
import 'package:flutter_app/widgets/user_rating_display.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../entities/user.dart';
import '../entities/user_stats.dart';
import '../providers/user_provider.dart';
import '../services/profile_service.dart';
import '../services/rating_service.dart';

class UserProfileScreen extends StatefulWidget {
  final User user;
  const UserProfileScreen({super.key, required this.user});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isLoading = true;
  UserStats? userStats;

  @override
  void initState() {
    super.initState();
    _loadUserStats();
  }

  Future<void> _loadUserStats() async {
    try{
      userStats = await ProfileService().getUserStats(widget.user.id);
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
    final User? currentUser = Provider.of<UserProvider>(context).user;
    bool loggedIn = currentUser != null;
    return BaseScreen(
        title: 'User Profile',
        loggedIn: loggedIn,
        child: _isLoading? const Center(child: CircularProgressIndicator()) :Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
              children: [
                Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(
                          widget.user.username,
                          style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold
                          )
                      ),
                    )
                ),
                Card(
                    child: ListTile(
                      title: UserRatingDisplay(user: widget.user, itemSize: 45),
                    )
                ),
                Card(
                    child: ListTile(
                      leading: const Icon(Icons.star),
                      title: Text(
                          'Reviews: ${userStats!.ratings.length}',
                          style: const TextStyle(
                              fontSize: 24
                          )
                      ),
                    )
                ),
                Card(
                    child: ListTile(
                      leading: const Icon(Icons.directions_car_outlined),
                      title: Text(
                          'Trips joined: ${userStats!.userTripsCount}',
                          style: const TextStyle(
                              fontSize: 24
                          )
                      ),
                    )
                ),
                Card(
                    child: ListTile(
                      leading: const Icon(Icons.directions_car),
                      title: Text(
                          'Trips created: ${userStats!.tripsCount}',
                          style: const TextStyle(
                              fontSize: 24
                          )
                      ),
                    )
                ),
                Card(
                  child: Column(
                    children: [
                      const ListTile(
                        leading: Icon(Icons.reviews),
                        title: Text(
                          'Reviews',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ),
                      ...userStats!.ratings.map((rating){
                        return ListTile(
                          title: RatingBarIndicator(
                            rating: rating.stars.toDouble(),
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.teal,
                            ),
                            itemCount: 5,
                            itemSize: 30.0,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('${rating.user.username} '),
                                  Text(' ${DateFormat('yyyy-MM-dd').format(rating.createdAt)}'),
                                ]
                              ),
                            if (rating.comment.isNotEmpty) Text(rating.comment)
                            ]
                          ),
                          trailing: IconButton(
                            icon: Icon(
                                Icons.delete,
                                color: Theme.of(context).colorScheme.error
                            ),
                            onPressed: () async {
                              try{
                                await RatingService().deleteRating(rating.user.id, rating.id);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Review deleted')));
                                _loadUserStats();
                              } catch(e){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                              }
                            },
                          ),
                          );
                      })
                    ]
                  )
                )
              ]
          )
        )
    );
  }
}