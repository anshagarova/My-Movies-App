import 'dart:async';
import 'package:my_movies/model/film.dart';
import 'package:my_movies/widget/rating_button.dart';
import 'package:rxdart/rxdart.dart';

class FilmManager {
  final _filmStreamController = StreamController<List<Film>>.broadcast();

  List<Film> films = [];

  Stream<List<Film>> get filmStream => _filmStreamController.stream
      .startWith([]);

  void addFilm(Film film) {
    films.add(film);
    _filmStreamController.sink.add(films);
  }

  void updateFilm(int index, Film updatedFilm) {
    if (index >= 0 && index < films.length) {
      films[index] = updatedFilm;
      _filmStreamController.sink.add(films);
    }
  }

  void updateFilmRating(int index, FilmRating rating) {
    if (index >= 0 && index < films.length) {
      films[index].rating = rating;
      _filmStreamController.sink.add(films);
    }
  }
  void dispose() {
    _filmStreamController.close();
  }
}
