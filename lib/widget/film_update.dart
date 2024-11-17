import 'package:flutter/material.dart';
import 'package:my_movies/model/film.dart';

class FilmUpdate extends StatelessWidget {
  final Stream<List<Film>> filmStream;

  const FilmUpdate({super.key, required this.filmStream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Film>>(
      stream: filmStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No films available');
        }
        return Text('Films updated: ${snapshot.data!.length}');
      },
    );
  }
}
