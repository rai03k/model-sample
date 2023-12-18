class MemoModel {
  int id;
  String title;
  String memo;
  String createdDate;
  String updatedDate;
  int tagColor;

  MemoModel(
      {required this.id,
      required this.title,
      required this.memo,
      required this.createdDate,
      required this.updatedDate,
      required this.tagColor});

  // Map型に変換
  Map toJson() => {
        'id': id,
        'title': title,
        'memo': memo,
        'createdDate': createdDate,
        'updatedDate': updatedDate,
        'tagColor': tagColor,
      };

  // Jsonオブジェクトを代入
  MemoModel.fromJson(Map json)
      : id = json['id'],
        title = json['title'],
        memo = json['memo'],
        createdDate = json['createdDate'],
        updatedDate = json['updatedDate'],
        tagColor = json['tagColor'];
}
