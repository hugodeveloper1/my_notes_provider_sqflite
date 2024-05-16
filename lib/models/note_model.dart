class NoteModel {
  final int? id;
  final String title;
  final String content;
  final String date;
  final String updatedDate;
  final bool isSelected;

  NoteModel({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.updatedDate,
    this.isSelected = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
      'updated_date': updatedDate,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: map['date'],
      updatedDate: map['updated_date'],
      isSelected: false,
    );
  }

  NoteModel copyWith({
    int? id,
    String? title,
    String? content,
    String? date,
    String? updatedDate,
    bool? isSelected,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      updatedDate: updatedDate ?? this.updatedDate,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
