import 'package:flutter/material.dart';
import 'package:my_movies/model/film.dart';
import 'package:my_movies/widget/rating_button.dart';

class AddFilmPage extends StatelessWidget {
  final Function(Film, int?) onSaveFilm;
  final Film? existingFilm;
  final int? filmIndex;

  const AddFilmPage({
    super.key,
    required this.onSaveFilm,
    this.existingFilm,
    this.filmIndex,
  });

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: existingFilm?.title ?? '');

    return Scaffold(
      appBar: AppBar(
        title: Text(existingFilm == null ? 'Add Film' : 'Edit Film'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Film Title'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedFilm = Film(
                  title: titleController.text,
                  rating: existingFilm?.rating ?? FilmRating.none,
                );

                onSaveFilm(updatedFilm, filmIndex);
                Navigator.pop(context);
              },
              child: Text(existingFilm == null ? 'Save' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }
}
