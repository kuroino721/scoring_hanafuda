import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_app/strings/trivia_of_month.dart';
import 'package:flutter_app/ui/home_page.dart';
import 'package:flutter_app/useful_module/useful_module.dart';
import 'package:flutter_app/info/player.dart';

class KoikoiPage extends StatefulWidget {
  @override
  KoikoiState createState() => KoikoiState();
}

class KoikoiState extends State<KoikoiPage> {
  final String _title = 'Scoring Koikoi';
  List<Player> _players = [Player('player1'), Player('player2')];
  int _month = 1;

  /// 全体のレイアウト
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Transform.rotate(
              angle: math.pi,
              child: _showFieldOfPlayer(1),
            ),
            _centerBar(),
            _showFieldOfPlayer(2),
          ],
        ),
      ),
    );
  }

  /// プレイヤー名表示（編集可能）
  _showNameOfPlayer(int numOfPlayer) {
    return Container(
      width: 200.0,
      child: TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration.collapsed(
            hintText: '${_players[numOfPlayer - 1].name}',
          ),
          onChanged: (text) {
            if (text.length > 0) {
              setState(() {
                _players[numOfPlayer - 1].name = text;
              });
            }
          }),
    );
  }

  /// プレイヤーの得点初期化
  void _initializeScores() {
    setState(() {
      for (int i = 0; i < _players.length; i++) {
        _players[i].monthScore = 0;
      }
    });
  }

  /// 点数++
  void _incrementScore(int numOfPlayer) {
    setState(() {
      _players[numOfPlayer - 1].monthScore++;
    });
  }

  /// 点数--
  void _decrementScore(int numOfPlayer) {
    setState(() {
      _players[numOfPlayer - 1].monthScore--;
    });
  }

  /// +-ボタン
  _buttonToScore(int numOfPlayer) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            onPressed: () => _incrementScore(numOfPlayer),
            iconSize: 50,
            color: Colors.green,
            icon: Icon(Icons.add_circle),
          ),
          IconButton(
            onPressed: () => _decrementScore(numOfPlayer),
            iconSize: 50,
            color: Colors.green,
            icon: Icon(Icons.remove_circle),
          ),
        ],
      ),
    );
  }

  /// 得点の表示
  _showScoreOfPlayer(int numOfPlayer) {
    return Container(
      child: Text(
        _players[numOfPlayer - 1].monthScore.toString(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 100,
          fontFamily: 'monospace',
        ),
      ),
    );
  }

  /// 累計得点の表示
  _showTotalScoreOfPlayer(int numOfPlayer) {
    return Container(
      child: Text('total: ${_players[numOfPlayer - 1].totalScore}',
          style: TextStyle(fontSize: 20)),
    );
  }

  /// 月++
  void _incrementMonth() {
    setState(() {
      _month++;
      if (_month > 12) {
        _month %= 12;
      }
    });
  }

  /// 月の表示
  _showMonth() {
    return Container(
      child: Text('$_month月', style: TextStyle(fontSize: 20)),
    );
  }

  /// 累計得点、得点、月を1行に表示
  _showInfoOfPlayer(int numOfPlayer) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          RotatedBox(
            quarterTurns: 3,
            child: _showTotalScoreOfPlayer(numOfPlayer),
          ),
          Center(
            child: _showScoreOfPlayer(numOfPlayer),
          ),
          RotatedBox(
            quarterTurns: 1,
            child: _showMonth(),
          ),
        ],
      ),
    );
  }

  /// 再戦
  void _goToNextRound() {
    UsefulModules.showConfirm(context: context, title: '再戦', body: '再戦しますか？')
        .then((result) {
      if (result) {
        for (int i = 0; i < _players.length; i++) {
          _players[i].totalScore += _players[i].monthScore;
        }
        _incrementMonth();
        _initializeScores();
      }
    });
  }

  /// 月の雑学の表示
  Future _showTriviaOfMonth() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('$_month月'),
        content: Padding(
          padding: EdgeInsets.all(0.0),
          child: SingleChildScrollView(
              child: Text(TriviaOfMonth.getTrivia(_month))),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("なるほど"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  /// 勝敗ダイアログ
  Future _showResultOfGame() async {
    String textOfScore, textOfResult;
    textOfScore = "${_players[0].name}さん: ${_players[0].totalScore}文\n"
        "${_players[1].name}さん: ${_players[1].totalScore}文\n";
    if (_players[0].totalScore > _players[1].totalScore) {
      textOfResult = "${_players[0].name}さんの勝ちです！おみごと！";
    } else if (_players[0].totalScore < _players[1].totalScore) {
      textOfResult = "${_players[1].name}さんの勝ちです！あっぱれ！";
    } else if (_players[0].totalScore == _players[1].totalScore) {
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
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  settings: RouteSettings(name: "/home"),
                  builder: (BuildContext context) =>
                      HomePage(title: 'ScoringHanafuda')),
            ),
          ),
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
          _players[i].totalScore += _players[i].monthScore;
        }
        _showResultOfGame();
      }
    });
  }

  /// 中央のバー
  _centerBar() {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          onPressed: _goToNextRound,
          child: Text('再戦'),
        ),
        RaisedButton(
          onPressed: _showTriviaOfMonth,
          child: Text('$_month月といえば'),
        ),
        RaisedButton(
          onPressed: _finishGame,
          child: Text('終了'),
        ),
      ],
    );
  }

  /// Player1人分の情報全て
  _showFieldOfPlayer(int numOfPlayer) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _showNameOfPlayer(numOfPlayer),
          _showInfoOfPlayer(numOfPlayer),
          _buttonToScore(numOfPlayer),
        ],
      ),
    );
  }
}
