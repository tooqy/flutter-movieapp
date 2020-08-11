import 'package:flutter/material.dart';
import 'package:movie_app/ui/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MovieDB',
      home: HomeScreen(),
    );
  }
}
