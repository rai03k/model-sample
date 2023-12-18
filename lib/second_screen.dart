import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'memo_model.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  TextEditingController _memoController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  int indexColor = 0;
  List<MemoModel> memoData = [];
  late String key;
  List<Color> colorList = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green,
    Colors.purple,
  ];
  late Color selectColor;

  @override
  void initState() {
    super.initState();
    selectColor = colorList[0];
  }

  // データ保存
  Future save() async {
    // Map型変換->Json形式にエンコード->リスト化
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.getKeys().toList().contains('0')) {
      key = '0';
    } else {
      key = prefs
          .getKeys()
          .toList()
          .reduce((v, e) => int.parse(v) > int.parse(e) ? v : e);
      key = (int.parse(key) + 1).toString();
    }
    memoData[0].id = int.parse(key);
    List<String> myData = memoData.map((f) => json.encode(f.toJson())).toList();
    await prefs.setStringList(key, myData);
    print(myData);
  }

  Widget selectTagColor(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectColor = color;
          for (int i = 0; i < colorList.length; i++) {
            if (colorList[i] == selectColor) {
              indexColor = i;
              break;
            }
          }
        });
      },
      child: Padding(
        padding: EdgeInsets.only(top: 15),
        child: Container(
          color: color == selectColor ? color : color.withOpacity(0.3),
          width: 30,
          height: 50,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            if (_titleController.text != '') {
              memoData = [
                MemoModel(
                  id: 0,
                  title: _titleController.text,
                  memo: _memoController.text,
                  createdDate:
                      DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now()),
                  updatedDate:
                      DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now()),
                  tagColor: indexColor,
                )
              ];
              save();
            }
            Navigator.pop(context, true);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(children: colorList.map((e) => selectTagColor(e)).toList()),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 30, bottom: 0, left: 30),
                    child: Container(
                      child: TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: "タイトル",
                        ),
                        onChanged: (text) {
                          setState(() {}); // Update UI when text changes
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 15, right: 30, bottom: 0, left: 30),
                    child: Container(
                      child: TextField(
                        controller: _memoController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: "内容",
                        ),
                        onChanged: (text) {
                          setState(() {}); // Update UI when text changes
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
