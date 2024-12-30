import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:backend/controllers/note_controller.dart';
import 'package:backend/db.dart';

void main() async {
  final db = DatabaseConnection();
  await db.connect();

  final app = Router();

  app.mount('/notes/', NoteController().router);

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler(app);

  final server = await io.serve(handler, InternetAddress.anyIPv4, 9000);
  print('Server listening on port ${server.port}');

  // Đóng kết nối khi server dừng
  ProcessSignal.sigint.watch().listen((signal) async {
    await db.close();
    exit(0);
  });
}

Middleware corsHeaders() {
  return (Handler handler) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': 'Origin, Content-Type',
        });
      }
      final response = await handler(request);
      return response.change(headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Origin, Content-Type',
      });
    };
  };
}
