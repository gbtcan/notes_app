# notes_app

Một dự án Flutter mới.

## Bắt đầu

Dự án này là điểm khởi đầu cho một ứng dụng Flutter.

Một số tài nguyên để bạn bắt đầu nếu đây là dự án Flutter đầu tiên của bạn:

- [Lab: Viết ứng dụng Flutter đầu tiên của bạn](https://docs.flutter.dev/get-started/codelab)
- [Sách dạy nấu ăn: Các mẫu Flutter hữu ích](https://docs.flutter.dev/cookbook)

Để được hỗ trợ khi bắt đầu phát triển Flutter, hãy xem
[tài liệu trực tuyến](https://docs.flutter.dev/), tài liệu này cung cấp các hướng dẫn, mẫu mã, hướng dẫn về phát triển di động và toàn bộ tài liệu tham khảo API.

## Cấu trúc dự án

```
Notes_app/
├── backend/
│   ├── bin/
│   │   └── server.dart           # File chính để khởi chạy server
│   │
│   ├── lib/
│   │   ├── controllers/
│   │   │   └── note_controller.dart  # Xử lý các request HTTP và điều hướng
│   │   │
│   │   ├── models/
│   │   │   └── note.dart            # Định nghĩa cấu trúc dữ liệu Note
│   │   │
│   │   ├── services/
│   │   │   └── note_service.dart    # Xử lý logic nghiệp vụ
│   │   │
│   │   └── db.dart                  # Quản lý kết nối và truy vấn PostgreSQL
│   │
│   └── pubspec.yaml                 # Cấu hình dependencies cho backend
│
└── frontend/
    ├── lib/
    │   ├── db_helper/
    │   │   └── db_helper.dart       # Xử lý kết nối với backend API
    │   │
    │   ├── modal_class/
    │   │   └── notes.dart           # Model Note cho frontend
    │   │
    │   ├── screens/
    │   │   ├── note_detail.dart     # Màn hình chi tiết ghi chú
    │   │   ├── note_list.dart       # Màn hình danh sách ghi chú
    │   │   └── search_note.dart     # Màn hình tìm kiếm ghi chú
    │   │
    │   ├── utils/
    │   │   └── widgets.dart         # Các widget dùng chung (ColorPicker, PriorityPicker)
    │   │
    │   └── main.dart               # Entry point của ứng dụng Flutter
    │
    └── pubspec.yaml                # Cấu hình dependencies cho frontend
```

## Chi tiết chức năng

### Backend:
- `server.dart`: Khởi tạo và chạy server
- `note_controller.dart`: Xử lý các API endpoints (GET, POST, PUT, DELETE)
- `note_service.dart`: Xử lý logic nghiệp vụ và tương tác với database
- `note.dart`: Model định nghĩa cấu trúc dữ liệu ghi chú
- `db.dart`: Quản lý kết nối PostgreSQL và thực thi các truy vấn

### Frontend:
- `main.dart`: Điểm khởi đầu ứng dụng, cấu hình theme
- `db_helper.dart`: Xử lý gọi API đến backend
- `notes.dart`: Model ghi chú cho frontend
- `note_detail.dart`: Màn hình xem/chỉnh sửa ghi chú
- `note_list.dart`: Màn hình hiển thị danh sách ghi chú
- `search_note.dart`: Chức năng tìm kiếm ghi chú
- `widgets.dart`: Các widget tái sử dụng (ColorPicker, PriorityPicker)

## Luồng dữ liệu

1. Frontend gửi request đến backend thông qua `db_helper.dart`
2. Backend nhận request qua `note_controller.dart`
3. Controller chuyển yêu cầu đến `note_service.dart`
4. Service xử lý logic và tương tác với database qua `db.dart`
5. Dữ liệu được trả về theo chiều ngược lại