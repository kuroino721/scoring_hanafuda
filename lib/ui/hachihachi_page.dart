import 'package:flutter/material.dart';
import 'package:flutter_app/info/hachihachi_field.dart';
import 'package:flutter_app/strings/trivia_of_month.dart';
import 'package:flutter_app/useful_module/useful_module.dart';
import 'package:flutter_app/info/hachihachi_player.dart';
import 'package:flutter_app/info/hachihachi_hand.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/ui/widget.dart';
import 'package:flutter_app/info/game.dart';

import 'dart:math' as math;

List<HachihachiField> fieldList = [
  HachihachiField('小場', 1),
  HachihachiField('大場', 2),
  HachihachiField('絶場', 4)
];

class HachihachiPage extends StatefulWidget {
  HachihachiPage({this.title});
  final String title;

  @override
  HachihachiPageState createState() => HachihachiPageState();
}

class HachihachiPageState extends State<HachihachiPage> {
  List<HachihachiPlayer> _players = [
    HachihachiPlayer('player1'),
    HachihachiPlayer('player2'),
    HachihachiPlayer('player3')
  ];

  List<HachihachiField> _field = [fieldList[0]];
  List<TextEditingController> _playerController0;
  List<TextEditingController> _playerController1;
  List<TextEditingController> _playerController2;
  List<List<TextEditingController>> _controller;

