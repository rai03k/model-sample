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

  void navigateToSecondScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SecondScreen(
        onDescriptionSubmitted: (description) {
          TitleModel titleModel = TitleModel(title, description);
          addToTitleList(titleModel);
        },
      ),
    ));
  }

  void addToTitleList(TitleModel titleModel) {
    setState(() {
      titleModels.add(titleModel);
    });
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
              onPressed: () => navigateToSecondScreen(context),
              child: Text('次へ'),
            ),
            // リストビューでTitleModelオブジェクトを表示
            Expanded(
              child: ListView.builder(
                itemCount: titleModels.length,
                itemBuilder: (context, index) {
                  TitleModel item = titleModels[index];
                  return ListTile(
                    title: Text(item.title),
                    subtitle: Text(item.description),
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

class SecondScreen extends StatelessWidget {
  final Function(String description) onDescriptionSubmitted;

  SecondScreen({super.key, required this.onDescriptionSubmitted});

  String description = '';

  void submitDescription(BuildContext context) {
    onDescriptionSubmitted(description);
    Navigator.pop(context); // SecondScreenを閉じる
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('説明入力')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (text) {
                description = text;
              },
              decoration: InputDecoration(labelText: '説明'),
            ),
            ElevatedButton(
              onPressed: (){
                submitDescription(context); // SecondScreenを閉じる
              },
              child: Text('完了'),
            ),
          ],
        ),
      ),
    );
  }
}
