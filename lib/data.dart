import 'package:lightweightvocabularypro/dictionary.dart';
import 'package:flutter/material.dart';

class Data {

  static List<Word> words = List();

  static Word deleted;

  static int sortingType;

  static void sortWords() {
    switch(sortingType) {
      case 0:
        break;
      case 1:
        Data.words.sort((a, b) => a.word.compareTo(b.word));
        break;
      case 2:
        Data.words.sort((a, b) => a.word.length.compareTo(b.word.length));
        break;
      case 3:
        Data.words.sort((a, b) => a.timeAdded.compareTo(b.timeAdded));
        break;
    }
  }

  static bool saveAfterAdding;
  static bool saveAfterDeleting;
  
  static bool isPaid;

  static var appBarSearchController = TextEditingController();
}

class CustomTheme {

  static ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      color: Color(0xff1c004a)
    ),
    textTheme: TextTheme(
      headline: TextStyle(
        fontSize: 18,
        fontStyle: FontStyle.italic
      ),
      body1: TextStyle(
        fontSize: 15,
        fontFamily: 'Raleway-Medium',
        color: Color(0xff1c004a),
      ),
      body2: TextStyle(
        inherit: false,
        textBaseline: TextBaseline.alphabetic,
        fontSize: 13,
        color: Color(0xFF1f1f1f),
      ),
      caption: TextStyle(
        fontSize: 14,
        color: Colors.grey
      ),
    )
  );

  static ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    bottomAppBarColor: Colors.black,
    textTheme: TextTheme(
      headline: TextStyle(
        fontSize: 18,
        fontStyle: FontStyle.italic
      ),
      body1: TextStyle(
        fontSize: 15,
        fontFamily: 'Raleway-Medium',
      ),
      body2: TextStyle(
        inherit: false,
        textBaseline: TextBaseline.alphabetic,
        fontSize: 13,
        color: Color(0xffc9c9c9)
      ),
      caption: TextStyle(
        fontSize: 14,
        color: Colors.grey
      )
    )
  );

  static EdgeInsets meaningPadding = EdgeInsets.only(top: 8, bottom: 4);
}