  Game _game = Game();
  @override
  void initState() {
    super.initState();
    _playerController0 = [
      TextEditingController(text: '0'),
      TextEditingController(text: '0')
    ];
    _playerController1 = [
      TextEditingController(text: '0'),
      TextEditingController(text: '0')
    ];
    _playerController2 = [
      TextEditingController(text: '0'),
      TextEditingController(text: '0')
    ];
    _controller = [_playerController0, _playerController1, _playerController2];
    _decideParent();
    // Scaffoldが立ち上がるのを待ってから発動する処理
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _showFieldSelector();
    });
  }

  @override
  void dispose() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 2; j++) {
        _controller[i][j].dispose();
      }
    }
    super.dispose();
  }

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    MonthWidget(
                        month: _game.month,
                        showMonthTrivia: _showMonthTrivia,
                        size: 20),
                    _showField(),
                  ],
                ),
                _showMonthScoreTable(),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          RaisedButton(
                            onPressed: _showTotalScores,
                            child: Text('合計'),
                          ),
                          RaisedButton(
                            onPressed: () => UsefulModules.showConfirm(
                                context: context,
                                title: '役一覧',
                                body: '工事中です',
                                onlyOK: true),
                            child: Text('役一覧'),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          RaisedButton(
                            onPressed: _goToNextRound,
                            child: Text('次の月へ'),
                          ),
                          RaisedButton(
                            onPressed:
                                _game.round == 1 ? null : _backToPrevRound,
                            child: Text('前の月へ'),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          RaisedButton(
                            onPressed: _finishGame,
                            child: Text('終了'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 月の得点表
  _showMonthScoreTable() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Table(
          border: TableBorder.all(),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(children: [
              Text('', textAlign: TextAlign.center),
              _showPlayerName(1),
              _showPlayerName(2),
              _showPlayerName(3),
            ]),
            TableRow(children: [
              Text('手役', textAlign: TextAlign.center),
              _showMonthScore(playerNum: 1, phase: 0),
              _showMonthScore(playerNum: 2, phase: 0),
              _showMonthScore(playerNum: 3, phase: 0),
            ]),
            TableRow(children: [
              Text('出来役/取札', textAlign: TextAlign.center),
              _showMonthScore(playerNum: 1, phase: 1),
              _showMonthScore(playerNum: 2, phase: 1),
              _showMonthScore(playerNum: 3, phase: 1),
            ])
          ]),
    );
  }

  /// プレイヤー名表示（編集可能）
  _showPlayerName(int playerNum) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_showParent(playerNum)),
        Container(
          width: 100,
          child: TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                hintText: _players[playerNum - 1].name,
                hintStyle: TextStyle(color: Colors.black87)),
            onChanged: (text) {
              if (text.length > 0) {
                setState(
                  () {
                    _players[playerNum - 1].name = text;
                  },
                );
              }
            },
          ),
        )
      ],
    );
  }

  /// 累計得点の表示
  // TODO: 表示した瞬間にスクロールを一番上にしたい（なんか最初はみ出して表示されるため）
  Future _showTotalScores() async {
    logger.i('show total score');
    return await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('合計点'),
          content: SingleChildScrollView(
            child: DataTable(
              columns: [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Total')),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text(
                      _players[0].name,
                    )),
                    DataCell(Text(
                      _players[0].totalScore.last.toString(),
                    )),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(
                      _players[1].name,
                    )),
                    DataCell(Text(
                      _players[1].totalScore.last.toString(),
                    )),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text(
                      _players[2].name,
                    )),
                    DataCell(Text(
                      _players[2].totalScore.last.toString(),
                    )),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );
  }

  /// 場の選択画面の表示
  _showField() {
    return FlatButton(
      child: Text(_field.last.name, style: TextStyle(fontSize: 20)),
      onPressed: _showFieldSelector,
    );
  }

  /// 月の得点（個人）
  _showMonthScore({int playerNum, int phase}) {
    return TextField(
      controller: _controller[playerNum - 1][phase],
      textAlign: TextAlign.center,
      onChanged: (text) {
        if (text.length > 0) {
          setState(
            () {
              _players[playerNum - 1].monthScore[phase] = int.parse(text);
            },
          );
        }
      },
    );
  }

  /// 親表示
  String _showParent(int playerNum) {
    if (_players[playerNum - 1].parent.last) {
      return '[親]';
    } else {
      return '';
    }
  }

  /// 次の月へ
  void _goToNextRound() {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('次の月へ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('再戦しますか？'),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context, false),
          ),
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    ).then(
      (result) {
        if (result) {
          logger.i("go to next round");
          _totalUpScores().then((result) {
            if (result == 0) {
              _game.incrementMonth();
              _game.incrementRound();
              _decideParent();
              _initMonthScores();
              for (int i = 0; i < 3; i++) {
                for (int j = 0; j < 2; j++) {
                  _controller[i][j].text = '0';
                }
              }
              _showTotalScores().then((result) {
                if (result) {
                  _field.add(_field.last);
                  _showFieldSelector();
                }
              });
            }
          });
        }
      },
    );
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
          _players[i].parent.removeLast();
          if (_game.round == 1)
            logger.e("back round button was pushed in spite of round 1");
          if (_game.round == 2) {
            _players[i].totalScore.last = 0;
          } else {
            _players[i].totalScore.last = _players[i].totalScore[
                _game.round - 3]; //roundは1-based, indexは0-basedなので2ではなく3を引く
          }
        }
        _field.removeLast();
        _game.decrementMonth();
        _game.decrementRound();
        _initMonthScores();
      }
    });
  }

  /// ラウンド終了時の点数集計
  Future<int> _totalUpScores() async {
    //出来役or取札が1つ以外0か、あるいは合計値が88*3かを確認
    if (!_isValidNonTeyakuScore()) {
      UsefulModules.showConfirm(
          context: context,
          title: 'ちがうよ',
          body:
              '出来役ができた場合は2人が0点である必要があります。\n出来役がない場合は3人の合計が88×3＝264点である必要があります。',
          onlyOK: true);
      logger.i("invalid score");
      return 1;
    }
    //総八なら親に50点
    if (HachihachiHand(players: _players).isAll88()) {
      await UsefulModules.showConfirm(
          context: context,
          title: '総八',
          body: '総八だよ！',
          onlyOK: true,
          okSelection: 'やった！');
      for (int i = 0; i < 3; i++) {
        if (_players[i].parent.last) {
          _players[i].monthScore[1] = 50;
        } else {
          _players[i].monthScore[1] = 0;
        }
      }
    }

    //二八ならその人に50点
    if (HachihachiHand(players: _players).getFutahachiPlayer() != null) {
      HachihachiPlayer _futahachiPlayer =
          HachihachiHand(players: _players).getFutahachiPlayer();
      await UsefulModules.showConfirm(
          context: context,
          title: '二八',
          body: '${_futahachiPlayer.name}さんが二八だよ！',
          onlyOK: true,
          okSelection: 'つよい！');
      for (int i = 0; i < 3; i++) {
        if (_players[i] == _futahachiPlayer) {
          _players[i].monthScore[1] = 50;
        } else {
          _players[i].monthScore[1] = 0;
        }
      }
    }

    //各プレイヤーの月の最終得点を計算
    List<int> _calculatedMonthScore = List.filled(3, 0);
    for (int i = 0; i < 3; i++) {
      //手役
      _calculatedMonthScore[i] += _players[i].monthScore[0] * 2 -
          _players[(i + 1) % 3].monthScore[0] -
          _players[(i + 2) % 3].monthScore[0];
      //出来役
      if (_dekiyakuExists()) {
        _calculatedMonthScore[i] += _players[i].monthScore[1] * 2 -
            _players[(i + 1) % 3].monthScore[1] -
            _players[(i + 2) % 3].monthScore[1];
      } else {
        //出来役なし
        _calculatedMonthScore[i] += _players[i].monthScore[1] - 88;
      }
    }

    for (int i = 0; i < 3; i++) {
      _calculatedMonthScore[i] *= _field.last.scoreMagnification;
      //各プレイヤーのtotalに加算
      _players[i].totalScore.last += _calculatedMonthScore[i];
      //次ラウンドのtotalの枠を追加
      _players[i].totalScore.add(_players[i].totalScore[_game.round - 1]);
    }
    return 0;
  }

  /// プレイヤーの得点初期化
  void _initMonthScores() {
    setState(() {
      for (int i = 0; i < _players.length; i++) {
        _players[i].initMonthScore();
      }
    });
  }

  /// 出来役がない場合のスコア合計が88*3であることの確認
  bool _isValidNonTeyakuScore() {
    int _sum = 0;
    for (int i = 0; i < 3; i++) {
      _sum += _players[i].monthScore[1];
    }
    if (_dekiyakuExists() || _sum == 88 * 3) {
      return true;
    } else {
      return false;
    }
  }

  /// 出来役ができているかどうかの確認
  bool _dekiyakuExists() {
    int _zeroCnt = 0;
    for (int i = 0; i < 3; i++) {
      if (_players[i].monthScore[1] == 0) {
        _zeroCnt++;
      }
    }
    if (_zeroCnt == 2 ||
        HachihachiHand(players: _players).isAll88() ||
        HachihachiHand(players: _players).getFutahachiPlayer() != null) {
      return true;
    } else {
      return false;
    }
  }

  /// 親決め
  void _decideParent() {
    //ラウンド1ならランダムで決める
    if (_game.round == 1) {
      var random = math.Random();
      _players[random.nextInt(3)].parent.last = true;
    } else {
      // 次の月の分の要素を追加
      for (int i = 0; i < 3; i++) {
        _players[i].parent.add(false);
      }
      // 出来役ありなら出来役の人が親
      if (_dekiyakuExists()) {
        for (int i = 0; i < 3; i++) {
          if (_players[i].monthScore[1] > 0) {
            _players[i].parent.last = true;
          }
        }
      } else {
        // 出来役なしなら取り札が最高得点の人が親
        int _mx = 0;
        List<int> _mxPlayerNum = [];
        for (int i = 0; i < 3; i++) {
          if (_mx <= _players[i].monthScore[1]) {
            if (_mx == _players[i].monthScore[1]) {
              _mxPlayerNum.add(i + 1);
            } else {
              _mxPlayerNum = [i + 1];
              _mx = _players[i].monthScore[1];
            }
          }
        }
        // 同率1位がいた場合に備えた乱択（読みづらい...）
        _players[_mxPlayerNum[math.Random().nextInt(_mxPlayerNum.length)] - 1]
            .parent
            .last = true;
      }
    }
  }

  /// onPressedから引数が必要なメソッドを呼び出すためだけのvoidメソッド
  void _showMonthTrivia() {
    TriviaOfMonth.showMonthTrivia(context: context, month: _game.month);
  }

  /// 場の選択肢表示
  void _showFieldSelector() {
    logger.i('show field selector');
    showDialog(
        context: context,
        builder: (_) => FieldSelectorDialog(
            field: _field.last, changeMagnification: _changeMagnification));
  }

  List<HachihachiPlayer> _decideWinner() {
    List<HachihachiPlayer> winners = [];
    int _mx = 0;
    for (int i = 0; i < 3; i++) {
      if (_mx <= _players[i].totalScore.last) {
        if (_mx < _players[i].totalScore.last && winners.length != 0) {
          winners = [];
          _mx = _players[i].totalScore.last;
        }
        winners.add(_players[i]);
      }
    }
    return winners;
  }

  /// 勝敗ダイアログ
  Future _showGameResult() async {
    String scoreText, resultText;
    scoreText = "${_players[0].name}さん: ${_players[0].totalScore.last}文\n"
        "${_players[1].name}さん: ${_players[1].totalScore.last}文\n"
        "${_players[2].name}さん: ${_players[2].totalScore.last}文\n";
    List<HachihachiPlayer> winners = _decideWinner();
    if (winners.length == 1) {
      resultText = "${winners[0].name}さんの勝ちです！おみごと！";
    } else if (winners.length == 2) {
      resultText = "${winners[0].name}, ${winners[1].name}さんの勝ちです！あっぱれ！";
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('結果'),
        content: Center(
          child: Text(scoreText + '\n' + resultText),
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
        .then(
      (result) {
        if (result) {
          logger.i("finish game");
          _totalUpScores().then((result) {
            if (result == 0) {
              _showGameResult();
            }
          });
        }
      },
    );
  }

  void _changeMagnification(HachihachiField _selectedField) {
    setState(() {
      _field.last = _selectedField;
    });
  }
}

class FieldSelectorDialog extends StatefulWidget {
  FieldSelectorDialog({this.field, this.changeMagnification});

  final HachihachiField field;
  final void Function(HachihachiField) changeMagnification;

  @override
  FieldSelectorDialogState createState() => FieldSelectorDialogState();
}

class FieldSelectorDialogState extends State<FieldSelectorDialog> {
  HachihachiField _selectedField;

  void _onValueChange(HachihachiField value) {
    setState(() {
      _selectedField = value;
    });
    widget.changeMagnification(_selectedField);
  }

  @override
  void initState() {
    super.initState();
    _selectedField = widget.field;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('場の選択'),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          RadioListTile(
              activeColor: Colors.blue,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(fieldList[0].name),
              value: fieldList[0],
              groupValue: _selectedField,
              onChanged: _onValueChange),
          RadioListTile(
              activeColor: Colors.blue,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(fieldList[1].name),
              value: fieldList[1],
              groupValue: _selectedField,
              onChanged: _onValueChange),
          RadioListTile(
              activeColor: Colors.blue,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(fieldList[2].name),
              value: fieldList[2],
              groupValue: _selectedField,
              onChanged: _onValueChange),
        ],
      ),
      actions: <Widget>[
        FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            }),
      ],
    );
  }
}
