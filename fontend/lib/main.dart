import 'package:flutter/material.dart';
import 'package:notes_app/screens/note_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteKeeper', // Có thể giữ nguyên hoặc dịch thành 'Ghi chú'
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
              fontFamily: 'Sans',
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 24),
          bodyMedium: TextStyle(
              fontFamily: 'Sans',
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 20),
          bodyLarge: TextStyle(
              fontFamily: 'Sans',
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 18),
          titleSmall: TextStyle(
              fontFamily: 'Sans',
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 14),
        ),
      ),
      home: const NoteList(),
    );
  }
}
