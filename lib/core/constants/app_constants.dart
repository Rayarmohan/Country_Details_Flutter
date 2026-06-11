import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static const String baseUrl = 'https://api.restcountries.com';
  static const String apiKey = 'rc_live_ae7540795fc3485e91ec5e668f3602fd';
  static const String allCountriesEndpoint = '/countries/v5?limit=25';
  static const String countryByNameEndpoint = '/countries/v5/name';

  static const String hiveBoxName = 'countries_box';
  static const String hiveCountriesKey = 'countries';
  static const String hiveLastSyncKey = 'last_sync';

  static const int pageSize = 20;
  static const Duration searchDebounce = Duration(milliseconds: 400);

  static const List<Color> accentColors = [
    Colors.teal,
    Colors.indigo,
    Colors.pink,
    Colors.amber,
    Colors.green,
    Colors.deepPurple,
  ];

  static const List<String> accentColorNames = [
    'Teal',
    'Indigo',
    'Pink',
    'Amber',
    'Green',
    'Purple',
  ];

  static const List<double> fontScales = [0.85, 1.0, 1.15];
  static const List<String> fontScaleNames = ['Small', 'Medium', 'Large'];
}
