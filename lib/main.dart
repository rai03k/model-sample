import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class TitleModel {
  String title;
  String description;

  TitleModel(this.title, this.description);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  String title = '';
  List<TitleModel> titleModels = [];

  void addTitleToList() {
    if (title.isNotEmpty) {
      titleModels.add(TitleModel(title, ""));
      title = "";
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('タイトル入力')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (text) {
                title = text;
              },
              decoration: InputDecoration(labelText: 'タイトル'),
            ),
            ElevatedButton(
              onPressed: () {
                addTitleToList();
              },
              child: Text('リストに追加'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: titleModels.length,
                itemBuilder: (context, index) {
                  TitleModel item = titleModels[index];
                  return ListTile(
                    title: Text(item.title),
                    subtitle: Text(item.description), // 説明をsubtitleに設定
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DescriptionInputScreen(
                            title: item.title,
                            onDescriptionSubmitted: (description) {
                              item.description = description;
                              Navigator.pop(context);
                              setState(() {});
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DescriptionInputScreen extends StatefulWidget {
  final Function(String description) onDescriptionSubmitted;
  final String title;

  DescriptionInputScreen({
    required this.title,
    required this.onDescriptionSubmitted,
  });

  @override
  _DescriptionInputScreenState createState() => _DescriptionInputScreenState();
}

class _DescriptionInputScreenState extends State<DescriptionInputScreen> {
  String description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('説明入力')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('タイトル: ${widget.title}'),
            TextField(
              onChanged: (text) {
                description = text;
              },
              decoration: InputDecoration(labelText: '説明'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onDescriptionSubmitted(description);
              },
              child: Text('完了'),
            ),
          ],
        ),
      ),
    );
  }
}
