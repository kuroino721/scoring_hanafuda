import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_app/strings/trivia_of_month.dart';
import 'package:flutter_app/ui/home_page.dart';

class KoikoiPage extends StatefulWidget {
  @override
  KoikoiState createState() => new KoikoiState();
}

class KoikoiState extends State<KoikoiPage> {
  final String title = 'Scoring Koikoi';
  List<String> nameOfPlayer = ['player1', 'player2'];
  List<int> score = new List.filled(2, 0);
  List<int> totalScoreOfPlayer = new List.filled(2, 0);
  int month = 1;

  /// プレイヤー名表示（編集可能）
  _showNameOfPlayer(int numOfPlayer) {
    return Container(
      width: 200.0,
      child: new TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration.collapsed(
            hintText: '${nameOfPlayer[numOfPlayer - 1]}',
          ),
          onChanged: (text) {
            if (text.length > 0) {
              setState(() {
                this.nameOfPlayer[numOfPlayer - 1] = text;
              });
            }
          }),
    );
  }

  /// プレイヤーの得点初期化
  void _initializeScores() {
    setState(() {
      for (int i = 0; i < this.score.length; i++) {
        score[i] = 0;
      }
    });
  }

  /// 点数++
  void _incrementScore(int numOfPlayer) {
    setState(() {
      score[numOfPlayer - 1]++;
    });
  }

  /// 点数--
  void _decrementScore(int numOfPlayer) {
    setState(() {
      score[numOfPlayer - 1]--;
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
      child: new Text(
        score[numOfPlayer - 1].toString(),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 100),
      ),
    );
  }

  /// 累計得点の表示
  _showTotalScoreOfPlayer(int numOfPlayer) {
    return Container(
      child: new Text('total: ${this.totalScoreOfPlayer[numOfPlayer - 1]}'),
    );
  }

  /// 月++
  void _incrementMonth() {
    setState(() {
      this.month++;
      if (this.month > 12) {
        this.month %= 12;
      }
    });
  }

  /// 月の表示
  _showMonth() {
    return Container(
      child: new Text('${this.month}月'),
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

  /// 確認画面表示
  Future _showConfirm({String title, String body}) async {
    bool result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        title: new Text(title),
        content: Center(
          child: new Text(body),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context, false),
          ),
          FlatButton(
            child: Text("OK"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    return result;
  }

  /// 再戦
  void _goToNextRound() {
    _showConfirm(title: '再戦', body: '再戦しますか？').then((result) {
      if (result) {
        for (int i = 0; i < totalScoreOfPlayer.length; i++) {
          totalScoreOfPlayer[i] += score[i];
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
      builder: (BuildContext context) => new AlertDialog(
        title: new Text('$month月'),
        content: Padding(
          padding: EdgeInsets.all(0.0),
          child: SingleChildScrollView(
              child: new Text(TriviaOfMonth.getTrivia(month))),
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
    textOfScore = "${nameOfPlayer[0]}さん: ${totalScoreOfPlayer[0]}文\n"
        "${nameOfPlayer[1]}さん: ${totalScoreOfPlayer[1]}文\n";
    if (totalScoreOfPlayer[0] > totalScoreOfPlayer[1]) {
      textOfResult = "${nameOfPlayer[0]}さんの勝ちです！おみごと！";
    } else if (totalScoreOfPlayer[0] < totalScoreOfPlayer[1]) {
      textOfResult = "${nameOfPlayer[1]}さんの勝ちです！あっぱれ！";
    } else {
      textOfResult = "引き分けです！良い勝負でしたね！";
    }
    await showDialog(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        title: new Text('結果'),
        content: Center(
          child: new Text(textOfScore + textOfResult),
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
    _showConfirm(title: 'ゲーム終了', body: '終了しますか？').then((result) {
      if (result) {
        for (int i = 0; i < totalScoreOfPlayer.length; i++) {
          totalScoreOfPlayer[i] += score[i];
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
          child: new Text('再戦'),
        ),
        RaisedButton(
          onPressed: _showTriviaOfMonth,
          child: new Text('$month月といえば'),
        ),
        RaisedButton(
          onPressed: _finishGame,
          child: new Text('終了'),
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

  /// 全体のレイアウト
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(title),
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
}
