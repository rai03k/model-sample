import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sample/second_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'default.dart';
import 'memo_model.dart';

const Map<String, String> UNIT_ID = kReleaseMode
    ? {
        'ios': '[YOUR iOS AD UNIT ID]',
        'android': 'ca-app-pub-1073270249936683~9140897348',
      }
    : {
        'ios': 'ca-app-pub-3940256099942544/2934735716',
        'android': 'ca-app-pub-1073270249936683/1371068590',
      };

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memo Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Color(0xFFffffff),
        brightness: Brightness.light,
        textTheme: GoogleFonts.sawarabiMinchoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class SearchBar extends StatefulWidget implements PreferredSizeWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => SearchBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class SearchBarState extends State<SearchBar> {
  final _controller = TextEditingController();
  var _darkmode = false;

  void _submission() {
    setState(() {
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SizedBox(
        height: 40,
        child: Container(
          decoration: BoxDecoration(
            color: _darkmode
                ? DefaultData.backgroundColor[1]
                : DefaultData.backgroundColor[1],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Center(
            child: Container(
              width: 340,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextField(
                controller: _controller,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: '検索',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _submission();
                    },
                    padding: EdgeInsets.zero,
                    highlightColor: Colors.transparent,
                  ),
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  isCollapsed: true,
                ),
                onSubmitted: (text) => _submission(),
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.lightbulb_outline),
          onPressed: () async {
            setState(() {
              _darkmode = !_darkmode;
            });
          },
        )
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  List<List<MemoModel>> memoList = [];
  @override
  void initState() {
    super.initState();
    read();
  }

  void read() async {
    memoList.clear();
    final prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();

    for (String key in keys) {
      final jsonString = prefs.getStringList(key);
      final jsonMap = json.decode(jsonString![0]);

      final memoModel = MemoModel(
        id: jsonMap['id'] ?? 0,
        title: jsonMap['title'] ?? '',
        memo: jsonMap['memo'] ?? '',
        createdDate: jsonMap['createdDate'],
        updatedDate: jsonMap['updatedDate'],
        tagColor: jsonMap['tagColor'] ?? 0,
      );

      memoList.add([memoModel]);
    }
    setState(() {});
  }

  Widget listTile(int id, String p_title, String p_memo, String p_updated_date,
      int indexColor) {
    String updateDate =
        "${p_updated_date.substring(0, 4)}年${p_updated_date.substring(5, 7)}月${p_updated_date.substring(8, 10)}日";
    return Padding(
      padding: EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: Colors.black),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                width: 12,
                color: DefaultData.colorList[indexColor],
              ),
              Expanded(
                child: ListTile(
                  title: Text(p_title),
                  subtitle: Text(updateDate),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SecondScreen(
                                id: id,
                                title: p_title,
                                memo: p_memo,
                                indexColor: indexColor,
                              )),
                    ).then((value) {
                      read();
                      setState(() {});
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TargetPlatform os = Theme.of(context).platform;

    BannerAd banner = BannerAd(
      listener: BannerAdListener(
        onAdFailedToLoad: (Ad ad, LoadAdError error) {},
        onAdLoaded: (_) {},
      ),
      size: AdSize.banner,
      adUnitId: UNIT_ID[os == TargetPlatform.iOS ? 'ios' : 'android']!,
      request: AdRequest(),
    )..load();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('ホーム'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: memoList.length,
              itemBuilder: (BuildContext context, int index) {
                final memoData = memoList[index];
                return Dismissible(
                  background: Container(
                    color: Colors.red,
                    child: const Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                        )),
                  ),

                  // onDismissed: ウィジェットが閉じられたときに呼び出される
                  onDismissed: (DismissDirection direction) async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    setState(() async {
                      prefs.remove((memoData[0].id).toString());
                    });
                  },
                  key: UniqueKey(), //ValueKey<int>(memoData[0].id),
                  child: listTile(
                    memoData[0].id,
                    memoData[0].title,
                    memoData[0].memo,
                    memoData[0].updatedDate,
                    memoData[0].tagColor,
                  ),
                );
              },
            ),
          ),
          Container(
            height: 50,
            child: AdWidget(
              ad: banner,
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 2.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
          gradient: LinearGradient(colors: <Color>[
            const Color(0xFFE32212),
            const Color(0xFFBD271A),
          ]),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondScreen()),
            ).then((value) {
              read();
              setState(() {});
            });
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add),
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
