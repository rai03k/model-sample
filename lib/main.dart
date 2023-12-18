import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample/edit_screen.dart';
import 'package:sample/second_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'memo_model.dart';

void main() {
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
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _counter;
  final _controller = TextEditingController();

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
            color: Color(0xFFffffff),
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
            final prefs = await SharedPreferences.getInstance();
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
    int count = prefs.getKeys().length;

    for (int i = 0; i < count; i++) {
      final key = i.toString();
      if (prefs.containsKey(key)) {
        final jsonString = prefs.getStringList(key);
        final jsonMap = json.decode(jsonString![0]);

        final memoModel = MemoModel(
            id: jsonMap['id'] ?? 0,
            title: jsonMap['title'] ?? '',
            memo: jsonMap['memo'] ?? '',
            createdDate: jsonMap['createdDate'],
            updatedDate: jsonMap['updatedDate'],
            tagColor: jsonMap['tagColor'] ?? 0);

        memoList.add([memoModel]);
      }
    }
    setState(() {});
  }

  Widget listTile(String p_title, String p_updated_date) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: ListTile(
          title: Text(p_title),
          subtitle: Text(p_updated_date),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditScreen()),
            ).then((value) {
              read();
              setState(() {});
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: SearchBar(),
      body: ListView.builder(
        itemCount: memoList.length,
        itemBuilder: (BuildContext context, int index) {
          // memoListの各要素を使ってListViewのアイテムを構築
          final memoData = memoList[index];
          return listTile(
            memoData[0].title,
            memoData[0].updatedDate,
          );
        },
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
          gradient: LinearGradient(
            colors: [
              Color(0xFFE32212),
              Color(0xFFBD271A),
            ],
          ),
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
