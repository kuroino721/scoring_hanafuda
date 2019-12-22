import 'package:flutter/material.dart';
import 'package:flutter_app/ui/home_page.dart';
import 'package:flutter_app/ui/koikoi_page.dart';
import 'package:flutter_app/ui/hachihachi_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scoring Hanafuda',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(title: 'Scoring Hanafuda'),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) =>
            new HomePage(title: 'Scoring Hanafuda'),
        '/koikoi': (BuildContext context) => new KoikoiPage(),
        '/hachihachi': (BuildContext context) => new HachihachiPage(),
      },
    );
  }
}
