import 'package:flutter/material.dart';
import 'package:my_movies/widget/app_wrapper.dart';
import 'package:my_movies/service/film_manager.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<FilmManager>(FilmManager());
}

void main() {
  setup();
  runApp(const AppWrapper());
}
