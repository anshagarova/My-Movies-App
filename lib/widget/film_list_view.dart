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
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(film.title),
                ),
                RatingButton(
                  onRatingChanged: (rating) => updateRating(index, rating),
                  rating: FilmRating.good,
                  currentRating: film.rating,
                ),
                const SizedBox(width: 10),
                RatingButton(
                  onRatingChanged: (rating) => updateRating(index, rating),
                  rating: FilmRating.bad,
                  currentRating: film.rating,
                ),
              ],
            ),
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
          ),
        );
      },
    );
  }
}
