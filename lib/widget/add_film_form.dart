import 'package:flutter/material.dart';

class AddFilmForm extends StatelessWidget {
  final TextEditingController inputController;
  final Function addFilm;

  const AddFilmForm({
    Key? key,
    required this.inputController,
    required this.addFilm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: TextFormField(
            controller: inputController,
            decoration: const InputDecoration(
              labelText: 'Enter film title',
              border: OutlineInputBorder(),
            ),
            onFieldSubmitted: (value) {
              addFilm();
              inputController.clear();
            },
          ),
        ),
      ],
    );
  }
}