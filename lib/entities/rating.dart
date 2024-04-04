class Rating{
  final int id;
  final int stars;
  final String comment;

  const Rating({
    required this.id,
    required this.stars,
    required this.comment,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      stars: json['stars'],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stars': stars,
      'comment': comment,
    };
  }
}