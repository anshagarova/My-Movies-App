import 'package:flutter/material.dart';
import 'package:my_movies/widget/add_film_page.dart';
import 'package:my_movies/model/film.dart';
import 'package:my_movies/service/film_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:my_movies/widget/film_list_view.dart';
import 'package:my_movies/widget/rating_button.dart';
import 'package:my_movies/widget/film_filter.dart';

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

    setState(() {
    });
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
      body: _buildFilmStream(),
    );
  }

  Widget _buildFilmStream() {
    return StreamBuilder<List<Film>>(
      stream: _filmsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Add your first film!'));
        } else {
          final films = snapshot.data!;
          final goodFilmsCount = films.where((film) => film.rating == FilmRating.good).length;
          final badFilmsCount = films.where((film) => film.rating == FilmRating.bad).length;

          final filteredFilms = _filterRating == null
              ? films
              : films.where((film) => film.rating == _filterRating).toList();

          return Column(
            children: [
              FilmFilter(
                goodFilmsCount: goodFilmsCount,
                badFilmsCount: badFilmsCount,
                filterRating: _filterRating,
                toggleFilter: _toggleFilter,
              ),
              Expanded(
                child: FilmListView(
                  films: filteredFilms,
                  updateRating: _updateRating,
                  onSaveFilm: _onSaveFilm,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
