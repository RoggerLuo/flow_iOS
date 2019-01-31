class Note {
  String content;
  int id;
  int modifyTime;
  int createTime;
  Note({this.content, this.id, this.modifyTime, this.createTime});
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      content: json['content'],
      id: json['id'],
      modifyTime: json['modify_time'],
      createTime: json['create_time'],
    );
  }
}
