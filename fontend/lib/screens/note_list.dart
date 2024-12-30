import 'package:flutter/material.dart';
import 'package:notes_app/db_helper/db_helper.dart';
import 'package:notes_app/modal_class/notes.dart';
import 'package:notes_app/screens/note_detail.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/screens/search_note.dart';
import 'package:notes_app/utils/widgets.dart';

// Lớp NoteList kế thừa StatefulWidget
// Lớp này hiển thị danh sách các ghi chú
class NoteList extends StatefulWidget {
  const NoteList({super.key});

// Hàm tạo trạng thái của NoteList
// Hàm này trả về một trạng thái mới của NoteList
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

// Lớp trạng thái của NoteList
// Lớp này quản lý trạng thái của NoteList, bao gồm các thao tác như thêm, xóa, cập nhật ghi chú
class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList = [];
  int count = 0;
  int axisCount = 2;

// Hàm khởi tạo
// Hàm này được gọi khi một thể hiện của lớp được tạo ra
  @override
  void initState() {
    super.initState();
    updateListView();
  }

// Hàm build
// Hàm này xây dựng giao diện người dùng của lớp NoteList
  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget myAppBar() {
      return AppBar(
        title: Text('Ghi chú', style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: noteList.isEmpty
            ? Container()
            : IconButton(
                splashRadius: 22,
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                onPressed: () async {
                  final Note? result = await showSearch<Note?>(
                    context: context,
                    delegate: NotesSearch(notes: noteList),
                  );
                  if (result != null) {
                    navigateToDetail(result, 'Chỉnh sửa ghi chú');
                  }
                },
              ),
        actions: <Widget>[
          noteList.isEmpty
              ? Container()
              : IconButton(
                  splashRadius: 22,
                  icon: Icon(
                    axisCount == 2 ? Icons.list : Icons.grid_on,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      axisCount = axisCount == 2 ? 4 : 2;
                    });
                  },
                )
        ],
      );
    }

    // Trả về Scaffold chứa AppBar, body và floatingActionButton
    return Scaffold(
      appBar: myAppBar(),
      body: noteList.isEmpty
          ? Container(
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Nhấn nút thêm để thêm ghi chú mới!',
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              ),
            )
          : Container(
              color: Colors.white,
              child: getNotesList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(
              Note(
                  '', // id
                  '', // title
                  '', // description
                  3, // priority
                  0, // color
                  '' // date
                  ),
              'Thêm ghi chú');
        },
        tooltip: 'Thêm ghi chú',
        shape: const CircleBorder(
            side: BorderSide(color: Colors.black, width: 2.0)),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  // Hàm getNotesList
  // Hàm này trả về danh sách ghi chú
  Widget getNotesList() {
    return StaggeredGridView.countBuilder(
      physics: const BouncingScrollPhysics(),
      crossAxisCount: 4,
      itemCount: count,
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        onTap: () {
          navigateToDetail(noteList[index], 'Chỉnh sửa ghi chú');
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: colors[noteList[index].color],
                border: Border.all(width: 2, color: Colors.black),
                borderRadius: BorderRadius.circular(8.0)),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          noteList[index].title,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    Text(
                      getPriorityText(noteList[index].priority),
                      style: TextStyle(
                          color: getPriorityColor(noteList[index].priority)),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          noteList[index].description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(noteList[index].date,
                          style: Theme.of(context).textTheme.titleSmall),
                    ])
              ],
            ),
          ),
        ),
      ),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  // Trả về màu ưu tiên
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.green;
      default:
        return Colors.yellow;
    }
  }

  // Trả về văn bản ưu tiên
  String getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return 'Khẩn cấp';
      case 2:
        return 'Thường xuyên';
      case 3:
        return 'Tùy chọn';
      default:
        return 'Tùy chọn';
    }
  }

  // Hàm navigateToDetail
  // Hàm này chuyển hướng
  void navigateToDetail(Note? note, String title) async {
    if (note != null) {
      // Add null check
      bool result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => NoteDetail(note, title)));

      if (result) {
        // Changed from 'if (result == true)' to 'if (result)'
        updateListView();
      }
    }
  }

  // Hàm updateListView cập nhật danh sách ghi chú
  void updateListView() async {
    try {
      List<Note> notes = await databaseHelper.getNoteList();
      setState(() {
        this.noteList = notes;
        count = notes.length;
      });
    } catch (e) {
      print(
          'Lỗi trong quá trình cập nhật danh sách hiển thị Error in updateListView: $e');
    }
  }
}
