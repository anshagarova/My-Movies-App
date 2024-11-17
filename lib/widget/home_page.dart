import 'package:flutter/material.dart';
import 'package:my_movies/widget/add_film_page.dart';
import 'package:my_movies/model/film.dart';
import 'package:my_movies/service/film_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:my_movies/widget/rating_button.dart';
import 'package:my_movies/widget/film_stream_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FilmManager _filmManager = GetIt.I<FilmManager>();
  late Stream<List<Film>> _filmsStream;
  FilmRating? _filterRating;

  @override
  void initState() {
    super.initState();
    _filmsStream = _filmManager.filmStream;
  }

  void _onSaveFilm(Film updatedFilm, int? filmIndex) {
    if (filmIndex != null) {
      _filmManager.updateFilm(filmIndex, updatedFilm);
    } else {
      _filmManager.addFilm(updatedFilm);
    }
  }

  void _updateRating(int index, FilmRating rating) {
    final film = _filmManager.films[index];
    final updatedFilm = film.copyWith(rating: rating);

    _filmManager.updateFilm(index, updatedFilm);
    setState(() {});
  }

  void _toggleFilter(FilmRating rating) {
    setState(() {
      _filterRating = _filterRating == rating ? null : rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddFilmPage(onSaveFilm: _onSaveFilm),
                ),
              );
            },
          ),
        ],
      ),
      body: FilmStreamWidget(
        filmsStream: _filmsStream,
        filterRating: _filterRating,
        toggleFilter: _toggleFilter,
        onSaveFilm: _onSaveFilm,
        updateRating: _updateRating,
      ),
    );
  }
}
