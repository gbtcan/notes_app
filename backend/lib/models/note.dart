// filepath: /notes_app/backend/lib/models/note.dart
import 'dart:convert';

// Lớp Note chứa thông tin của một ghi chú
class Note {
  String id;
  String title;
  String description;
  int priority;
  int color;
  String date;

  Note(this.id, this.title, this.description, this.priority, this.color,
      this.date);

  // Hàm fromMap chuyển đổi một Map thành một đối tượng Note
  factory Note.fromMap(Map<String, dynamic> map) {
    print('Creating Note from map: $map'); // Debug log
    return Note(
      map['id']?.toString() ?? '',
      map['title']?.toString() ?? '',
      map['description']?.toString() ?? '',
      map['priority'] is int
          ? map['priority']
          : int.tryParse(map['priority']?.toString() ?? '0') ?? 0,
      map['color'] is int
          ? map['color']
          : int.tryParse(map['color']?.toString() ?? '0') ?? 0,
      map['date']?.toString() ?? '',
    );
  }

  // Hàm fromJson chuyển đổi chuỗi JSON thành một đối tượng Note
  factory Note.fromJson(String json) {
    final map = jsonDecode(json);
    return Note.fromMap(map);
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

  // Ghi đè toString để in ra thông tin ghi chú
  @override
  String toString() {
    return jsonEncode(toMap());
  }
}
