import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // このウィジェットはアプリケーションのルートです。
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Scoring Hanafuda',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: HomePage(title: 'Scoring Hanafuda'),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => new HomePage(title: 'Scoring Hanafuda'),
          '/koikoi': (BuildContext context) => new KoikoiPage(),
//        '/hachihachi': (BuildContext context) => new HachihachiPage(),
        });
  }
}

class HomePage extends StatelessWidget {
  final String title;
  HomePage({this.title});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RaisedButton(
              onPressed: () => Navigator.pushNamed(context, "/koikoi"),
              child: new Text('こいこい'),
            ),
            RaisedButton(
              onPressed: () => Navigator.pushNamed(context, "/hachihachi"),
              child: new Text('はちはち'),
            ),
          ],
        ),
      ),
    );
  }
}

class KoikoiPage extends StatefulWidget {
  @override
  KoikoiState createState() => new KoikoiState();
}

class KoikoiState extends State<KoikoiPage> {
  final String title = 'Scoring Koikoi';
  List<int> score = new List.filled(2, 0);
  List<int> totalScoreOfPlayer = new List.filled(2, 0);
  int month = 1;

  //プレイヤー名
  _nameOfPlayer(int numOfPlayer) {
    return Container(
      child: Center(
        child: new TextField(
          decoration: InputDecoration(
              border: InputBorder.none, hintText: 'Player$numOfPlayer'),
        ),
      ),
    );
  }

  //プレイヤーの得点
  _scoreOfPlayer(int numOfPlayer) {
    return Container(
      child: Center(
        child: new Text(score[numOfPlayer - 1].toString()),
      ),
    );
  }

  //プレイヤーの得点初期化
  void _initializeScores() {
    setState(() {
      for (int i = 0; i < this.score.length; i++) {
        score[i] = 0;
      }
    });
  }

  //点数++
  void _incrementScore(int numOfPlayer) {
    setState(() {
      score[numOfPlayer - 1]++;
    });
  }

  //点数--
  void _decrementScore(int numOfPlayer) {
    setState(() {
      score[numOfPlayer - 1]--;
    });
  }

  //+-ボタン
  _buttonToScore(int numOfPlayer) {
    return Container(
      child: Row(
        children: <Widget>[
          RaisedButton(
            onPressed: () => _incrementScore(numOfPlayer),
            child: new Text('+'),
          ),
          RaisedButton(
            onPressed: () => _decrementScore(numOfPlayer),
            child: new Text('-'),
          ),
        ],
      ),
    );
  }

  //累計得点の表示
  _showTotalScoreOfPlayer(int numOfPlayer) {
    return Container(
      child: new Text('total: ${totalScoreOfPlayer[numOfPlayer - 1]}'),
    );
  }

  //月++
  void _incrementMonth() {
    setState(() {
      this.month++;
      if (this.month > 12) {
        this.month %= 12;
      }
    });
  }

  //月の表示
  _showMonth(int month) {
    return Container(
      child: new Text('$month月'),
    );
  }

  //確認画面表示
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
    if (result) {
      return true;
    } else {
      return false;
    }
  }

  //再戦
  void _goToNextRound() {
    _showConfirm(title: '再戦', body: '再戦しますか？').then((result) {
      if (result) {
        _incrementMonth();
        _initializeScores();
      }
    });
  }

  //月の雑学の表示
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

  //終了
  void _finishGame() {
    _showConfirm(title: 'ゲーム終了', body: '終了しますか？').then((result) {
      if (result) {
        Navigator.push(
          context,
          MaterialPageRoute(
              settings: RouteSettings(name: "/home"),
              builder: (BuildContext context) => HomePage(title: 'ScoringHanafuda')),
        );
      }
    });
  }

  //中央のバー
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

  //ルートレイアウト
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(title),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Transform.rotate(
              angle: math.pi,
              child: _scoreOfPlayer(1),
            ),
            _centerBar(),
            _nameOfPlayer(2),
            _scoreOfPlayer(2),
          ],
        ),
      ),
    );
  }
}

