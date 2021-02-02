import 'package:flutter/material.dart';
import 'package:flutter_app/strings/trivia_of_month.dart';
import 'package:flutter_app/useful_module/useful_module.dart';
import 'package:flutter_app/info/koikoi_player.dart';
import 'package:flutter_app/info/game.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/ui/widget.dart';

class KoikoiPage extends StatefulWidget {
  KoikoiPage({this.title});
  final String title;

  @override
  KoikoiPageState createState() => KoikoiPageState();
}

class KoikoiPageState extends State<KoikoiPage> {
  List<KoikoiPlayer> _players = [
    KoikoiPlayer('player1'),
    KoikoiPlayer('player2')
  ];

  Game _game = Game();

  /// 全体のレイアウト
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _playerInfoWidget(1),
                _menuButtonsWidget(),
                _playerInfoWidget(2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changeName({int playerNum, String name}) {
    setState(() {
      _players[playerNum - 1].name = name;
    });
  }

  /// プレイヤーの得点初期化
  void _initMonthScores() {
    setState(() {
      for (int i = 0; i < _players.length; i++) {
        _players[i].initMonthScore();
      }
    });
  }

  /// 点数++
  void _incrementScore(int playerNum) {
    setState(() {
      _players[playerNum - 1].monthScore++;
    });
  }

  /// 点数--
  void _decrementScore(int playerNum) {
    setState(() {
      _players[playerNum - 1].monthScore--;
    });
  }

  /// +-ボタン
  // TODO: ボタンの距離が近すぎる
  _buttonToScoreWidget(int playerNum) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          onPressed: () => _incrementScore(playerNum),
          iconSize: 50,
          color: Colors.green,
          icon: Icon(Icons.add_circle),
        ),
        IconButton(
          onPressed: () => _decrementScore(playerNum),
          iconSize: 50,
          color: Colors.green,
          icon: Icon(Icons.remove_circle),
        ),
      ],
    );
  }

  /// 得点の表示
  _monthScoreWidget(int playerNum) {
    return Container(
      child: Text(
        _players[playerNum - 1].monthScore.toString(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 100,
          fontFamily: 'monospace',
        ),
      ),
    );
  }

  /// 累計得点の表示
  _totalScoreWidget(int playerNum) {
    return Container(
      child: Text(
          'total: ${_players[playerNum - 1].totalScore[_game.round - 1]}文',
          style: TextStyle(fontSize: 20)),
    );
  }

  /// 名前、累計得点、月の得点、+-ボタンを1列に表示
  _playerInfoWidget(int playerNum) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        PlayerNameWidget(
            playerNum: playerNum,
            players: _players,
            changeName: _changeName,
            width: 200),
        _totalScoreWidget(playerNum),
        _monthScoreWidget(playerNum),
        _buttonToScoreWidget(playerNum),
      ],
    );
  }

  /// 次の月へ
  void _goToNextRound() {
    UsefulModules.showConfirm(context: context, title: '次の月へ', body: '再戦しますか？')
        .then((result) {
      if (result) {
        logger.i("go to next round");
        for (int i = 0; i < _players.length; i++) {
          _players[i].totalScore.last += _players[i].monthScore;
          setState(() {
            _players[i].totalScore.add(_players[i].totalScore[_game.round - 1]);
          });
        }
        _game.incrementMonth();
        _game.incrementRound();
        _initMonthScores();
      }
    });
  }

  /// 前の月へ
  /// round==1: ボタン非活性
  /// round==2: totalを0に初期化
  /// round>=3: totalを2ラウンド前のものに戻す
  void _backToPrevRound() {
    UsefulModules.showConfirm(
            context: context, title: '前の月へ', body: '前の月へ戻りますか？')
        .then((result) {
      if (result) {
        for (int i = 0; i < _players.length; i++) {
          _players[i].totalScore.removeLast();
          if (_game.round == 1)
            logger.e("back round button was pushed in spite of round 1");
          if (_game.round == 2) {
            _players[i].totalScore.last = 0;
          } else {
            _players[i].totalScore.last = _players[i].totalScore[
                _game.round - 3]; //roundは1-based, indexは0-basedなので2ではなく3を引く
          }
        }
        _game.decrementMonth();
        _game.decrementRound();
        _initMonthScores();
      }
    });
  }

  /// 勝敗ダイアログ
  Future _showGameResult() async {
    String textOfScore, textOfResult;
    textOfScore = "${_players[0].name}さん: ${_players[0].totalScore.last}文\n"
        "${_players[1].name}さん: ${_players[1].totalScore.last}文\n";
    if (_players[0].totalScore.last > _players[1].totalScore.last) {
      textOfResult = "${_players[0].name}さんの勝ちです！おみごと！";
    } else if (_players[0].totalScore.last < _players[1].totalScore.last) {
      textOfResult = "${_players[1].name}さんの勝ちです！あっぱれ！";
    } else if (_players[0].totalScore.last == _players[1].totalScore.last) {
      textOfResult = "引き分けです！良い勝負でしたね！";
    }
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('結果'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(textOfScore + textOfResult),
          ],
        ),
        actions: <Widget>[
          FlatButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pushNamed('/home')),
        ],
      ),
    );
  }

  /// 終了
  void _finishGame() {
    UsefulModules.showConfirm(context: context, title: 'ゲーム終了', body: '終了しますか？')
        .then((result) {
      if (result) {
        for (int i = 0; i < _players.length; i++) {
          _players[i].totalScore.last += _players[i].monthScore;
        }
        _showGameResult();
      }
    });
  }

  /// メニューボタン
  _menuButtonsWidget() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          MonthWidget(
              month: _game.month, showMonthTrivia: _showMonthTrivia, size: 50),
          NextRoundWidget(goToNextRound: _goToNextRound),
          PrevRoundWidget(
              round: _game.round, backToPrevRound: _backToPrevRound),
          FinishGameWidget(finishGame: _finishGame),
        ],
      ),
    );
  }

  /// onPressedから引数が必要なメソッドを呼び出すためだけのvoidメソッド
  void _showMonthTrivia() {
    TriviaOfMonth.showMonthTrivia(context: context, month: _game.month);
  }
}
