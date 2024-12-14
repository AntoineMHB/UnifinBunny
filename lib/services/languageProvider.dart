import 'package:flutter/material.dart';


class LanguageProvider with ChangeNotifier {
  Locale _locale =  Locale('en');

  Locale get locale => _locale;

  void changeLanguage(String languageCode) {
    if (languageCode == 'en') {
      _locale = Locale('en');
      } else if (languageCode == 'es') {
      _locale = Locale('es');
    }
    notifyListeners();
  }
}