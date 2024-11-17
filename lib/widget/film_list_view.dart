import 'package:flutter/material.dart';
import 'package:my_movies/widget/add_film_page.dart';
import 'package:my_movies/model/film.dart';
import 'package:my_movies/widget/rating_button.dart';

class FilmListView extends StatelessWidget {
  final List<Film> films;
  final Function(int, FilmRating) updateRating;
  final Function(Film, int?) onSaveFilm;

  const FilmListView({
    super.key,
    required this.films,
    required this.updateRating,
    required this.onSaveFilm,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: films.length,
      itemBuilder: (context, index) {
        final film = films[index];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Film title
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddFilmPage(
                            onSaveFilm: onSaveFilm,
                            existingFilm: film,
                            filmIndex: index,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      film.title,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                // Rating buttons
                Row(
                  children: [
                    RatingButton(
                      onRatingChanged: (rating) => updateRating(index, rating),
                      rating: FilmRating.good,
                      currentRating: film.rating,
                    ),
                    const SizedBox(width: 8),
                    RatingButton(
                      onRatingChanged: (rating) => updateRating(index, rating),
                      rating: FilmRating.bad,
                      currentRating: film.rating,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
