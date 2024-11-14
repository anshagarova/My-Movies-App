import 'package:my_movies/widget/rating_button.dart';

class Film {
  final String title;
  FilmRating rating;


  Film({
    required this.title,
    this.rating = FilmRating.none,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'rating': rating.toString().split('.').last,
  };

  factory Film.fromJson(Map<String, dynamic> json) {
    try {
      return Film(
        title: json['title'] as String,
        rating: FilmRating.values.firstWhere(
              (e) => e.toString().split('.').last == json['rating'],
          orElse: () => FilmRating.none,
        ),
      );
    } catch (e) {
      return Film(title: json['title'] as String, rating: FilmRating.none);
    }
  }
}