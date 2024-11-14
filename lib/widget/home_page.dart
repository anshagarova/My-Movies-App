import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:my_movies/widget/add_film_page.dart';
import 'package:my_movies/model/film.dart';
import 'package:my_movies/widget/rating_button.dart';
import 'package:my_movies/widget/error_message.dart';
import 'package:my_movies/widget/film_list_view.dart';
import 'package:my_movies/widget/film_filter.dart';

class HomePage extends StatefulWidget {
  const HomePage({ super.key });

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Film> films = [];
  String errorMessage = '';
  FilmRating? filterRating;

  @override
  void initState() {
    super.initState();
    loadFilms();
  }

  int get goodFilmsCount => films.where((film) => film.rating == FilmRating.good).length;
  int get badFilmsCount => films.where((film) => film.rating == FilmRating.bad).length;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/films.json');
  }

  Future<void> loadFilms() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        String filmsJson = await file.readAsString();
        setState(() {
          films = (jsonDecode(filmsJson) as List).map((item) => Film.fromJson(item)).toList();
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading films: $e';
      });
    }
  }

  Future<void> saveFilms() async {
    try {
      final file = await _localFile;
      String filmsJson = jsonEncode(films.map((film) => film.toJson()).toList());
      await file.writeAsString(filmsJson);
    } catch (e) {
      setState(() {
        errorMessage = 'Error saving films: $e';
      });
    }
  }

  void onSaveFilm(Film film, int? index) {
    setState(() {
      if (index != null) {
        films[index] = film;
      } else {
        films.add(film);
      }
      saveFilms();
    });
  }

  void updateRating(int index, FilmRating rating) {
    setState(() {
      var filteredFilm = filteredFilms[index];
      var originalIndex = films.indexOf(filteredFilm);
      films[originalIndex].rating = rating;
      saveFilms();
    });
  }

  List<Film> get filteredFilms {
    if (filterRating == null) {
      return films;
    }
    return films.where((film) => film.rating == filterRating).toList();
  }

  void toggleFilter(FilmRating rating) {
    setState(() {
      filterRating = filterRating == rating ? null : rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Movies',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddFilmPage(onSaveFilm: onSaveFilm),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          FilmFilter(
            goodFilmsCount: goodFilmsCount,
            badFilmsCount: badFilmsCount,
            filterRating: filterRating,
            toggleFilter: toggleFilter,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: FilmListView(
                films: filteredFilms,
                updateRating: updateRating,
                onSaveFilm: onSaveFilm,
              ),
            ),
          ),
          if (errorMessage.isNotEmpty)
            ErrorMessageWidget(errorMessage: errorMessage),
        ],
      ),
    );
  }
}

