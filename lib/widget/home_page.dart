import 'package:flutter/material.dart';
import 'add_film_page.dart';
import '../model/film.dart';
import 'rating_button.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Film> films = [];
  String errorMessage = '';
  FilmRating? filterRating;

  @override
  void initState() {
    super.initState();
    loadFilms();
  }

  int get goodFilmsCount {
    return films.where((film) => film.rating == FilmRating.good).length;
  }

  int get badFilmsCount {
    return films.where((film) => film.rating == FilmRating.bad).length;
  }

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
      films[index].rating = rating;
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => toggleFilter(FilmRating.good),
                    child: Text(
                      'Good: $goodFilmsCount',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: filterRating == FilmRating.good ? Colors.green : Colors.green.shade900,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => toggleFilter(FilmRating.bad),
                    child: Text(
                      'Bad: $badFilmsCount',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: filterRating == FilmRating.bad ? Colors.red : Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: ListView.builder(
                  itemCount: filteredFilms.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(filteredFilms[index].title),
                            ),
                            RatingButton(
                              onRatingChanged: (rating) => updateRating(index, FilmRating.good),
                              rating: FilmRating.good,
                              currentRating: filteredFilms[index].rating,
                            ),
                            const SizedBox(width: 10),
                            RatingButton(
                              onRatingChanged: (rating) => updateRating(index, FilmRating.bad),
                              rating: FilmRating.bad,
                              currentRating: filteredFilms[index].rating,
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddFilmPage(
                                onSaveFilm: onSaveFilm,
                                existingFilm: filteredFilms[index],
                                filmIndex: films.indexOf(filteredFilms[index]),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            if (errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
