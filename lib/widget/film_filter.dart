import 'package:flutter/material.dart';
import 'package:my_movies/widget/rating_button.dart';
import 'package:my_movies/widget/util/test_keys.dart';

class FilmFilter extends StatelessWidget {
  final int goodFilmsCount;
  final int badFilmsCount;
  final FilmRating? filterRating;
  final Function(FilmRating) toggleFilter;

  const FilmFilter({
    super.key,
    required this.goodFilmsCount,
    required this.badFilmsCount,
    required this.filterRating,
    required this.toggleFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => toggleFilter(FilmRating.good),
            child: Text(
              'Good Games: $goodFilmsCount',
              key: TestKeys.GOOD_COUNTER,
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
              'Bad Games: $badFilmsCount',
              key: TestKeys.BAD_COUNTER,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: filterRating == FilmRating.bad ? Colors.red : Colors.red.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

