import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  HomePage({this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RaisedButton(
              onPressed: () => Navigator.pushNamed(context, "/koikoi"),
              child: Text('こいこい'),
            ),
            RaisedButton(
              onPressed: () => Navigator.pushNamed(context, "/hachihachi"),
              child: Text('はちはち'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(EvaIcons.twitter),
                  color: Colors.blue,
                  onPressed: _goToTwitter,
                  tooltip: 'Twitter',
                ),
                IconButton(
                  icon: SvgPicture.asset('icons/hatenablog-logo.svg'),
                  onPressed: _goToBlog,
                  tooltip: 'Blog',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _goToTwitter() async {
    const _url = "https://twitter.com/88hanafuda";
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not go to $_url';
    }
  }

  Future<void> _goToBlog() async {
    const _url = "http://hanafudaproject.hatenablog.com/";
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not go to $_url';
    }
  }
}
