import 'package:my_movies/widget/rating_button.dart';

class Film {
  final String title;
  FilmRating rating;

  Film({
    required this.title,
    this.rating = FilmRating.none,
  });

  Film copyWith({
    String? title,
    FilmRating? rating,
  }) {
    return Film(
      title: title ?? this.title,
      rating: rating ?? this.rating,
    );
  }
}
