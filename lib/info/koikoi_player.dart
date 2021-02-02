import 'package:flutter_app/info/player.dart';

class KoikoiPlayer extends Player {
  int monthScore = 0;
  KoikoiPlayer(String name) : super(name);

  void initMonthScore(){
    monthScore=0;
  }
}
