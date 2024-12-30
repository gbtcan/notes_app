// filepath: /project_root/backend/lib/services/note_service.dart
import 'package:backend/db.dart';
import 'package:backend/models/note.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

// Lớp NoteService chứa các hàm thực hiện các thao tác với ghi chú
class NoteService {
  final db = DatabaseConnection();
  final uuid = Uuid();

  // Hàm getNotes trả về danh sách ghi chú
  Future<String> getNotes() async {
    try {
      final results =
          await db.query('SELECT * FROM note_table ORDER BY priority ASC');
      print('Raw database results: $results'); // Debug log

      final notes = results.map((row) {
        final mappedNote = Note.fromMap(row['note_table'] ?? row);
        print('Mapped note: ${mappedNote.toMap()}'); // Debug log
        return mappedNote;
      }).toList();

      final jsonResult = jsonEncode(notes.map((note) => note.toMap()).toList());
      print('Final JSON result: $jsonResult'); // Debug log
      return jsonResult;
    } catch (e) {
      print('Error in getNotes: $e');
      throw Exception('Failed to get notes');
    }
  }

  // Hàm addNote thêm một ghi chú mới
  Future<void> addNote(String payload) async {
    try {
      print('Processing payload in service: $payload'); // Debug log

      final Map<String, dynamic> data = jsonDecode(payload);
      final note = Note.fromMap(data);
      note.id = uuid.v4(); // Generate new UUID

      print('Prepared note for insertion: ${note.toMap()}'); // Debug log

      await db.execute(
        'INSERT INTO note_table (id, title, description, priority, color, date) VALUES (@id, @title, @description, @priority, @color, @date)',
        substitutionValues: note.toMap(),
      );

      print('Note inserted successfully'); // Debug log
    } catch (e) {
      print('Error in addNote service: $e'); // Debug log
      throw Exception('Failed to add note: $e');
    }
  }

  // Hàm updateNote cập nhật một ghi chú
  Future<void> updateNote(String id, String payload) async {
    final note = Note.fromJson(payload);
    await db.execute(
      'UPDATE note_table SET title = @title, description = @description, priority = @priority, color = @color, date = @date WHERE id = @id',
      substitutionValues: {
        'id': id,
        ...note.toMap(),
      },
    );
  }

  // Hàm deleteNote xóa một ghi chú
  Future<void> deleteNote(String id) async {
    try {
      await db.execute(
        'DELETE FROM note_table WHERE id = @id',
        substitutionValues: {'id': id},
      );
    } catch (e) {
      print('Error in deleteNote: $e');
      throw Exception('Failed to delete note');
    }
  }
}
