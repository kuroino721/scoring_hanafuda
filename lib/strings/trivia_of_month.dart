import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/info/developer.dart';
import 'package:flutter_app/main.dart';
import 'package:url_launcher/url_launcher.dart';

/// 月の雑学
class TriviaOfMonth {
  static final List<TextSpan> triviaOfJanuary = [
    TextSpan(
      text: "1月は花札で言うと「松に鶴」です。\n"
          "松は冬でも葉が落ちないため古来より長寿の象徴とされ、正月の門松などの縁起物で親しまれてきました。\n"
          "同じく鶴も「鶴は千年、亀は万年」という言葉のように、長寿の象徴として知られています。\n"
          "実際の風景で松と鶴を一緒に目にすることはほとんどありませんが、\n"
          "花札の中で縁起物の組み合わせを堪能することができます。",
      style: TextStyle(color: Colors.black),
    ),
    TextSpan(
      text: "花札で言うと1月は「松に鶴」です。\n"
          "松というと、海岸沿いに美しく並ぶ松林を想像される方も多いと思いますが、なぜ松が海沿いによく生えているのかご存知ですか？\n"
          "そもそも松には赤松と黒松の二種類があって、海沿いによく生えているのは黒松のほうです。黒松は非常に乾燥した土地でも成長できる強い植物で、もともと海沿いに生息していましたが、今の松林のように一列に並んではいませんでした。それではこれがどうして現在の形になったかというと、ずばり人の手によるものだからです。昔から海岸沿いに住む人たちは、海風によって運ばれる砂による害に苦しめられていました。そこで、黒松の丈夫さと、一年中葉を付けることによる防砂効果に目を付けて、日本中で防砂林・防風林として植樹していったのだそうです。\n"
          "普段よく目にする光景も、人々の知恵・努力の結晶だということがよくわかりますね。",
      style: TextStyle(color: Colors.black),
    )
  ];
  static final List<TextSpan> triviaOfFebruary = [
    TextSpan(
      text: "2月は花札で言うと「梅に鶯」です。\n"
          "「ホーホケキョ」の鳴き声で有名な鶯は春先に鳴き始めるので「春告鳥」とも呼ばれます。\n"
          "同じくこの時期に咲く梅との相性は抜群で、「梅に鶯」は取り合わせの良いものの例えとしてもよく使われます。\n"
          "古くは万葉集にも梅に鶯はセットで詠まれており、昔から日本人の季節感を象徴してきたものなんですね。",
      style: TextStyle(color: Colors.black),
    ),
    TextSpan(
      text: "2月は花札で言うと「梅に鶯」です。\n"
          "「ホーホケキョ」の鳴き声で親しまれ、日本三鳴鳥（ウグイス・オオルリ・コマドリ）の一羽としても知られるウグイス。さて、みなさんはウグイスの色というとどんな色を想像しますか？\n"
          "鮮やかな緑色だと思った方は残念ながら間違いです。「うぐいす餡」などで明るい緑色のイメージがありますが、実際のウグイスの色は灰色～緑がかった茶色で、うぐいす餡の色とは全く異なります。花札に描かれているウグイスもやはり鮮やかな緑色をしており、外見だけだとメジロのように見えます。さらには梅の花によく来るのはメジロであり、ホトトギスはめったに梅の花に寄り付かないので、混乱に拍車がかかっています。鮮やかな緑色で目の周りが白い鳥は「メジロ」ですので、間違えないよう皆さん注意してくださいね。",
      style: TextStyle(color: Colors.black),
    )
  ];
  static final List<TextSpan> triviaOfMarch = [
    TextSpan(
      text: "3月は花札でいうと「桜に幕」です。\n"
          "春といえば桜、日本人が最も愛する花と言っても過言ではないでしょう。\n"
          "\n"
          "ところでみなさん、桜と梅の違いってご存知ですか？\n"
          "開花期が違う、梅のほうが花弁が丸いなどの特徴はありますが、\n"
          "やはり一目でわかる違いは「桜は花柄が長い」ことでしょう。\n"
          "花柄とは枝と花を結ぶ小さな枝のことで、分かりやすく言うとサクランボの枝の部分、これが花柄です。\n"
          "サクランボを見ればわかる通り、桜は花柄が長く発達していますが、\n"
          "梅は花柄が短く、直接枝から花が咲いているような見た目になることが特徴です。",
      style: TextStyle(color: Colors.black),
    ),
    TextSpan(
      text: "花札でいうと3月は「桜に幕」です。\n"
          "普段私たちが公園や道路沿いで目にするいわゆる「桜」は、大半が「ソメイヨシノ」という栽培品種です。ソメイヨシノは、「エドヒガン」と「オオシマザクラ」という野生種を掛け合わせて、人の手によって生み出されたことが分かっています（ちなみに桜餅の葉に使われているのは、大部分がオオシマザクラの葉です。クマリンという芳香成分を持つこと、葉がやわらかく毛が少ないことから愛用されてきたそうです）。\n"
          "ソメイヨシノが生み出されたのは江戸時代後期で、実際に全国に広がったのは明治時代以降と言われています。さて、江戸時代後期と聞いて、すでにお気づきのことと思いますが、花札の発祥は江戸時代前期～中期と言われています。そのため、「花札に描かれている桜はおそらくソメイヨシノではない」と考えられます。その証拠に3月の札を見てみると、花と一緒に緑の葉が描かれていることが分かります。これは、葉が出るのは花が散った後、というソメイヨシノの性質とは矛盾し、ヤマザクラなど花と葉が一緒に展開する品種の特徴を反映しています。\n"
          "江戸時代の桜は花が葉とともに咲いているのが普通で、むしろそれをピンクと緑の鮮やかなコントラストとして人々は楽しんでいたのかもしれません。そう考えると、花札から江戸時代の人々の桜の楽しみ方を感じ取ることができる気がしませんか？",
      style: TextStyle(color: Colors.black),
    )
  ];
  static final List<TextSpan> triviaOfApril = [
    TextSpan(
      text: "4月の札に描かれているのは「藤とホトトギス」です。\n"
          "ホトトギスは「鳴かぬなら殺してしまえホトトギス」などの川柳でもおなじみの鳥で、\n"
          "「テッペンカケタカ」という鳴き声で知られています。\n"
          "ちなみに鳥だけでなくホトトギスという名前の植物もいて、こちらは鳥のホトトギスの模様に似ている花をつけることから命名されました。\n"
          "みなさんホトトギスには鳥と植物の２種類がいることをぜひ覚えてみてください。",
      style: TextStyle(color: Colors.black),
    ),
    TextSpan(
      text: "花札でいうと、4月は「藤に杜鵑（ホトトギス）」ですね。\n"
          "藤はちょうど4月から6月にかけて咲き、ゴールデンウィークごろに満開となります。京都では鳥羽水環境保全センターにて藤棚の一般開放が行われているので、近くにお住まいの方は一度足を運ばれてはいかがでしょうか。私も一度行ったことがありますが、とても下水処理場とは思えない美しい光景に魅了されました。\n"
          "杜鵑は本来6月～8月の鳥ですが、なぜか花札では4月の札に姿を見せます。「テッペンカケタカ」という鳴き声や、カッコウと同じく、他の鳥の巣に托卵することで有名ですね。",
      style: TextStyle(color: Colors.black),
    )
  ];
  static final List<TextSpan> triviaOfMay = [
    TextSpan(
      text: "花札で言うと5月は「菖蒲に八つ橋」です。\n"
          "菖蒲の花は、基調の青色にアクセントの黄色が映える美しい花です。見たことがない人は少ないと思いますが、これが5月5日の菖蒲湯に使われる菖蒲とは別物だということはご存知でしょうか（私は知りませんでした……）。\n"
          "花が咲くのはハナショウブと言って、アヤメ科アヤメ属の多年草です（細かいことをいうと「アヤメ」「カキツバタ」「ハナショウブ」もそれぞれ別の植物なのですが、ここでは割愛します）。\n"
          "一方、菖蒲湯に使うショウブはサトイモ科ショウブ属で科から異なりますし、葉は似ているものの花が咲きません。\n"
          "今までなんとなくそうだと思っていたことも、調べてみると驚かされることがよくありますね。",
      style: TextStyle(color: Colors.black),
    ),
    TextSpan(
      text: "花札で言うと5月は「菖蒲に八つ橋」です。\n"
          "八つ橋というと京都のおみやげを想像されるかもしれませんが、ここで言う八つ橋はジグザグ型をした変わった橋のこと。もともとは『伊勢物語』の東下りで源氏が立ち寄った三河の国、八橋という場所が由来です。川が蜘蛛の足のように分かれていたため橋がジグザグに架かっていることが語られ、源氏は\n"
          "「からころも着つつなれにしつましあればはるばる来ぬる旅をしぞ思ふ」\n"
          "という有名な歌を詠みます。\n"
          "今でも植物園などに行くと菖蒲の花と八つ橋のある光景を目にすることがあります。\n"
          "5月～6月にかけてが花の季節なので皆さん足を運んでみてはいかがでしょうか",
      style: TextStyle(color: Colors.black),
    )
  ];
  static final List<TextSpan> triviaOfJune = [
    TextSpan(
      text: "6月は花札で言うと「牡丹に蝶」です。\n"
          "中国が原産の牡丹は、「花の王様」と呼ばれるにふさわしい豪華さが特徴です。\n"
          "「立てば芍薬座れば牡丹、歩く姿は百合の花」という言葉でも有名ですね。\n"
          "鮮やかな牡丹の花にひらひらと蝶が舞い寄る光景は、\n"
          "昔から美しい情景として語られてきたのでしょう。",
      style: TextStyle(color: Colors.black),
    ),
    TextSpan(
      text: "花札で言うと6月の花は牡丹です。\n"
          "「牡丹に唐獅子　竹に虎」という文句でも知られているように、牡丹と唐獅子（ライオンに似た想像上の生き物）には深い関係があります。獅子が牡丹の露を飲んで、体に巣くう虫を退治するという話が「獅子身中の虫」という言葉のもととなっています。\n"
          "また、「猪鍋」のことを「ぼたん鍋」と呼ぶことがありますが、これもこの諺が語源と言われています。一説には「獅子と牡丹」→「猪（しし）と牡丹」という風にイメージの連鎖で「ぼたん鍋」という言葉が生まれるに至ったそうです。そこから、肉を華やかに盛り付けて牡丹の花に見立てる様式が発達したと考えられています。\n"
          "どんな言葉にも語源は存在し、その真偽にかかわらず考えを巡らすのは楽しいものですね。",
      style: TextStyle(color: Colors.black),
    )
  ];
  static final List<TextSpan> triviaOfJuly = [
    TextSpan(
      text: "7月の植物は花札で言うと「萩（ハギ）」です。\n"
          "萩はマメ科ハギ属の木の総称で、秋の七草のひとつ。\n"
          "毎年、春に根元から芽が生えてくることから、「生芽（はえぎ）」と呼ばれたのが語源だといわれています\n"
          "\n"
          "早いものだと梅雨終わりごろから咲きはじめるのですが、盛りは秋ごろで、古来より和歌が多く読まれてきました。\n"
          "万葉集では萩は１４２首に登場し、これは梅の１１９首を抑えて登場数第一位だそうです。\n"
          "萩の漢字も「くさかんむり」に「秋」ですから、まさに秋を代表する花と言えます。",
      style: TextStyle(color: Colors.black),
    ),
    TextSpan(
      text: "7月は花札で言うと「萩に猪」です。\n"
          "萩（ハギ）はマメ科の木で、秋の七草のひとつでもあります。\n"
          "一方漢字の似ている荻（オギ）はイネ科の一年草なので、見た目からして何もかも違います。\n"
          "いくら似ていても萩原さんと荻原さんでは全く異なりますので、皆さん注意してくださいね。\n"
          "猪は7月が活動期というわけではないのですが、昔から萩と猪はセットで描かれています。\n"
          "柔らかいイメージの萩と、猛々しさの象徴である猪（猪突猛進という言葉もありますね）の\n"
          "ほどよく調和のとれた景色をイメージすることができます。",
      style: TextStyle(color: Colors.black),
    )
  ];
  static final List<TextSpan> triviaOfAugust = [
    TextSpan(
      text: "8月は花札で言うと「芒に満月」です。\n"
          "ススキはイネ科ススキ属の植物で、花は9月から10月にかけて咲きます。\n"
          "秋の終わりの枯れススキは、枯れ尾花として非常に風情のある光景を形作ります。\n"
          "「幽霊の正体見たり枯れ尾花」の枯れ尾花とはススキの枯れた姿のことなんですね。\n"
          "\n"
          "ススキは十五夜にお供えされるだけでなく、\n"
          "かつては萱葺き屋根の材料として重宝されていました。\n"
          "そのため、人里近くには必ず萱場（かやば）としてススキの栽培地があったのですが、\n"
          "今では需要がなくなり、ススキも姿を消しつつあります。\n"
          "人間の営みが変化するにつれ、景色も変わってきました。\n"
          "このことは、これからの環境問題を考えるうえでも非常に大切な観点なのではないでしょうか。",
      style: TextStyle(color: Colors.black),
    ),
    TextSpan(
      children: [
        TextSpan(
          text: "花札で言うと8月の札は「芒（ススキ）に満月」です。\n"
              "満月と、芒の生い茂る山とをシンプルに表現した8月の光札は、花札のイメージの代表格といえます。実際に「はなふだ」を変換したときに表示される花札の絵文字→🎴もこのデザインですね（この絵文字について詳しくは",
          style: TextStyle(color: Colors.black),
        ),
        TextSpan(
          text: 'こちら',
          style: TextStyle(color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launch(
                  'http://hanafudaproject.hatenablog.com/entry/2017/06/23/%E8%8A%B1%E6%9C%AD%E3%81%AE%E7%B5%B5%E6%96%87%E5%AD%97_%F0%9F%8E%B4');
            },
        ),
        TextSpan(
          text:
              "をご参照ください）。ちなみに、この山は京都に実際に存在する「鷹峯（たかみね、たかがみね）」がモデルだと言われています。京都北山の「光悦寺」境内から望むことができますので、京都にお立ち寄りの際は足を運んでみてはいかがでしょうか。",
          style: TextStyle(color: Colors.black),
        ),
      ],
    )
  ];
  static final List<TextSpan> triviaOfSeptember = [
    TextSpan(
      text: "花札で言うと9月の花は菊です。\n"
          "菊というと皇室・皇族の家紋としても知られ、冠婚葬祭でもよく目にすることから日本人にとても身近な花ですね。\n"
          "春の桜に対して日本の秋を象徴する花ともいえますが、それが決定的になったのは、鎌倉時代の初め後鳥羽上皇が「菊紋」を皇室の家紋とした頃からだといわれているので、およそ900年ほどの歴史といえます。\n"
          "さて、普段よく使う100円硬貨の裏には桜紋が刻まれていますが、同じように菊紋が記された硬貨があります。それはなんでしょう？\n"
          "もし興味があれば調べてみてください。",
      style: TextStyle(color: Colors.black),
    ),
    TextSpan(
      text: "花札で言うと9月の札は「菊に盃」です。\n"
          "旧暦9月9日は重陽の節句です。中国から伝わった行事の一つで、菊を用いて長寿を願うため、菊の節句とも呼ばれています。古来、菊は薬草としても用いられ、人々は菊の節句になると、菊を浸した酒を飲んで長寿を祈願してきました。9月の種札の盃に書かれた『寿』の由来はここにあるんですね。\n"
          "また、旧暦の9月9日は今の10月中ごろで、菊の見ごろもこの時期となります。",
      style: TextStyle(color: Colors.black),
    )
  ];
  static final List<TextSpan> triviaOfOctober = [
    TextSpan(
      text: "花札で言うと10月の札は「紅葉に鹿」です。\n"
          "新古今和歌集秋歌下に収められている藤原家隆の歌には以下のようなものがあります。\n"
          "下紅葉 かつ散る山の夕時雨 濡れてやひとり 鹿の鳴くらむ\n"
          "紅葉と時雨、そしてひとりで鳴く鹿という秋の物悲しい情景が描写されています。\n"
          "このように昔から紅葉と鹿はセットで扱われてきていて、今でも鹿肉のことは「もみじ」と呼ばれますね。\n"
          "\n"
          "ちなみに人を無視するという意味で使われる「しかと」という言葉は花札が語源ということはご存じでしたか？\n"
          "十月の「紅葉に鹿」の札で鹿がそっぽを向いていることから「鹿十（しかとお）」→「しかと」と変化して生まれたと言われています。",
      style: TextStyle(color: Colors.black),
    ),
    TextSpan(
      text: "10月は花札で言うと「紅葉に鹿」です。\n"
          "突然ですが、皆さんモミジとカエデの違いってご存知でしょうか？\n"
          "実はこの使い分けは結構あいまいです。カエデとはムクロジ科(旧カエデ科)カエデ属の落葉高木の総称で、一般的に葉の切れ込みが深いカエデを「○○モミジ」、浅いカエデを「○○カエデ」と呼んでいます。\n"
          "「イロハモミジ」は葉の切れ込みが深く、「トウカエデ」は浅い、というわけですね。\n"
          "ちなみに任天堂・大石天狗堂などが出している現代の代表的花札の図柄ではなぜか、種札（鹿の札）だけ葉の切れ込みが浅く、他の札では切れ込みが深くなっています。",
      style: TextStyle(color: Colors.black),
    )
  ];
  static final List<TextSpan> triviaOfNovember = [
    TextSpan(
      text: "11月は花札で言うと「柳と小野道風と蛙」です。\n"
          "小野道風は和様書道の基礎を築いた人物で、藤原佐理、藤原行成と合わせて「三跡」と称されます。なぜ柳と蛙なのかというと、道風のこんな逸話がもととなっているようです。\n"
          "\n"
          "「道風が、自分の才能のなさに自己嫌悪に陥り、書道をやめようかと真剣に悩んでいる程のスランプに陥っていた時のこと。ある雨の日散歩に出かけていて、柳に蛙が飛びつこうと、何度も挑戦している姿を見て「蛙はバカだ。いくら飛んでも柳に飛びつけるわけないのに」とバカにしていた時、偶然にも強い風が吹き、柳がしなり、見事に飛び移れた。これを見た道風は「バカは自分だ。蛙は一生懸命努力をして偶然を自分のものとしたのに、自分はそれほどの努力をしていない」と目が覚めるような思いをして、血を滲むほどの努力をするきっかけになったという」（Wikipediaより）\n"
          "\n"
          "9月は「菊」、10月は「紅葉」で季節と見ごろの自然が合っていましたが、柳は春に開花するので11月の花とは言えません。しかし、そんなことはどうでもよくなる程の感動的な、そして身につまされる話ですね。",
      style: TextStyle(color: Colors.black),
    ),
    TextSpan(
      text:
          "花札で言うと11月の花は「柳」です。しかし、実際には柳はこの時期に花を咲かせるわけではありません。そもそも柳の花のイメージってあまりありませんよね。\n"
          "\n"
          "実は、柳の開花時期は４月ごろです。春の芽出し前に黄色い花を咲かせるのですが、花といっても花びらがなく、それほど目立ちません。\n"
          "種子は綿のような毛がつき、5~6月に辺りを舞うのですが、日本で目にすることは少ないでしょう。というのも、私たちが柳と聞いて一番に思い浮かべる「シダレヤナギ」という種は雌雄異株で、日本ではそのほとんどが雄株だからです。\n"
          "柳の実が舞い流れる光景は柳絮（りゅうじょ）とも呼ばれ、なじみの少ない日本人からすると非常に風流に見えます。しかし、中国ではマスクをしないといけないほど舞うので嫌がられることも多いそうです。何事もほどほどが肝心ということでしょうか。",
      style: TextStyle(color: Colors.black),
    )
  ];
  static final List<TextSpan> triviaOfDecember = [
    TextSpan(
      text: "12月は花札で言うと「桐に鳳凰」です。\n"
          "古くから桐は鳳凰の止まる木として神聖視されており、日本でも「菊の御紋」に次ぐ高貴な紋章とされてきました。花は4～5月に咲くので季節に合いませんが、12月ということで「これっ「きり」」という駄洒落の意味合いを込めて12月に桐が当てはめられたという説もあります。",
      style: TextStyle(color: Colors.black),
    ),
    TextSpan(
      text: "花札で言うと12月は「桐に鳳凰」です。\n"
          "これまで花札では季節の植物に加えてさまざまな動物が描かれてきましたが、12月だけ実際には存在しない生き物が登場します。\n"
          "鳳凰は「平等院鳳凰堂」などでご存知と思いますが、中国の故事では聖徳の天子の兆しとして出現すると言われる、大変めでたい存在です。日本でも吉祥の表れとして大切にされており、今でも一万円札の裏を覗けばその姿を確認することができます。\n"
          "ちなみに桐も500円玉の表に描かれており、桐と鳳凰は硬貨と紙幣それぞれの最高金額を代表する存在なわけですね（一万円札は福沢諭吉のイメージが圧倒的とは思いますが）。",
      style: TextStyle(color: Colors.black),
    )
  ];

