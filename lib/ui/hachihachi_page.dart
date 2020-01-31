import 'package:flutter/material.dart';
import 'package:flutter_app/info/hachihachi_field.dart';
import 'package:flutter_app/strings/trivia_of_month.dart';
import 'package:flutter_app/ui/home_page.dart';
import 'package:flutter_app/useful_module/useful_module.dart';
import 'package:flutter_app/info/hachihachi_player.dart';
import 'dart:math' as math;

final List<String> phaseNames = ['手役', '出来役', '出来役なし'];

class HachihachiPage extends StatefulWidget {
  @override
  HachihachiState createState() => new HachihachiState();
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

class HachihachiState extends State<HachihachiPage> {
  final String title = 'Scoring Hachihachi';
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

  /// 全体のレイアウト
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: phaseTabs.length,
        child: Scaffold(
          appBar: new AppBar(
            title: Text(title),
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
              _showInfoOfPhase(phaseNames[0]),
              _showInfoOfPhase(phaseNames[1]),
              _showInfoOfPhase(phaseNames[2]),
            ],
          ),
        ),
      ),
    );
  }

  _showInfoOfPhase(String phase) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _showInfoOfPlayers(phase),
          _centerBar(),
          _showLowerHalfView(),
        ],
      ),
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

  /// プレイヤー名表示（編集可能）
  _showNameOfPlayer(int number) {
    return Container(
      width: 100.0,
      child: new TextField(
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
  _showInfoOfPlayers(String phase) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _showInfoOfPlayer(number: 1, phase: phase),
          _showInfoOfPlayer(number: 2, phase: phase),
          _showInfoOfPlayer(number: 3, phase: phase),
        ],
      ),
    );
  }

  /// 得点の表示
  _showScoreOfPlayer({int number, String phase}) {
    return Container(
      width: 120.0,
      child: new TextField(
        textAlign: TextAlign.center,
        decoration: InputDecoration.collapsed(
//          hintText: players[number - 1].scoreOfRound[phase].toString(),
          hintText: '0',
        ),
        onChanged: (text) {
          if (text.length > 0) {
            setState(
              () {
                _players[number - 1].scoreOfRound[phase] = int.parse(text);
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
          child: new Text('再戦'),
        ),
        RaisedButton(
          onPressed: _showTriviaOfMonth,
          child: new Text('$_month月といえば'),
        ),
        RaisedButton(
          onPressed: _finishGame,
          child: new Text('終了'),
        ),
      ],
    );
  }

  /// 再戦
  void _goToNextRound() {
    UsefulModules.showConfirm(context: context, title: '再戦', body: '再戦しますか？')
        .then(
      (result) {
        if (result) {
          if (_isValidTotalOfRound()) {
            if (_isSouhachi()) {
              UsefulModules.showConfirm(
                  context: context,
                  title: '総八',
                  body: '総八だよ！やったね！',
                  onlyOK: true);
            }
            _addRoundScoreToTotal();
            _incrementMonth();
            _initializeScores();
            _nameOfField = '小場';
            _decideParent();
          } else {
            return;
          }
        }
      },
    );
  }

  /// ラウンドのスコアをtotalに加える
  void _addRoundScoreToTotal() {
    setState(() {
      _calcScoreOfYaku();
      if (_isSouhachi()) {
        for (int i = 0; i < _players.length; i++) {
          _players[i].scoreOfRound[phaseNames[2]] = 0;
        }
      } else {
        _calcScoreOfNoDekiyaku();
      }

      // 累計得点にその月の得点を足す
      for (int i = 0; i < _players.length; i++) {
        for (int j = 0; j < phaseNames.length; j++) {
          _players[i].totalScore +=
              _players[i].scoreOfRound[phaseNames[j]] * scoreMultiplier;
        }
      }
    });
  }

  /// 手役、出来役のラウンドスコアを集計
  void _calcScoreOfYaku() {
    var tmpScoreOfTeyaku = [
      _players[0].scoreOfRound[phaseNames[0]],
      _players[1].scoreOfRound[phaseNames[0]],
      _players[2].scoreOfRound[phaseNames[0]]
    ];
    var tmpScoreOfDekiyaku = [
      _players[0].scoreOfRound[phaseNames[1]],
      _players[1].scoreOfRound[phaseNames[1]],
      _players[2].scoreOfRound[phaseNames[1]]
    ];

    if (_isSouhachi()) {
      _calcSouhachi();
    }

    for (int i = 0; i < _players.length; i++) {
      for (int j = 0; j < 2; j++) {
        _players[i].scoreOfRound[phaseNames[j]] *= 2;
      }
    }
    for (int i = 0; i < _players.length; i++) {
      _players[i].scoreOfRound[phaseNames[0]] -=
          (tmpScoreOfTeyaku[(i + 1) % 3] + tmpScoreOfTeyaku[(i + 2) % 3]);
      _players[i].scoreOfRound[phaseNames[1]] -=
          (tmpScoreOfDekiyaku[(i + 1) % 3] + tmpScoreOfDekiyaku[(i + 2) % 3]);
    }
  }

  /// 出来役なしだけのラウンドスコアを集計
  void _calcScoreOfNoDekiyaku() {
    for (int i = 0; i < _players.length; i++) {
      _players[i].scoreOfRound[phaseNames[2]] -= 88;
    }
  }

  /// 総八のときの得点修正
  void _calcSouhachi() {
    _players[numberOfParent].scoreOfRound[phaseNames[1]] += 100;
    for (int i = 1; i <= 2; i++) {
      _players[(numberOfParent + i) % 2].scoreOfRound[phaseNames[1]] -= 50;
    }
  }

  /// 月++
  void _incrementMonth() {
    setState(
      () {
        this._month++;
        if (this._month > 12) {
          this._month %= 12;
        }
      },
    );
  }

  /// プレイヤーの得点初期化
  void _initializeScores() {
    setState(
      () {
        for (int i = 0; i < _players.length; i++) {
          for (int j = 0; j < phaseNames.length; j++) {
            _players[i].scoreOfRound[phaseNames[j]] = 0;
          }
        }
      },
    );
  }

  /// 2ラウンド目以降の親決め//1回目の親決めもここに組み込もう
  /// 前ラウンドの出来役マンか「出来役なし」点の最強が親
  void _decideParent() {
    int max = 0, numOfMax;
    for (int i = 0; i < _players.length; i++) {
      //出来役がある場合
      if (_players[i].scoreOfRound[phaseNames[1]] > 0) {
        numberOfParent = i;
        return;
      } else {
        if (max < _players[i].scoreOfRound[phaseNames[2]]) {
          max = _players[i].scoreOfRound[phaseNames[2]];
          numOfMax = i;
        }
      }
    }
    numberOfParent = numOfMax;
  }

  /// 出来役があるかチェック
  bool _doDekiyakuExist() {
    int dekiyakuCnt = 0;
    for (int i = 0; i < _players.length; i++) {
      if (_players[i].scoreOfRound[phaseNames[1]] > 0) {
        dekiyakuCnt++;
      }
    }
    if (dekiyakuCnt > 0) {
      return true;
    } else {
      return false;
    }
  }

  /// 出来役なしの合計値の妥当性チェック
  bool _isValidTotalOfRound() {
    int sum = 0;
    for (int i = 0; i < _players.length; i++) {
      sum += _players[i].scoreOfRound[phaseNames[2]];
    }
    if (_doDekiyakuExist()) {
      if (sum != 0) {
        UsefulModules.showConfirm(
            context: context,
            title: 'ちがうよ！',
            body: '出来役がある場合、\n「出来役なし」タブの得点合計が0になる必要があります。',
            onlyOK: true);
        return false;
      }
    } else {
      if (sum != 88 * 3) {
        UsefulModules.showConfirm(
            context: context,
            title: 'ちがうよ！',
            body: '出来役がない場合、\n「出来役なし」タブの得点合計は88×3＝264になる必要があります。',
            onlyOK: true);
        return false;
      }
    }
    return true;
  }

  /// 総八判定
  bool _isSouhachi() {
    int souhachiCnt = 0;
    for (int i = 0; i < _players.length; i++) {
      if (_players[i].scoreOfRound[phaseNames[2]] == 88) {
        souhachiCnt++;
      }
    }
    if (souhachiCnt == _players.length) {
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
    return Container(
        child: Text('${this._month}月', style: TextStyle(fontSize: 20.0)));
  }

  /// 場の選択肢表示
  _showFieldSelection() {
    return DropdownButton<String>(
      value: _nameOfField,
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
          _nameOfField = newValue;
          switch (_nameOfField) {
            case '小場':
              {
                scoreMultiplier = 1;
              }
              break;

            case '大場':
              {
                scoreMultiplier = 2;
              }
              break;

            case '絶場':
              {
                scoreMultiplier = 4;
              }
              break;

            default:
              {
                scoreMultiplier = 1;
              }
              break;
          }
        });
      },
      items: <String>['小場', '大場', '絶場']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

//  _showFieldSelection() {
//    return Container(
//      child: Column(
//        children: <Widget>[
//          Flexible(
//            fit: FlexFit.loose,
//            child: RadioListTile(
//                title: Text('小場'),
//                groupValue: scoreMultiplier,
//                activeColor: Colors.green,
//                value: 1,
//                dense: true,
//                selected: true,
//                onChanged: _handleScoreMultiplier),
//          ),
//          Flexible(
//            fit: FlexFit.loose,
//            child: RadioListTile(
//                title: Text('大場'),
//                groupValue: scoreMultiplier,
//                activeColor: Colors.green,
//                value: 2,
//                dense: true,
//                onChanged: _handleScoreMultiplier),
//          ),
//          Flexible(
//            fit: FlexFit.loose,
//            child: RadioListTile(
//                title: Text('絶場'),
//                groupValue: scoreMultiplier,
//                activeColor: Colors.green,
//                value: 4,
//                dense: true,
//                onChanged: _handleScoreMultiplier),
//          ),
//        ],
//      ),
//    );
//  }

//  _showFieldSelection() {
//    return Container(
//      child: Column(
//        children: <Widget>[
//          ListTile(
//              title: const Text('小場'),
//              leading: Radio(
//                  groupValue: scoreMultiplier,
//                  activeColor: Colors.green,
//                  value: 1,
//                  onChanged: _handleScoreMultiplier)),
//          ListTile(
//              title: const Text('大場'),
//              leading: Radio(
//                  groupValue: scoreMultiplier,
//                  activeColor: Colors.green,
//                  value: 2,
//                  onChanged: _handleScoreMultiplier)),
//          ListTile(
//              title: const Text('絶場'),
//              leading: Radio(
//                  groupValue: scoreMultiplier,
//                  activeColor: Colors.green,
//                  value: 4,
//                  onChanged: _handleScoreMultiplier)),
//        ],
//      ),
//    );
//  }

//  void _handleScoreMultiplier(int num) => setState(() {
//        scoreMultiplier = num;
//      });

  /// 月の雑学の表示
  Future _showTriviaOfMonth() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        title: new Text('$_month月'),
        content: Padding(
          padding: EdgeInsets.all(0.0),
          child: SingleChildScrollView(
              child: new Text(TriviaOfMonth.getTrivia(_month))),
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
    for (int i = 0; i < _players.length; i++) {
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
