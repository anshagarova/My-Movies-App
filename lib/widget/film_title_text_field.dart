import 'package:flutter/material.dart';

class FilmTitleTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Function(String) onSubmitted;

  const FilmTitleTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onFieldSubmitted: onSubmitted,
      ),
    );
  }
}
