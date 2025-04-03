import 'package:flutter/material.dart';
import 'package:my_movies/model/film.dart';
import 'package:my_movies/widget/film_list_view.dart';
import 'package:my_movies/widget/film_filter.dart';
import 'package:my_movies/widget/rating_button.dart';

class FilmStreamWidget extends StatelessWidget {
  final Stream<List<Film>> filmsStream;
  final FilmRating? filterRating;
  final void Function(FilmRating) toggleFilter;
  final void Function(Film, int?) onSaveFilm;
  final void Function(int, FilmRating) updateRating;

  const FilmStreamWidget({
    super.key,
    required this.filmsStream,
    required this.filterRating,
    required this.toggleFilter,
    required this.onSaveFilm,
    required this.updateRating,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Film>>(
      stream: filmsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Add your first game!'));
        } else {
          final films = snapshot.data!;
          final filteredFilms = _filterFilms(films);
          final goodFilmsCount = _countFilmsByRating(films, FilmRating.good);
          final badFilmsCount = _countFilmsByRating(films, FilmRating.bad);

          return Column(
            children: [
              FilmFilter(
                goodFilmsCount: goodFilmsCount,
                badFilmsCount: badFilmsCount,
                filterRating: filterRating,
                toggleFilter: toggleFilter,
              ),
              Expanded(
                child: FilmListView(
                  films: filteredFilms.map((entry) => entry.value).toList(),
                  updateRating: (filteredIndex, rating) {
                    final originalIndex = filteredFilms[filteredIndex].key;
                    updateRating(originalIndex, rating);
                  },
                  onSaveFilm: onSaveFilm,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  List<MapEntry<int, Film>> _filterFilms(List<Film> films) {
    return filterRating == null
        ? films.asMap().entries.toList()
        : films.asMap().entries.where((entry) => entry.value.rating == filterRating).toList();
  }

  int _countFilmsByRating(List<Film> films, FilmRating rating) {
    return films.where((film) => film.rating == rating).length;
  }
}
