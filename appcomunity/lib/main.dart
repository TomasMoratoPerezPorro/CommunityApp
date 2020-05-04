import 'package:flutter/material.dart';

import 'Pages/MainPage.dart';

void main() => runApp(CommunityApp());
class CommunityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:"CommunityApp",
      home: MainPage(),
      
    );
  }
}