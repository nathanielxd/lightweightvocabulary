import 'package:flutter/material.dart';
import 'package:lightweightvocabularypro/data.dart';
import 'package:lightweightvocabularypro/pages/homePage.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: ((brightness) {
        if(brightness == Brightness.light) {
          return CustomTheme.lightMode;
        } else {
          return CustomTheme.darkMode;
        }
      }),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          title: 'Plus Vocabulary',
          theme: theme,
          home: HomePage()
        );
      },
    );
  }
}
