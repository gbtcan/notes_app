import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/db_helper/db_helper.dart';
import 'package:notes_app/modal_class/notes.dart';
import 'package:notes_app/utils/widgets.dart';

// Lớp NoteDetail kế thừa StatefulWidget
// Lớp này hiển thị chi tiết của một ghi chú và cho phép chỉnh sửa ghi chú đó
class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  const NoteDetail(this.note, this.appBarTitle, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

// Lớp trạng thái của NoteDetail
// Lớp này quản lý trạng thái của NoteDetail, bao gồm các thao tác như lưu, xóa, cập nhật ghi chú
class NoteDetailState extends State<NoteDetail> {
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late int color;
  bool isEdited = false;

  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    titleController.text = note.title;
    descriptionController.text = note.description;
    color = note.color;
    return WillPopScope(
      onWillPop: () async {
        if (isEdited) {
          bool discard = await showDiscardDialog(context);
          return discard;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            appBarTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          backgroundColor: colors[color],
          leading: IconButton(
              splashRadius: 22,
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                isEdited ? showDiscardDialog(context) : moveToLastScreen();
              }),
          actions: <Widget>[
            IconButton(
              splashRadius: 22,
              icon: const Icon(
                Icons.save,
                color: Colors.black,
              ),
              onPressed: () {
                titleController.text.isEmpty
                    ? showEmptyTitleDialog(context)
                    : _save();
              },
            ),
            IconButton(
              splashRadius: 22,
              icon: const Icon(Icons.delete, color: Colors.black),
              onPressed: () {
                showDeleteDialog(context);
              },
            )
          ],
        ),
        body: Container(
          color: colors[color],
          child: Column(
            children: <Widget>[
              PriorityPicker(
                selectedIndex: 3 - note.priority,
                onTap: (index) {
                  isEdited = true;
                  note.priority = 3 - index;
                },
              ),
              ColorPicker(
                selectedIndex: note.color,
                onTap: (index) {
                  setState(() {
                    color = index;
                  });
                  isEdited = true;
                  note.color = index;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: titleController,
                  maxLength: 255,
                  style: Theme.of(context).textTheme.bodyMedium,
                  onChanged: (value) {
                    updateTitle();
                  },
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Tiêu đề',
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    maxLength: 10000000000000,
                    controller: descriptionController,
                    style: Theme.of(context).textTheme.bodyLarge,
                    onChanged: (value) {
                      updateDescription();
                    },
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Mô tả',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hiển thị hộp thoại xác nhận hủy bỏ thay đổi
  Future<bool> showDiscardDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: Text(
                "Hủy bỏ thay đổi?",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              content: Text(
                "Bạn có chắc chắn muốn hủy bỏ các thay đổi?",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    "Không",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.purple),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text(
                    "Có",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.purple),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  // Hiển thị hộp thoại thông báo tiêu đề trống
  void showEmptyTitleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Tiêu đề trống!",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          content: Text('Tiêu đề của ghi chú không được để trống.',
              style: Theme.of(context).textTheme.bodyLarge),
          actions: <Widget>[
            TextButton(
              child: Text("Đồng ý",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Hiển thị hộp thoại xác nhận xóa ghi chú
  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Xóa ghi chú?",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          content: Text("Bạn có chắc chắn muốn xóa ghi chú này?",
              style: Theme.of(context).textTheme.bodyLarge),
          actions: <Widget>[
            TextButton(
              child: Text("Không",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Có",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
                _delete();
              },
            ),
          ],
        );
      },
    );
  }

  // Quay lại màn hình trước đó
  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Cập nhật tiêu đề ghi chú
  void updateTitle() {
    isEdited = true;
    note.title = titleController.text;
  }

  // Cập nhật mô tả ghi chú
  void updateDescription() {
    isEdited = true;
    note.description = descriptionController.text;
  }

  // Lưu ghi chú
  void _save() async {
    try {
      moveToLastScreen();
      note.date = DateFormat.yMMMd().format(DateTime.now());
      print('Saving note: ${note.toMap()}');

      if (note.id.isEmpty) {
        await helper.insertNote(note);
        print('New note saved successfully');
      } else {
        await helper.updateNote(note);
        print('Note updated successfully');
      }
    } catch (e) {
      print('Error saving note: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi lưu ghi chú: $e')),
      );
    }
  }

  // Xóa ghi chú
  void _delete() async {
    await helper.deleteNote(note.id);
    moveToLastScreen();
  }
}
