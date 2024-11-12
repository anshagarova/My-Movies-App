import 'package:flutter/material.dart';

enum FilmRating { good, bad, none }

class RatingButton extends StatelessWidget {
  final ValueChanged<FilmRating> onRatingChanged;
  final FilmRating rating;
  final FilmRating? currentRating;

  const RatingButton({
    Key? key,
    required this.onRatingChanged,
    required this.rating,
    required this.currentRating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Color backgroundColor = Colors.white;
    String buttonText = '';

    if (rating == FilmRating.good) {
      backgroundColor = currentRating == FilmRating.good ? Colors.green.shade300 : Colors.white;
      buttonText = 'Good';
    } else if (rating == FilmRating.bad) {
      backgroundColor = currentRating == FilmRating.bad ? Colors.red.shade300 : Colors.white;
      buttonText = 'Bad';
    }

    return ElevatedButton(
      onPressed: () => onRatingChanged(rating),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
      ),
      child: Text(buttonText),
    );
  }
}
