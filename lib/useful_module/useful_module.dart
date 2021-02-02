import 'package:flutter/material.dart';

class UsefulModules {
  /// 確認画面表示
  /// onlyOK: trueの場合、ボタンをOKのみにする。デフォルトはCancelも表示される。
  static Future showConfirm(
      {BuildContext context,
      String title,
      String body,
      String cancelSelection = 'Cancel',
      String okSelection = 'OK',
      bool onlyOK = false}) async {
    if (onlyOK == false) {
      return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[Text(body)],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(cancelSelection),
              onPressed: () => Navigator.pop(context, false),
            ),
            FlatButton(
              child: Text(okSelection),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      );
    } else {
      return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[Text(body)],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(okSelection),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      );
    }
  }
}
