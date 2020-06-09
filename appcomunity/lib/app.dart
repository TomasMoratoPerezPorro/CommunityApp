import 'package:appcomunity/Pages/MainPage.dart';
import 'package:appcomunity/Pages/about_page.dart';
import 'package:flutter/material.dart';


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (_) => MainPage(),
        '/about': (_) => AboutPage(),
      },
    );
  }
}
