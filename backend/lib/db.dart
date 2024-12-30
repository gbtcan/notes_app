// filepath: /project_root/backend/lib/db.dart
import 'package:postgres/postgres.dart';

// Lớp DatabaseConnection quản lý kết nối với cơ sở dữ liệu PostgreSQL
class DatabaseConnection {
  late PostgreSQLConnection connection;

  // Hàm khởi tạo một kết nối đến cơ sở dữ liệu PostgreSQL
  DatabaseConnection() {
    connection = PostgreSQLConnection(
      'localhost',
      5432,
      'Notes_app',
      username: 'postgres',
      password: '1234567890',
    );
  }

  // Hàm kết nối đến cơ sở dữ liệu
  Future<void> connect() async {
    if (connection.isClosed) {
      await connection.open();
    }
  }

  // Hàm đóng kết nối
  Future<void> close() async {
    if (!connection.isClosed) {
      await connection.close();
    }
  }

  // Hàm thực thi truy vấn SQL
  Future<List<Map<String, Map<String, dynamic>>>> query(String sql) async {
    await connect();
    final results = await connection.mappedResultsQuery(sql);
    return results;
  }

  // Hàm thực thi truy vấn SQL
  Future<void> execute(String sql,
      {Map<String, dynamic>? substitutionValues}) async {
    try {
      await connect();
      print('Executing SQL: $sql'); // Debug log
      print('With values: $substitutionValues'); // Debug log

      await connection.execute(sql, substitutionValues: substitutionValues);

      print('SQL executed successfully'); // Debug log
    } catch (e) {
      print('Database execution error: $e'); // Debug log
      throw Exception('Database error: $e');
    } finally {
      await close();
    }
  }
}
