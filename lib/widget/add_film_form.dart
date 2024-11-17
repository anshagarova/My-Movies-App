import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:my_movies/service/film_manager.dart';
import 'package:my_movies/model/film.dart';
import 'package:my_movies/widget/film_update.dart';
import 'package:my_movies/widget/film_title_text_field.dart';

class AddFilmForm extends StatelessWidget {
  final TextEditingController inputController;
  final ValueChanged<String> addFilm;

  const AddFilmForm({
    super.key,
    required this.inputController,
    required this.addFilm,
  });

  @override
  Widget build(BuildContext context) {
    final filmManager = GetIt.I<FilmManager>();

    return Column(
      children: [
        FilmTitleTextField(
          controller: inputController,
          label: 'Enter film title',
          onSubmitted: (value) {
            final newFilm = Film(title: value);
            filmManager.addFilm(newFilm);
            inputController.clear();
          },
        ),
        FilmUpdate(filmStream: filmManager.filmStream),
      ],
    );
  }
}
