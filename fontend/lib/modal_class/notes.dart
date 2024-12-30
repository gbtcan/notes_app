// Tệp này chứa lớp Note, được sử dụng để tạo đối tượng Note
class Note {
  String id;
  String title;
  String description;
  int priority;
  int color;
  String date;

  Note(this.id, this.title, this.description, this.priority, this.color,
      this.date);

  // Hàm fromMapObject chuyển đổi một Map thành một đối tượng Note
  factory Note.fromMapObject(Map<String, dynamic> map) {
    return Note(
      map['id'] ?? '',
      map['title'] ?? '',
      map['description'] ?? '',
      map['priority'] ?? 0,
      map['color'] ?? 0,
      map['date'] ?? '',
    );
  }

  // Hàm toMap chuyển đổi một đối tượng Note thành một Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'color': color,
      'date': date,
    };
  }
}
