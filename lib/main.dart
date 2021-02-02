import 'package:flutter/material.dart';
import 'package:flutter_app/ui/home_page.dart';
import 'package:flutter_app/ui/koikoi_page.dart';
import 'package:flutter_app/ui/hachihachi_page.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 50,
    colors: true,
    printEmojis: true,
    printTime: false,
  ),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scoring Hanafuda',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(title: 'Scoring Hanafuda'),
      initialRoute: '/home',
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => HomePage(title: 'Scoring Hanafuda'),
        '/koikoi': (BuildContext context) =>
            KoikoiPage(title: 'Scoring Koikoi'),
        '/hachihachi': (BuildContext context) =>
            HachihachiPage(title: 'Scoring Hachihachi'),
      },
    );
  }
}
