import 'package:flutter/material.dart';

enum FilmRating { good, bad, none }

class RatingButton extends StatelessWidget {
  final ValueChanged<FilmRating> onRatingChanged;
  final FilmRating rating;
  final FilmRating? currentRating;

  const RatingButton({
    super.key,
    required this.onRatingChanged,
    required this.rating,
    required this.currentRating,
  });

  @override
  Widget build(BuildContext context) {
    final buttonConfig = _getButtonConfig();

    return ElevatedButton(
      onPressed: () => onRatingChanged(rating),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonConfig.backgroundColor,
      ),
      child: Text(buttonConfig.text),
    );
  }

  _ButtonConfig _getButtonConfig() {
    if (rating == FilmRating.good) {
      return _ButtonConfig(
        text: 'Good',
        backgroundColor: currentRating == FilmRating.good ? Colors.green.shade300 : Colors.white,
      );
    } else if (rating == FilmRating.bad) {
      return _ButtonConfig(
        text: 'Bad',
        backgroundColor: currentRating == FilmRating.bad ? Colors.red.shade300 : Colors.white,
      );
    }
    return _ButtonConfig(
      text: '',
      backgroundColor: Colors.white,
    );
  }
}

class _ButtonConfig {
  final String text;
  final Color backgroundColor;

  _ButtonConfig({
    required this.text,
    required this.backgroundColor,
  });
}
