import 'package:flutter/material.dart';
import 'package:my_movies/model/film.dart';
import 'package:my_movies/widget/film_title_text_field.dart';
import 'package:my_movies/widget/rating_button.dart';
import 'package:my_movies/widget/util/test_keys.dart';

class AddFilmPage extends StatelessWidget {
  final void Function(Film, int?) onSaveFilm;
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
        title: Text(existingFilm == null ? 'Add Game' : 'Edit Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            FilmTitleTextField(
              key: TestKeys.INPUT_FIELD,
              controller: titleController,
              label: 'Game Title',
              onSubmitted: (value) {
                final updatedFilm = Film(
                  title: value,
                  rating: existingFilm?.rating ?? FilmRating.none,
                );

                onSaveFilm(updatedFilm, filmIndex);
                Navigator.pop(context);
              },
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
