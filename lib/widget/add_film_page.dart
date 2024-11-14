import 'package:flutter/material.dart';
import 'package:my_movies/model/film.dart';

class AddFilmPage extends StatefulWidget {
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
  _AddFilmPageState createState() => _AddFilmPageState();
}

class _AddFilmPageState extends State<AddFilmPage> {
  late TextEditingController titleController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.existingFilm?.title ?? '');
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }


  void saveFilm() {
    if (titleController.text.isNotEmpty) {
      final newFilm = Film(title: titleController.text);
      widget.onSaveFilm(newFilm, widget.filmIndex);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingFilm != null ? 'Edit Film' : 'Add Film'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Film Title',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveFilm,
              child: Text(widget.existingFilm != null ? 'Update Film' : 'Add Film'),
            ),
          ],
        ),
      ),
    );
  }
}
