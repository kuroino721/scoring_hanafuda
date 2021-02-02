import 'package:flutter/material.dart';
import 'package:flutter_app/info/player.dart';

/// 「次の月へ」ボタン
class NextRoundWidget extends StatelessWidget {
  NextRoundWidget({this.goToNextRound});
  final void Function() goToNextRound;
  @override
  Widget build(BuildContext build) {
    return RaisedButton(
      onPressed: goToNextRound,
      child: Text('次の月へ'),
    );
  }
}

/// 「前の月へ」ボタン
class PrevRoundWidget extends StatelessWidget {
  PrevRoundWidget({this.backToPrevRound, this.round});
  final void Function() backToPrevRound;
  final int round;
  @override
  Widget build(BuildContext build) {
    return RaisedButton(
      onPressed: round == 1 ? null : backToPrevRound,
      child: Text('前の月へ'),
    );
  }
}

/// 終了ボタン
class FinishGameWidget extends StatelessWidget {
  FinishGameWidget({this.finishGame});
  final void Function() finishGame;
  @override
  Widget build(BuildContext build) {
    return RaisedButton(
      onPressed: finishGame,
      child: Text('終了'),
    );
  }
}

/// 月の表示
class MonthWidget extends StatelessWidget {
  MonthWidget({this.month, this.showMonthTrivia, this.size});
  final int month;
  final void Function() showMonthTrivia;
  final double size;
  @override
  Widget build(BuildContext build) {
    return FlatButton(
      child: Text('$month月', style: TextStyle(fontSize: size)),
      onPressed: showMonthTrivia,
    );
  }
}

/// プレイヤー名表示（編集可能）Widget
class PlayerNameWidget extends StatefulWidget {
  PlayerNameWidget({this.playerNum, this.players, this.changeName, this.width});
  final int playerNum;
  final List<Player> players;
  final void Function({int playerNum, String name}) changeName;
  final double width;

  @override
  PlayerNameWidgetState createState() => PlayerNameWidgetState();
}

/// プレイヤー名表示（編集可能）State
class PlayerNameWidgetState extends State<PlayerNameWidget> {
  String _name;

  void _onValueChange(String value) {
    if (value.length > 0) {
      setState(() {
        _name = value;
      });
      widget.changeName(playerNum: widget.playerNum, name: _name);
    }
  }

  @override
  void initState() {
    super.initState();
    _name = widget.players[widget.playerNum - 1].name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: TextField(
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            hintText: _name,
            hintStyle: TextStyle(fontSize: 20, color: Colors.black87)),
        onChanged: _onValueChange,
      ),
    );
  }
}
