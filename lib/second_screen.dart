import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'default.dart';
import 'memo_model.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen(
      {this.id, this.title, this.memo, this.indexColor, super.key});

  final int? id;
  final String? title;
  final String? memo;
  final int? indexColor;

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  int? id;
  String? title;
  String? memo;
  int indexColor = 0;

  TextEditingController _memoController = TextEditingController();
  TextEditingController _titleController = TextEditingController();

  List<MemoModel> memoData = [];
  late String key;
  List<Color> colorList = DefaultData.colorList;
  late Color selectColor;

  @override
  void initState() {
    super.initState();
    setState(() {
      id = widget.id ?? -1;
      title = widget.title ?? "";
      memo = widget.memo ?? "";
      indexColor = widget.indexColor ?? 0;
    });
    _titleController.text = title!;
    _memoController.text = memo!;
    selectColor = colorList[indexColor];
  }

  Future update() async {
    // Map型変換->Json形式にエンコード->リスト化
    SharedPreferences prefs = await SharedPreferences.getInstance();
    key = id.toString();
    memoData[0].id = int.parse(key);

    final jsonString = prefs.getStringList(key);
    final jsonMap = json.decode(jsonString![0]);
    memoData[0].createdDate = jsonMap['createdDate'];

    List<String> myData = memoData.map((f) => json.encode(f.toJson())).toList();
    await prefs.setStringList(key, myData);
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
    memoData[0].createdDate =
        DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now());
    List<String> myData = memoData.map((f) => json.encode(f.toJson())).toList();
    await prefs.setStringList(key, myData);
  }

  void saveUpdate() {
    // save
    if (id == -1) {
      save();
      // update
    } else {
      update();
    }
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
                  createdDate: "",
                  updatedDate:
                      DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now()),
                  tagColor: indexColor ?? 0,
                )
              ];
              saveUpdate();
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
                        maxLength: 30,
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
