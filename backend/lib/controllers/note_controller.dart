// filepath: /project_root/backend/lib/controllers/note_controller.dart
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:backend/services/note_service.dart';
import 'dart:convert';

// Lớp NoteController chứa các hàm xử lý các yêu cầu liên quan đến ghi chú
class NoteController {
  final NoteService _noteService = NoteService();

  // Hàm router trả về một Router xử lý các yêu cầu liên quan đến ghi chú
  Router get router {
    final router = Router();

    router.get('/', (Request request) async {
      try {
        final notes = await _noteService.getNotes();
        return Response.ok(
          notes,
          headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
          },
        );
      } catch (e) {
        print('Error in GET /: $e');
        return Response.internalServerError(
          body: json.encode({'error': 'Failed to get notes'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
    });

    // Thêm một ghi chú mới
    router.post('/', (Request request) async {
      try {
        final payload = await request.readAsString();
        print('Received payload: $payload'); // Debug log

        await _noteService.addNote(payload);

        return Response(201, // Changed from 200 to 201 for creation
            headers: {
              'Content-Type': 'application/json',
              'Access-Control-Allow-Origin': '*',
            },
            body: jsonEncode({'message': 'Note added successfully'}));
      } catch (e) {
        print('Error in POST handler: $e'); // Debug log
        return Response(500,
            headers: {
              'Content-Type': 'application/json',
              'Access-Control-Allow-Origin': '*',
            },
            body: jsonEncode({'error': 'Failed to add note: $e'}));
      }
    });

    // Cập nhật một ghi chú
    router.put('/<id>', (Request request, String id) async {
      try {
        final payload = await request.readAsString();
        await _noteService.updateNote(id, payload);
        return Response.ok(
          json.encode({'message': 'Note updated successfully'}),
          headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
          },
        );
      } catch (e) {
        print('Error in PUT /$id: $e');
        return Response.internalServerError(
          body: json.encode({'error': 'Failed to update note'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
    });

    // Xóa một ghi chú
    router.delete('/<id>', (Request request, String id) async {
      try {
        await _noteService.deleteNote(id);
        return Response.ok(
          json.encode({'message': 'Note deleted successfully'}),
          headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
          },
        );
      } catch (e) {
        print('Error in DELETE /$id: $e');
        return Response.internalServerError(
          body: json.encode({'error': 'Failed to delete note'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
    });

    return router;
  }
}
