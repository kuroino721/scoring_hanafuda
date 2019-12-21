import 'package:flutter/material.dart';
import 'package:flutter_app/strings/trivia_of_month.dart';
import 'package:flutter_app/ui/home_page.dart';
import 'package:sortedmap/sortedmap.dart';

final List<String> phases = ['手役', '出来役', '出来役なし'];

class HachihachiPlayer {
  String name;
  HachihachiPlayer(this.name);
  var scoreOfRound = {
    phases[0]: 0,
    phases[1]: 0,
    phases[2]: 0,
  };
  var totalScore = 0;
}

class HachihachiPage extends StatefulWidget {
  @override
  HachihachiState createState() => new HachihachiState();
}

class Choice {
  Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

var choices = <Choice>[
  Choice(title: phases[0]),
  Choice(title: phases[1]),
  Choice(title: phases[2]),
];

class HachihachiState extends State<HachihachiPage> {
  final String title = 'Scoring Hachihachi';
  int month = 1;
  var players = [
    new HachihachiPlayer('player1'),
    new HachihachiPlayer('player2'),
    new HachihachiPlayer('player3')
  ];

  /// 全体のレイアウト
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: choices.length,
        child: Scaffold(
          appBar: new AppBar(
            title: Text(title),
            bottom: TabBar(
              isScrollable: true,
              tabs: choices.map((Choice choice) {
                return Tab(
                  text: choice.title,
                );
              }).toList(),
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              _showInfoOfPhase(phases[0]),
              _showInfoOfPhase(phases[1]),
              _showInfoOfPhase(phases[2]),
            ],
          ),
        ),
      ),
    );
  }

  _showInfoOfPhase(String phase) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _showInfoOfPlayers(phase),
        _centerBar(),
      ],
    );
  }

  /// プレイヤー名表示（編集可能）
  _showNameOfPlayer(int number) {
    return Container(
      width: 100.0,
      child: new TextField(
        textAlign: TextAlign.center,
        decoration: InputDecoration.collapsed(
          hintText: players[number - 1].name,
        ),
        onChanged: (text) {
          if (text.length > 0) {
            setState(
              () {
                players[number - 1].name = text;
              },
            );
          }
        },
      ),
    );
  }

  /// プレイヤーの得点初期化
  void _initializeScores() {
    setState(
      () {
        for (int i = 0; i < players.length; i++) {
          for (int j = 0; j < phases.length; j++) {
            players[i].scoreOfRound[phases[j]] = 0;
          }
        }
      },
    );
  }

  /// 得点の表示
  _showScoreOfPlayer({int number, String phase}) {
    return Container(
      width: 120.0,
      child: new TextField(
        textAlign: TextAlign.center,
        decoration: InputDecoration.collapsed(
          hintText: players[number - 1].scoreOfRound[phase].toString(),
        ),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
      ),
    );
  }

  /// 累計得点の表示
  _showTotalScores() {
    return Container(
      child: Column(
        Text('Total Score\n'),
        _showSortedTotalScores,
      ),
    );
  }

  _showSortedTotalScores() {
    var totalScores = {
      players[0].name: players[0].totalScore,
      players[1].name: players[1].totalScore,
      players[2].name: players[2].totalScore,
    };
    totalScores.values.toList()..sort();
    return Column(
      Text()
    )
  }

  /// 月++
  void _incrementMonth() {
    setState(
      () {
        this.month++;
        if (this.month > 12) {
          this.month %= 12;
        }
      },
    );
  }

  /// 月の表示
  _showMonth() {
    return Container(
      child: new Text('${this.month}月'),
    );
  }

  /// プレイヤー名、得点を1列に表示
  _showInfoOfPlayer({int number, String phase}) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _showNameOfPlayer(number),
          _showScoreOfPlayer(number: number, phase: phase),
        ],
      ),
    );
  }

  /// 3人のプレイヤーの得点を1行に表示
  _showInfoOfPlayers(String phase) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _showInfoOfPlayer(number: 1, phase: phases[0]),
          _showInfoOfPlayer(number: 2, phase: phases[1]),
          _showInfoOfPlayer(number: 3, phase: phases[2]),
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

  _addRoundScoreToTotal() {
    for (int i = 0; i < players.length; i++) {
      for (int j = 0; j < phases.length; j++) {
        players[i].totalScore += players[i].scoreOfRound[phases[j]];
      }
    }
  }

  /// 再戦
  void _goToNextRound() {
    _showConfirm(title: '再戦', body: '再戦しますか？').then(
      (result) {
        if (result) {
          _addRoundScoreToTotal();
          _incrementMonth();
          _initializeScores();
        }
      },
    );
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

  List<HachihachiPlayer> _decideWinner() {
    List<HachihachiPlayer> winners = [];
    int min = 0;
    for (int i = 0; i < players.length; i++) {
      if (min <= players[i].totalScore) {
        if (min < players[i].totalScore && winners.length != 0) {
          winners = [];
        }
        winners.add(players[i]);
        min = players[i].totalScore;
      }
    }
    return winners;
  }

  /// 勝敗ダイアログ
  Future _showResultOfGame() async {
    String textOfScore, textOfResult;
    textOfScore = "${players[0].name}さん: ${players[0].totalScore}文\n"
        "${players[1].name}さん: ${players[1].totalScore}文\n"
        "${players[2].name}さん: ${players[2].totalScore}文\n\n";
    var winners = _decideWinner();
    if (winners.length == 1) {
      textOfResult = "${winners[0].name}さんの勝ちです！おみごと！";
    } else if (winners.length == 2) {
      textOfResult = "${winners[0].name}, ${winners[1].name}さんの勝ちです！あっぱれ！";
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
    _showConfirm(title: 'ゲーム終了', body: '終了しますか？').then(
      (result) {
        if (result) {
          _addRoundScoreToTotal();
          _showResultOfGame();
        }
      },
    );
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
}