//月の雑学
class TriviaOfMonth {
  static final List<String> triviaOfJanuary = [
    "1月は花札で言うと「松に鶴」です。\n"
        "松は冬でも葉が落ちないため古来より長寿の象徴とされ、正月の門松などの縁起物で親しまれてきました。\n"
        "同じく鶴も「鶴は千年、亀は万年」という言葉のように、長寿の象徴として知られています。\n"
        "実際の風景で松と鶴を一緒に目にすることはほとんどありませんが、\n"
        "花札の中で縁起物の組み合わせを堪能することができます。",
    "花札で言うと1月は「松に鶴」です。\n"
        "松というと、海岸沿いに美しく並ぶ松林を想像される方も多いと思いますが、なぜ松が海沿いによく生えているのかご存知ですか？\n"
        "そもそも松には赤松と黒松の二種類があって、海沿いによく生えているのは黒松のほうです。黒松は非常に乾燥した土地でも成長できる強い植物で、もともと海沿いに生息していましたが、今の松林のように一列に並んではいませんでした。それではこれがどうして現在の形になったかというと、ずばり人の手によるものだからです。昔から海岸沿いに住む人たちは、海風によって運ばれる砂による害に苦しめられていました。そこで、黒松の丈夫さと、一年中葉を付けることによる防砂効果に目を付けて、日本中で防砂林・防風林として植樹していったのだそうです。\n"
        "普段よく目にする光景も、人々の知恵・努力の結晶だということがよくわかりますね。"
  ];
  static final List<String> triviaOfFebruary = [
    "2月は花札で言うと「梅に鶯」です。\n"
        "「ホーホケキョ」の鳴き声で有名な鶯は春先に鳴き始めるので「春告鳥」とも呼ばれます。\n"
        "同じくこの時期に咲く梅との相性は抜群で、「梅に鶯」は取り合わせの良いものの例えとしてもよく使われます。\n"
        "古くは万葉集にも梅に鶯はセットで詠まれており、昔から日本人の季節感を象徴してきたものなんですね。",
    "2月は花札で言うと「梅に鶯」です。\n"
        "「ホーホケキョ」の鳴き声で親しまれ、日本三鳴鳥（ウグイス・オオルリ・コマドリ）の一羽としても知られるウグイス。さて、みなさんはウグイスの色というとどんな色を想像しますか？\n"
        "鮮やかな緑色だと思った方は残念ながら間違いです。「うぐいす餡」などで明るい緑色のイメージがありますが、実際のウグイスの色は灰色～緑がかった茶色で、うぐいす餡の色とは全く異なります。花札に描かれているウグイスもやはり鮮やかな緑色をしており、外見だけだとメジロのように見えます。さらには梅の花によく来るのはメジロであり、ホトトギスはめったに梅の花に寄り付かないので、混乱に拍車がかかっています。鮮やかな緑色で目の周りが白い鳥は「メジロ」ですので、間違えないよう皆さん注意してくださいね。"
  ];
  static final List<String> triviaOfMarch = [
    "3月は花札でいうと「桜に幕」です。\n"
        "春といえば桜、日本人が最も愛する花と言っても過言ではないでしょう。\n"
        "\n"
        "ところでみなさん、桜と梅の違いってご存知ですか？\n"
        "開花期が違う、梅のほうが花弁が丸いなどの特徴はありますが、\n"
        "やはり一目でわかる違いは「桜は花柄が長い」ことでしょう。\n"
        "花柄とは枝と花を結ぶ小さな枝のことで、分かりやすく言うとサクランボの枝の部分、これが花柄です。\n"
        "サクランボを見ればわかる通り、桜は花柄が長く発達していますが、\n"
        "梅は花柄が短く、直接枝から花が咲いているような見た目になることが特徴です。"
  ];
  static final List<String> triviaOfApril = [
    "いよいよ4月、出会いと始まりの季節です。皆さま新しい環境で慣れないこともあるかと思いますが、体を壊されないようお気を付けください。\n"
        "ここからは余談ですが、みなさん花札ってご存知ですか？\n"
        "花札はトランプに似たかるたの一種で、日本の伝統的な遊戯の一つです。\n"
        "特徴的なのは、合計48枚の札が12か月×4種類に分けられ、それぞれの札には季節を代表する花や動物などが描かれていることです。\n"
        "そして4月の札に描かれているのは「藤とホトトギス」。\n"
        "ホトトギスは「鳴かぬなら殺してしまえホトトギス」などの川柳でもおなじみの鳥で、\n"
        "「テッペンカケタカ」という鳴き声で知られています。\n"
        "ちなみに鳥だけでなくホトトギスという名前の植物もいて、こちらは鳥のホトトギスの模様に似ている花をつけることから命名されました。\n"
        "みなさんホトトギスには鳥と植物の２種類がいることをぜひ覚えてみてください。",
    "花札でいうと、4月は「藤に杜鵑（ホトトギス）」ですね。\n"
        "藤はちょうど4月から6月にかけて咲き、ゴールデンウィークごろに満開となります。京都では鳥羽水環境保全センターにて藤棚の一般開放が行われているので、近くにお住まいの方は一度足を運ばれてはいかがでしょうか。私も一度行ったことがありますが、とても下水処理場とは思えない美しい光景に魅了されました。\n"
        "杜鵑は本来6月～8月の鳥ですが、なぜか花札では4月の札に姿を見せます。「テッペンカケタカ」という鳴き声や、カッコウと同じく、他の鳥の巣に托卵することで有名ですね。"
  ];
  static final List<String> triviaOfMay = [
    "花札で言うと5月は「菖蒲に八つ橋」です。\n"
        "菖蒲の花は、基調の青色にアクセントの黄色が映える美しい花です。見たことがない人は少ないと思いますが、これが5月5日の菖蒲湯に使われる菖蒲とは別物だということはご存知でしょうか（私は知りませんでした……）。\n"
        "花が咲くのはハナショウブと言って、アヤメ科アヤメ属の多年草です。\n"
        "一方、菖蒲湯に使うショウブはサトイモ科ショウブ属で科から異なりますし、葉は似ているものの花が咲きません。\n"
        "今までなんとなくそうだと思っていたことも、調べてみると驚かされることがよくありますね。",
    "花札で言うと5月は「菖蒲に八つ橋」です。\n"
        "八つ橋というと京都のおみやげを想像されるかもしれませんが、ここで言う八つ橋はジグザグ型をした変わった橋のこと。もともとは『伊勢物語』の東下りで源氏が立ち寄った三河の国、八橋という場所が由来です。川が蜘蛛の足のように分かれていたため橋がジグザグに架かっていることが語られ、源氏は\n"
        "「からころも着つつなれにしつましあればはるばる来ぬる旅をしぞ思ふ」\n"
        "という有名な歌を詠みます。\n"
        "今でも植物園などに行くと菖蒲の花と八つ橋を光景を目にすることがあります。\n"
        "ちょうどこれからが花の季節なので皆さん足を運んでみてはいかがでしょうか"
  ];
  static final List<String> triviaOfJune = [
    "6月は花札で言うと「牡丹に蝶」です。\n"
        "中国が原産の牡丹は、「花の王様」と呼ばれるにふさわしい豪華さが特徴です。\n"
        "「立てば芍薬座れば牡丹、歩く姿は百合の花」という言葉でも有名ですね。\n"
        "鮮やかな牡丹の花にひらひらと蝶が舞い寄る光景は、\n"
        "昔から美しい情景として語られてきたのでしょう。",
    "花札で言うと6月の花は牡丹です。\n"
        "「牡丹に唐獅子　竹に虎」という文句でも知られているように、牡丹と唐獅子（ライオンに似た想像上の生き物）には深い関係があります。獅子が牡丹の露を飲んで、体に巣くう虫を退治するという話が「獅子身中の虫」という言葉のもととなっています。\n"
        "また、「猪鍋」のことを「ぼたん鍋」と呼ぶことがありますが、これもこの諺が語源と言われています。一説には「獅子と牡丹」→「猪（しし）と牡丹」という風にイメージの連鎖で「ぼたん鍋」という言葉が生まれるに至ったそうです。そこから、肉を華やかに盛り付けて牡丹の花に見立てる様式が発達したと考えられています。\n"
        "どんな言葉にも語源は存在し、その真偽にかかわらず考えを巡らすのは楽しいものですね。"
  ];
  static final List<String> triviaOfJuly = [
    "7月の植物は花札で言うと「萩（ハギ）」です。\n"
        "萩はマメ科ハギ属の木の総称で、秋の七草のひとつ。\n"
        "毎年、春に根元から芽が生えてくることから、「生芽（はえぎ）」と呼ばれたのが語源だといわれています\n"
        "\n"
        "早いものだと梅雨終わりごろから咲きはじめるのですが、盛りは秋ごろで、古来より和歌が多く読まれてきました。\n"
        "万葉集では萩は１４２首に登場し、これは梅の１１９首を抑えて登場数第一位だそうです。\n"
        "萩の漢字も「くさかんむり」に「秋」ですから、まさに秋を代表する花と言えます。",
    "７月は花札で言うと「萩に猪」です。\n"
        "萩（ハギ）はマメ科の木で、秋の七草のひとつでもあります。\n"
        "一方漢字の似ている荻（オギ）はイネ科の一年草なので、見た目からして何もかも違います。\n"
        "いくら似ていても萩原さんと荻原さんでは全く異なりますので、皆さん注意してくださいね。\n"
        "猪は7月が活動期というわけではないのですが、昔から萩と猪はセットで描かれています。\n"
        "柔らかいイメージの萩と、猛々しさの象徴である猪（猪突猛進という言葉もありますね）の\n"
        "ほどよく調和のとれた景色をイメージすることができます。"
  ];
  static final List<String> triviaOfAugust = [
    "8月は花札で言うと「芒に満月」です。\n"
        "ススキはイネ科ススキ属の植物で、花は9月から10月にかけて咲きます。\n"
        "秋の終わりの枯れススキは、枯れ尾花として非常に風情のある光景を形作ります。\n"
        "「幽霊の正体見たり枯れ尾花」の枯れ尾花とはススキの枯れた姿のことなんですね。\n"
        "\n"
        "ススキは十五夜にお供えされるだけでなく、\n"
        "かつては萱葺き屋根の材料として重宝されていました。\n"
        "そのため、人里近くには必ず萱場（かやば）としてススキの栽培地があったのですが、\n"
        "今では需要がなくなり、ススキも姿を消しつつあります。\n"
        "人間の営みが変化するにつれ、景色も変わってきました。\n"
        "このことは、これからの環境問題を考えるうえでも非常に大切な観点なのではないでしょうか。"
  ];
  static final List<String> triviaOfSeptember = [
    "花札で言うと9月の花は菊です。\n"
        "菊というと皇室・皇族の家紋としても知られ、冠婚葬祭でもよく目にすることから日本人にとても身近な花ですね。\n"
        "春の桜に対して日本の秋を象徴する花ともいえますが、それが決定的になったのは、鎌倉時代の初め後鳥羽上皇が「菊紋」を皇室の家紋とした頃からだといわれているので、およそ900年ほどの歴史といえます。\n"
        "さて、普段よく使う100円硬貨の裏には桜紋が刻まれていますが、同じように菊紋が記された硬貨があります。それはなんでしょう？\n"
        "もし興味があれば調べてみてください。"
  ];
  static final List<String> triviaOfOctober = [
    "花札で言うと10月の札は「紅葉に鹿」です。\n"
        "新古今和歌集秋歌下に収められている藤原家隆の歌には以下のようなものがあります。\n"
        "下紅葉 かつ散る山の夕時雨 濡れてやひとり 鹿の鳴くらむ\n"
        "紅葉と時雨、そしてひとりで鳴く鹿という秋の物悲しい情景が描写されています。\n"
        "このように昔から紅葉と鹿はセットで扱われてきていて、今でも鹿肉のことは「もみじ」と呼ばれますね。\n"
        "\n"
        "ちなみに人を無視するという意味で使われる「しかと」という言葉は花札が語源ということはご存じでしたか？\n"
        "十月の「紅葉に鹿」の札で鹿がそっぽを向いていることから「鹿十（しかとお）」→「しかと」と変化して生まれたと言われています。"
  ];
  static final List<String> triviaOfNovember = [
    "11月は花札で言うと「柳と小野道風と蛙」です。\n"
        "小野道風は和様書道の基礎を築いた人物で、藤原佐理、藤原行成と合わせて「三跡」と称されます。なぜ柳と蛙なのかというと、道風のこんな逸話がもととなっているようです。\n"
        "\n"
        "「道風が、自分の才能のなさに自己嫌悪に陥り、書道をやめようかと真剣に悩んでいる程のスランプに陥っていた時のこと。ある雨の日散歩に出かけていて、柳に蛙が飛びつこうと、何度も挑戦している姿を見て「蛙はバカだ。いくら飛んでも柳に飛びつけるわけないのに」とバカにしていた時、偶然にも強い風が吹き、柳がしなり、見事に飛び移れた。これを見た道風は「バカは自分だ。蛙は一生懸命努力をして偶然を自分のものとしたのに、自分はそれほどの努力をしていない」と目が覚めるような思いをして、血を滲むほどの努力をするきっかけになったという」（Wikipediaより）\n"
        "\n"
        "9月は「菊」、10月は「紅葉」で季節と見ごろの自然が合っていましたが、柳は春に開花するので11月の花とは言えません。しかし、そんなことはどうでもよくなる程の感動的な、そして身につまされる話ですね。",
    "花札で言うと11月の花は「柳」です。しかし、実際には柳はこの時期に花を咲かせるわけではありません。そもそも柳の花のイメージってあまりありませんよね。\n"
        "\n"
        "実は、柳の開花時期は４月ごろです。春の芽出し前に黄色い花を咲かせるのですが、花といっても花びらがなく、それほど目立ちません。\n"
        "種子は綿のような毛がつき、5~6月に辺りを舞うのですが、日本で目にすることは少ないでしょう。というのも、私たちが柳と聞いて一番に思い浮かべる「シダレヤナギ」という種は雌雄異株で、日本ではそのほとんどが雄株だからです。\n"
        "柳の実が舞い流れる光景は柳絮（りゅうじょ）とも呼ばれ、なじみの少ない日本人からすると非常に風流に見えます。しかし、中国ではマスクをしないといけないほど舞うので嫌がられることも多いそうです。何事もほどほどが肝心ということでしょうか。"
  ];
  static final List<String> triviaOfDecember = [
    "12月は花札で言うと「桐に鳳凰」です。\n"
        "古くから桐は鳳凰の止まる木として神聖視されており、日本でも「菊の御紋」に次ぐ高貴な紋章とされてきました。花は4～5月に咲くので季節に合いませんが、12月ということで「これっ「きり」」という駄洒落の意味合いを込めて12月に桐が当てはめられたという説もあります。",
    "花札で言うと12月は「桐に鳳凰」です。\n"
        "これまで花札では季節の植物に加えてさまざまな動物が描かれてきましたが、12月だけ実際には存在しない生き物が登場します。\n"
        "鳳凰は「平等院鳳凰堂」などでご存知と思いますが、中国の故事では聖徳の天子の兆しとして出現すると言われる、大変めでたい存在です。日本でも吉祥の表れとして大切にされており、今でも一万円札の裏を覗けばその姿を確認することができます。\n"
        "ちなみに桐も500円玉の表に描かれており、桐と鳳凰は硬貨と紙幣それぞれの最高金額を代表する存在なわけですね（一万円札は福沢諭吉のイメージが圧倒的とは思いますが）。"
  ];

