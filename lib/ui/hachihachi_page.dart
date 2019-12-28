import 'package:flutter/material.dart';
import 'package:flutter_app/strings/trivia_of_month.dart';
import 'package:flutter_app/ui/home_page.dart';
import 'package:flutter_app/useful_module/useful_module.dart';
import 'dart:math' as math;

final List<String> nameOfPhases = ['手役', '出来役', '出来役なし'];

class HachihachiPlayer {
  String name;
  HachihachiPlayer(this.name);
  var scoreOfRound = {
    nameOfPhases[0]: 0,
    nameOfPhases[1]: 0,
    nameOfPhases[2]: 0,
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
  Choice(title: nameOfPhases[0]),
  Choice(title: nameOfPhases[1]),
  Choice(title: nameOfPhases[2]),
];

class HachihachiState extends State<HachihachiPage> {
  final String title = 'Scoring Hachihachi';
  int _month = 1;
  final players = [
    new HachihachiPlayer('player1'),
    new HachihachiPlayer('player2'),
    new HachihachiPlayer('player3')
  ];
  int scoreMultiplier = 1; //得点の倍率
  String _nameOfField = '小場';
  int numberOfParent = math.Random().nextInt(2);

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
              _showInfoOfPhase(nameOfPhases[0]),
              _showInfoOfPhase(nameOfPhases[1]),
              _showInfoOfPhase(nameOfPhases[2]),
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
                players[number - 1].scoreOfRound[phase] = int.parse(text);
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
              //
            }
            _addRoundScoreToTotal();
            _incrementMonth();
            _initializeScores();
            _nameOfField = '小場';
            _decideParent();
          }
        }
      },
    );
  }

  /// ラウンドのスコアをtotalに加える
  void _addRoundScoreToTotal() {
//    var beforeCalcScoreOfYaku = [[], []];
//    beforeCalcScoreOfYaku[0] = [
//      players[0].scoreOfRound[nameOfPhases[0]],
//      players[1].scoreOfRound[nameOfPhases[0]],
//      players[2].scoreOfRound[nameOfPhases[0]]
//    ];
//    beforeCalcScoreOfYaku[1] = [
//      players[0].scoreOfRound[nameOfPhases[1]],
//      players[1].scoreOfRound[nameOfPhases[1]],
//      players[2].scoreOfRound[nameOfPhases[1]]
//    ];
    setState(() {
      for (int i = 0; i < players.length; i++) {
        // 出来役なしの全員の入力から88点引く
        if (_doDekiyakuExist() == false) {
          if (!_isSouhachi()) {
            players[i].scoreOfRound[nameOfPhases[2]] -= 88;
          } else {
            //親に+50
          }
        }
//        // 手役、出来役の点数を他から奪う
//        for (int j = 0; j < nameOfPhases.length; j++) {
//          if (j == i) {
//            for (int k = 0; k < 2; k++) {
//              players[j].scoreOfRound[nameOfPhases[k]] +=
//                  beforeCalcScoreOfYaku[k][i];
//            }
//          } else {
//            for (int k = 0; k < 2; k++) {
//              players[j].scoreOfRound[nameOfPhases[k]] -=
//              beforeCalcScoreOfYaku[k][i]/2;
//            }
//          }
//        }
//      }
        // 累計得点にその月の得点を足す
//        for (int i = 0; i < players.length; i++) {
        for (int j = 0; j < nameOfPhases.length; j++) {
          players[i].totalScore +=
              players[i].scoreOfRound[nameOfPhases[j]] * scoreMultiplier;
        }
      }
    });
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
        for (int i = 0; i < players.length; i++) {
          for (int j = 0; j < nameOfPhases.length; j++) {
            players[i].scoreOfRound[nameOfPhases[j]] = 0;
          }
        }
      },
    );
  }

  /// 2ラウンド目以降の親決め
  /// 前ラウンドの出来役マンか「出来役なし」点の最強が親
  void _decideParent() {
    int max = 0, numOfMax;
    for (int i = 0; i < players.length; i++) {
      //出来役がある場合
      if (players[i].scoreOfRound[nameOfPhases[1]] > 0) {
        numberOfParent = i;
        return;
      } else {
        if (max < players[i].scoreOfRound[nameOfPhases[2]]) {
          max = players[i].scoreOfRound[nameOfPhases[2]];
          numOfMax = i;
        }
      }
    }
    numberOfParent = numOfMax;
  }

  /// ラウンドの合計得点
  List<int> _calcTotalScoreOfRound() {}

  /// 出来役があるかチェック
  bool _doDekiyakuExist() {
    int dekiyakuCnt = 0;
    for (int i = 0; i < players.length; i++) {
      if (players[i].scoreOfRound[nameOfPhases[1]] > 0) {
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
    for (int i = 0; i < players.length; i++) {
      sum += players[i].scoreOfRound[nameOfPhases[2]];
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
    for (int i = 0; i < players.length; i++) {
      if (players[i].scoreOfRound[nameOfPhases[2]] == 88) {
        souhachiCnt++;
      }
    }
    if (souhachiCnt == players.length) {
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
            DataCell(Text(players[0].name, style: TextStyle(fontSize: 20.0))),
            DataCell(Text(players[0].totalScore.toString(),
                style: TextStyle(fontSize: 20.0))),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text(players[1].name, style: TextStyle(fontSize: 20.0))),
            DataCell(Text(players[1].totalScore.toString(),
                style: TextStyle(fontSize: 20.0))),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text(players[2].name, style: TextStyle(fontSize: 20.0))),
            DataCell(Text(players[2].totalScore.toString(),
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
    UsefulModules.showConfirm(context: context, title: 'ゲーム終了', body: '終了しますか？')
        .then(
      (result) {
        if (result) {
          _addRoundScoreToTotal();
          _showResultOfGame();
        }
      },
    );
  }
}
