import 'package:flutter_app/info/player.dart';

class HachihachiPlayer extends Player {
  List<int> monthScore = List.filled(2, 0);
  List<bool> parent = [false];
  HachihachiPlayer(String name) : super(name);

  void initMonthScore() {
    for (int i = 0; i < monthScore.length; i++) {
      monthScore[i] = 0;
    }
  }
}