  static List<List<String>> triviaOfMonths = [
    triviaOfJanuary,
    triviaOfFebruary,
    triviaOfMarch,
    triviaOfApril,
    triviaOfMay,
    triviaOfJuly,
    triviaOfAugust,
    triviaOfSeptember,
    triviaOfOctober,
    triviaOfNovember,
    triviaOfDecember
  ];

  static String getTrivia(month) {
    month--;
    return triviaOfMonths[month]
        [math.Random().nextInt(triviaOfMonths[month].length)];
  }
}

//
//class _HomePageState extends State<HomePage> {
//  int _counter = 0;
//
//  void _incrementCounter() {
//    setState(() {
//      // setState()は、Flutterフレームワークに、状態の変更を伝え、後にあるビルドメソッド
//      // を呼び出して、新しい値をもとに画面を描き換えます。
//      // 仮に、setState()を使わずに_counterを更新しても、ビルドメソッドは呼ばれずに
//      // 画面は描き変わりません。
//      _counter++;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    // このビルドメソッドはsetState()が呼ばれる度に、動作します。具体的には、上の
//    // _incrementCounterメソッドによって動作します。
//    //
//    // Flutterフレームワークは、ビルドメソッドが何度も呼ばれ高速に処理できることを目指し、
//    // 最適化されています。そのため、ウィジェット個々に処理しなくても、更新が必要なものは
//    // 全て対応されます。
//    return Scaffold(
//      appBar: AppBar(
//        // ここには、App.buildメソッドで作られたMyHomePageオブジェクトの値が入り、
//        // アプリケーションバーのタイトルになります。
//        title: Text(widget.title),
//      ),
//      body: Center(
//        // Centerは、レイアウトウィジェトの１つです。
//        // 子ウィジェットを１つたけ持ち、それを、親ウィジェトの中心に配置します。
//        child: Column(
//          // Columnは、レイアウトウィジェトの１つです。
//          // 複数の子ウィジェットのリストを持ち、それらを垂直に配置します。
//          // デフォルトでは、子ウィジェットを横いっぱい、かつ親ウィジェットの高さいっぱいに
//          // 配置します。
//          //
//          // "debug painting"を呼び出す（コンソールで"p"ボタンを押すか、Android
//          // StudioのFlutter Inspectorで"Toggle Debug Paint"を実行するか、
//          // Visual Studio Codeで"Toggle Debug Paint"コマンドを実行するかで）
//          // ことにより、各オブジェクトのワイヤーフレームを可視化できます。
//          //
//          // Columnは、多くのパラメータにより、サイズや子ウィジェットの配置を制御できます。
//          // ここでは、mainAxisAlignmentにより、子ウィジットを上下中央に配置します。
//          // Columnsは垂直に配置されるため、mainAxisは垂直方向を意味します。
//          // （cross axisが水平方向を意味します）
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Text(
//              'You have pushed the button this many times:',
//            ),
//            Text(
//              '$_counter',
//              style: Theme.of(context).textTheme.display1,
//            ),
//          ],
//        ),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ), // この最後のカンマは、ビルドメソッドの自動フォーマットを有効にします。
//    );
//  }
//}
