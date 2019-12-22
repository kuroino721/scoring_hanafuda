import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RaisedButton(
              onPressed: () => Navigator.pushNamed(context, "/koikoi"),
              child: new Text('こいこい'),
            ),
            RaisedButton(
//              onPressed: () => Navigator.pushNamed(context, "/hachihachi"),
              onPressed: null,
              child: new Text('はちはち'),
            ),
          ],
        ),
      ),
    );
  }
}
