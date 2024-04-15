class UserTrip{
  final int id;
  final int seats;
  final int tripId;
  final String userId;

  UserTrip({
    required this.id,
    required this.seats,
    required this.tripId,
    required this.userId,
  });

  factory UserTrip.fromJson(Map<String, dynamic> json){
    return UserTrip(
      id: json['id'],
      seats: json['seats'],
      tripId: json['tripId'],
      userId: json['userId'],
    );
  }
}