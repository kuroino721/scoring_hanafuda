import 'package:flutter_app/info/hachihachi_player.dart';

class HachihachiHand {
  HachihachiHand({this.players});
  List<HachihachiPlayer> players;

  /// 総八
  bool isAll88() {
    int _cnt = 0;
    for (var _tmpPlayer in players) {
      if (_tmpPlayer.monthScore[1] == 88) {
        _cnt++;
      }
    }
    if (_cnt == 3) {
      return true;
    } else {
      return false;
    }
  }

  /// 二八
  HachihachiPlayer getFutahachiPlayer() {
    for (var _tmpPlayer in players) {
      if (_tmpPlayer.monthScore[1] >= 168) {
        return _tmpPlayer;
      }
    }
    return null;
  }
}
