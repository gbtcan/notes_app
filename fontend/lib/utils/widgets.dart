import 'package:flutter/material.dart';

List<Color> colors = [
  const Color(0xFFFFFFFF),
  const Color(0xffF28B83),
  const Color(0xFFFCBC05),
  const Color(0xFFFFF476),
  const Color(0xFFCBFF90),
  const Color(0xFFA7FEEA),
  const Color(0xFFE6C9A9),
  const Color(0xFFE8EAEE),
  const Color(0xFFA7FEEA),
  const Color(0xFFCAF0F8)
];

//Hàm StatefulWidget là một widget có thể thay đổi trạng thái
class PriorityPicker extends StatefulWidget {
  final Function(int) onTap;
  final int selectedIndex;
  const PriorityPicker({
    Key? key,
    required this.onTap,
    required this.selectedIndex,
  }) : super(key: key);
  @override
  _PriorityPickerState createState() => _PriorityPickerState();
}

//Hàm createState() tạo ra một đối tượng State mới cho StatefulWidget
class _PriorityPickerState extends State<PriorityPicker> {
  late int selectedIndex; // Khởi tạo với 'late'
  List<String> priorityText = ['Tùy chọn', 'Thường xuyên', 'Khẩn cấp'];
  List<Color> priorityColor = [Colors.green, Colors.lightGreen, Colors.red];

  //Hàm initState() được gọi khi một đối tượng State được tạo ra
  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  //Hàm build() xây dựng widget
  //Hàm này trả về một widget mới
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onTap(index);
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              width: width / 3,
              height: 70,
              child: Container(
                child: Center(
                  child: Text(priorityText[index],
                      style: TextStyle(
                          color: selectedIndex == index
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold)),
                ),
                decoration: BoxDecoration(
                    color: selectedIndex == index
                        ? priorityColor[index]
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                    border: selectedIndex == index
                        ? Border.all(width: 2, color: Colors.black)
                        : Border.all(width: 0, color: Colors.transparent)),
              ),
            ),
          );
        },
      ),
    );
  }
}

//Hàm StatefulWidget là một widget có thể thay đổi trạng thái
//Hàm này trả về một widget mới
class ColorPicker extends StatefulWidget {
  final Function(int) onTap;
  final int selectedIndex;
  const ColorPicker({
    Key? key,
    required this.onTap,
    required this.selectedIndex,
  }) : super(key: key);
  @override
  _ColorPickerState createState() => _ColorPickerState();
}

//Hàm createState() tạo ra một đối tượng State mới cho StatefulWidget
class _ColorPickerState extends State<ColorPicker> {
  late int selectedIndex; // Khởi tạo với 'late'

  //Hàm initState() được gọi khi một đối tượng State được tạo ra
  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex; // Khởi tạo trong initState
  }

  //Hàm build() xây dựng widget
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onTap(index);
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              width: 50,
              height: 50,
              child: Container(
                child: Center(
                    child: selectedIndex == index
                        ? const Icon(Icons.done)
                        : Container()),
                decoration: BoxDecoration(
                    color: colors[index],
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: Colors.black)),
              ),
            ),
          );
        },
      ),
    );
  }
}
