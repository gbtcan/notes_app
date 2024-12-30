import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:notes_app/modal_class/notes.dart';

// Lớp DatabaseHelper chứa các hàm xử lý các yêu cầu liên quan đến cơ sở dữ liệu
class DatabaseHelper {
  final String baseUrl = 'http://localhost:9000/notes/';

  // Hàm getNoteList lấy danh sách các ghi chú từ cơ sở dữ liệu
  Future<List<Note>> getNoteList() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      print('Trạng thái phản hồi: ${response.statusCode}');
      print('Nội dung phản hồi: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((note) => Note.fromMapObject(note)).toList();
      } else {
        throw Exception('Không tải được ghi chú: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi trong getNoteList: $e');
      throw Exception('Không tải được ghi chú');
    }
  }

  // Hàm insertNote thêm một ghi chú mới
  Future<void> insertNote(Note note) async {
    try {
      print('Đang thêm ghi chú: ${note.toMap()}');
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(note.toMap()),
      );

      print('Trạng thái phản hồi khi thêm: ${response.statusCode}');
      print('Nội dung phản hồi khi thêm: ${response.body}');

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Không thêm được ghi chú: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi trong insertNote: $e');
      throw Exception('Không thêm được ghi chú: $e');
    }
  }

  // Hàm updateNote cập nhật một ghi chú
  Future<void> updateNote(Note note) async {
    try {
      print('Đang cập nhật ghi chú: ${note.toMap()}');
      final response = await http.put(
        Uri.parse('$baseUrl${note.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(note.toMap()),
      );

      print('Trạng thái phản hồi khi cập nhật: ${response.statusCode}');
      print('Nội dung phản hồi khi cập nhật: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Không cập nhật được ghi chú: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi trong updateNote: $e');
      throw Exception('Không cập nhật được ghi chú: $e');
    }
  }

  // Hàm deleteNote xóa một ghi chú
  Future<void> deleteNote(String id) async {
    try {
      print('Đang xóa ghi chú: $id');
      final response = await http.delete(
        Uri.parse('$baseUrl$id'),
        headers: <String, String>{
          'Accept': 'application/json',
        },
      );

      print('Trạng thái phản hồi khi xóa: ${response.statusCode}');
      print('Nội dung phản hồi khi xóa: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Không xóa được ghi chú: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi trong deleteNote: $e');
      throw Exception('Không xóa được ghi chú: $e');
    }
  }
}
