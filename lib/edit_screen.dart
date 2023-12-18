import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'memo_model.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController _memoController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  List<MemoModel> memoData = [];
  late String key;

  // データ保存
  Future save() async {
    // Map型変換->Json形式にエンコード->リスト化
    List<String> myData = memoData.map((f) => json.encode(f.toJson())).toList();
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
    myData;
    await prefs.setStringList(key, myData);
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
                  tagColor: 0,
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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30, right: 30, bottom: 0, left: 30),
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
            Padding(
              padding: EdgeInsets.only(top: 15, right: 30, bottom: 0, left: 30),
              child: TextField(
                controller: _memoController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(),
                onChanged: (text) {
                  setState(() {}); // Update UI when text changes
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
