import 'package:flutter/material.dart';
import 'package:flutter_app/info/hachihachi_field.dart';
import 'package:flutter_app/strings/trivia_of_month.dart';
import 'package:flutter_app/ui/home_page.dart';
import 'package:flutter_app/useful_module/useful_module.dart';
import 'package:flutter_app/info/hachihachi_player.dart';
import 'dart:math' as math;
import 'package:after_layout/after_layout.dart';

final List<String> phaseNames = ['手役', '出来役', '取り札'];

class HachihachiPage extends StatefulWidget {
  @override
  HachihachiState createState() => HachihachiState();
}

class PhaseTab {
  PhaseTab({this.title, this.icon});

  final String title;
  final IconData icon;
}

var phaseTabs = <PhaseTab>[
  PhaseTab(title: phaseNames[0]),
  PhaseTab(title: phaseNames[1]),
  PhaseTab(title: phaseNames[2]),
];

class HachihachiState extends State<HachihachiPage>
    with AfterLayoutMixin<HachihachiPage> {
  final String _title = 'Scoring Hachihachi';
  List<HachihachiPlayer> _players = [
    HachihachiPlayer('player1'),
    HachihachiPlayer('player2'),
    HachihachiPlayer('player3')
  ];
  int _month = 1;
  List<HachihachiField> _fields = [
    HachihachiField('小場', 1),
    HachihachiField('大場', 2),
    HachihachiField('絶場', 4)
  ];
  int _round = 1;
  String _fieldName = '小場';
  int _scoreMagnification = 1;

  /// 全体のレイアウト
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: phaseTabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(_title),
            bottom: TabBar(
              isScrollable: true,
              tabs: phaseTabs.map((PhaseTab choice) {
                return Tab(
                  text: choice.title,
                );
              }).toList(),
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              _showPhaseInfo(0),
              _showPhaseInfo(1),
              _showPhaseInfo(2),
            ],
          ),
        ),
      ),
    );
  }

  //ページが開いた直後に1回だけ行われる処理
  @override
  void afterFirstLayout(BuildContext context) {
    //TODO: プレイヤー名入力ダイアログ表示
    _decideParent(0);
    int _parent;
    for (int i = 0; i < 3; i++) {
      if (_players[i].parent) {
        _parent = i;
        break;
      }
    }
    UsefulModules.showConfirm(
        context: context,
        title: '最初の親',
        body: '最初の親は ${_players[_parent].name} です',
        onlyOK: true);
  }

  //TODO: 名前要求ダイアログ
  _showRequestNameDialog() {
    showConfirm() async {
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
    }
  }

  _showPhaseInfo(int phase) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _showPlayersInfo(phase),
          _centerBar(),
          _showLowerHalfView(),
        ],
      ),
    );
  }

  /// プレイヤー名、得点を1列に表示
  _showPlayerInfo({int number, int phase}) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _showPlayerName(number),
          _showPhaseScore(number: number, phase: phase),
        ],
      ),
    );
  }

  /// プレイヤー名表示（編集可能）
  _showPlayerName(int number) {
    return Container(
      width: 100.0,
      child: TextField(
        textAlign: TextAlign.center,
        decoration: InputDecoration.collapsed(
          hintText: _players[number - 1].name,
        ),
        onChanged: (text) {
          if (text.length > 0) {
            setState(
              () {
                _players[number - 1].name = text;
              },
            );
          }
        },
      ),
    );
  }

  /// 3人のプレイヤーの得点を1行に表示
  _showPlayersInfo(int phase) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _showPlayerInfo(number: 1, phase: phase),
          _showPlayerInfo(number: 2, phase: phase),
          _showPlayerInfo(number: 3, phase: phase),
        ],
      ),
    );
  }

  /// 得点の表示
  _showPhaseScore({int number, int phase}) {
    return Container(
      width: 120.0,
      child: TextField(
        textAlign: TextAlign.center,
        decoration: InputDecoration.collapsed(
          hintText: '0',
        ),
        onChanged: (text) {
          if (text.length > 0) {
            setState(
              () {
                _players[number - 1].phaseScore[phase] = int.parse(text);
              },
            );
          }
        },
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
      ),
    );
  }

  /// 中央のバー
  _centerBar() {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceEvenly,
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

  /// 再戦
  void _goToNextRound(int phase) {
    UsefulModules.showConfirm(context: context, title: '再戦', body: '再戦しますか？')
        .then(
      (result) {
        if (result) {
          if (!_isValidPhase2Score()) {
            UsefulModules.showConfirm(
                context: context,
                title: 'ちがうよ！',
                body: '取り札の合計は0点、または88×3＝264点である必要があります。',
                onlyOK: true);
            return;
          }
          _round++;
          if (_isAll88()) {
            for (int i = 0; i < 3; i++) {
              if (_players[i].parent) {
                _players[i].phaseScore[1] += 50;
                break;
              }
            }
            _calcMonthScore(1);
            _decideParent(1);
          } else {
            _calcMonthScore(phase);
            _decideParent(phase);
          }
          //totalに月の点数を加算
          for (int i = 0; i < 3; i++) {
            _players[i].totalScore += _players[i].monthScore;
          }
          _initializeScores();
          _incrementMonth();
          _fieldName = '小場';
        } else {
          return;
        }
      },
    );
  }

  /// 出来役なしのスコア合計が0または88*3であることの確認
  bool _isValidPhase2Score() {
    int _sum = 0;
    for (int i = 0; i < 3; i++) {
      _sum += _players[i].phaseScore[2];
    }
    if (_sum == 0 || _sum == 88 * 3) {
      return true;
    } else {
      return false;
    }
  }

  // 月の点数を計算する
  void _calcMonthScore(int phase) {
    // 手役の分の計算
    var memoPhaseScore = List(3);
    for (int i = 0; i < 3; i++) {
      memoPhaseScore[i] = _players[i].phaseScore[0];
    }
    for (int i = 0; i < 3; i++) {
      _players[i].monthScore += memoPhaseScore[i];
      _players[i].monthScore -= memoPhaseScore[(i + 1) % 3];
      _players[i].monthScore -= memoPhaseScore[(i + 2) % 3];
    }
    switch (phase) {
      case 1: //出来役ありの場合
        for (int i = 0; i < 3; i++) {
          memoPhaseScore[i] = _players[i].phaseScore[1];
        }
        for (int i = 0; i < 3; i++) {
          _players[i].monthScore += memoPhaseScore[i];
          _players[i].monthScore -= memoPhaseScore[(i + 1) % 3];
          _players[i].monthScore -= memoPhaseScore[(i + 2) % 3];
        }
        break;
      case 2: //出来役なしの場合
        for (int i = 0; i < 3; i++) {
          _players[i].monthScore += _players[i].phaseScore[2] - 88;
        }
        break;
    }
  }

  /// 月++
  void _incrementMonth() {
    setState(() {
      _month++;
      _month %= 12;
    });
  }

  /// プレイヤーの得点初期化
  void _initializeScores() {
    setState(
      () {
        for (int i = 0; i < 3; i++) {
          for (int j = 0; j < _players[i].phaseScore.length; j++) {
            _players[i].phaseScore[j] = 0;
          }
        }
      },
    );
  }

  /// 親決め
  void _decideParent(phase) {
    if (_round == 1) {
      var random = math.Random();
      _players[random.nextInt(3)].parent = true;
    } else {
      switch (phase) {
        case 1: //出来役ありなら出来役の人が親
          for (int i = 0; i < 3; i++) {
            if (_players[i].phaseScore[1] > 0) {
              _players[i].parent = true;
              _players[(i + 1) % 3].parent = false;
              _players[(i + 2) % 3].parent = false;
              break;
            }
          }
          break;
        case 2: //出来役なしなら取り札が最高得点の人が親
          int _max = 0, _maxPlayer;
          for (int i = 0; i < 3; i++) {
            if (_players[i].phaseScore[2] > _max) {
              _max = _players[i].phaseScore[2];
              _maxPlayer = i;
            }
          }
          _players[_maxPlayer].parent = true;
          _players[(_maxPlayer + 1) % 3].parent = false;
          _players[(_maxPlayer + 2) % 3].parent = false;
      }
    }
  }

  /// 総八判定
  bool _isAll88() {
    int _cnt = 0;
    for (int i = 0; i < 3; i++) {
      if (_players[i].phaseScore[2] == 88) {
        _cnt++;
      }
    }
    if (_cnt == 3) {
      return true;
    } else {
      return false;
    }
  }

  /// 画面下半分の表示
  _showLowerHalfView() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _showTotalScores(),
          _showMonthAndField(),
        ],
      ),
    );
  }

  /// 累計得点の表示
  _showTotalScores() {
    return DataTable(
      columns: [
        DataColumn(label: Text('Name', style: TextStyle(fontSize: 20.0))),
        DataColumn(label: Text('Total', style: TextStyle(fontSize: 20.0))),
      ],
      rows: [
        DataRow(
          cells: [
            DataCell(Text(_players[0].name, style: TextStyle(fontSize: 20.0))),
            DataCell(Text(_players[0].totalScore.toString(),
                style: TextStyle(fontSize: 20.0))),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text(_players[1].name, style: TextStyle(fontSize: 20.0))),
            DataCell(Text(_players[1].totalScore.toString(),
                style: TextStyle(fontSize: 20.0))),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text(_players[2].name, style: TextStyle(fontSize: 20.0))),
            DataCell(Text(_players[2].totalScore.toString(),
                style: TextStyle(fontSize: 20.0))),
          ],
        ),
      ],
    );
  }

  /// 月と場の表示
  _showMonthAndField() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _showMonth(),
          _showFieldSelection(),
        ],
      ),
    );
  }

  /// 月の表示
  _showMonth() {
    return Container(child: Text('$_month月', style: TextStyle(fontSize: 20.0)));
  }

  /// 場の選択肢表示
  _showFieldSelection() {
    return DropdownButton<String>(
      value: _fieldName,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple, fontSize: 20.0),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          _fieldName = newValue;
          for (int i = 0; i < 3; i++) {
            if (_fields[i].name == _fieldName) {
              _scoreMagnification = _fields[i].scoreMagnification;
            }
          }
        });
      },
      items: <String>[_fields[0].name, _fields[1].name, _fields[2].name]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
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

  List<HachihachiPlayer> _decideWinner() {
    List<HachihachiPlayer> winners = [];
    int min = 0;
    for (int i = 0; i < 3; i++) {
      if (min <= _players[i].totalScore) {
        if (min < _players[i].totalScore && winners.length != 0) {
          winners = [];
        }
        winners.add(_players[i]);
        min = _players[i].totalScore;
      }
    }
    return winners;
  }

  /// 勝敗ダイアログ
  Future _showResultOfGame() async {
    String textOfScore, textOfResult;
    textOfScore = "${_players[0].name}さん: ${_players[0].totalScore}文\n"
        "${_players[1].name}さん: ${_players[1].totalScore}文\n"
        "${_players[2].name}さん: ${_players[2].totalScore}文\n\n";
    var winners = _decideWinner();
    if (winners.length == 1) {
      textOfResult = "${winners[0].name}さんの勝ちです！おみごと！";
    } else if (winners.length == 2) {
      textOfResult = "${winners[0].name}, ${winners[1].name}さんの勝ちです！あっぱれ！";
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('結果'),
        content: Center(
          child: Text(textOfScore + textOfResult),
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
        .then(
      (result) {
        if (result) {
          if (_isValidTotalOfRound()) {
            _addRoundScoreToTotal();
            _showResultOfGame();
          } else {
            UsefulModules.showConfirm(
                    context: context, title: 'ゲーム終了', body: '強制的に終了しますか？')
                .then((result) {
              _showResultOfGame();
            });
            return;
          }
        }
      },
    );
  }
}