  static List<List<TextSpan>> triviaOfMonths = [
    triviaOfJanuary,
    triviaOfFebruary,
    triviaOfMarch,
    triviaOfApril,
    triviaOfMay,
    triviaOfJune,
    triviaOfJuly,
    triviaOfAugust,
    triviaOfSeptember,
    triviaOfOctober,
    triviaOfNovember,
    triviaOfDecember
  ];

  static TextSpan getTrivia(month) {
    return triviaOfMonths[month - 1]
        [math.Random().nextInt(triviaOfMonths[month - 1].length)];
  }

  /// 月の雑学の表示
  static Future showMonthTrivia({BuildContext context, int month}) async {
    // その月が誕生月のdeveloperを抽出
    Developer _developer;
    for (Developer tmp in developers) {
      if (month == tmp.birthMonth) {
        _developer = tmp;
        break;
      } else {
        _developer = null;
      }
    }

    // 10%判定
    // TODO: リファクタしてえ
    math.Random rand = math.Random();
    int randNum = rand.nextInt(10);
    Function whereToTransition;
    if (_developer != null && randNum == 0) {
      logger.d('show birth month info');
      whereToTransition = () {
        showDialog<bool>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('ちなみに'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                    '$month月はこのアプリの${_developer.role}の${_developer.name}の誕生月です！\n彼は${_developer.likes}が好きです')
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('へえ'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      };
    } else {
      if (_developer != null) {
        logger.d('数=$randNum, 開発者=${_developer.name}');
      }
      whereToTransition = () => Navigator.pop(context);
    }
    // Directory _dir = Directory('images/month_symbol'); //TODO: OS Error: No such file or directory
    // int _numberOfSymbols = _dir.listSync().length;
    int _numberOfSymbols = 5; // images/month_symbol下のファイル数

    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('$month月'),
        content: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Image.asset(
                  'images/month_symbol/${(month - 1) % _numberOfSymbols + 1}_symbol.png'), // 2個
            ),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: RichText(
                  text: TriviaOfMonth.getTrivia(month),
                  softWrap: true,
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('なるほど'),
            onPressed: whereToTransition,
          ),
        ],
      ),
    );
  }
}
