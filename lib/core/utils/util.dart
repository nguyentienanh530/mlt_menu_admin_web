import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'utils.dart';

class Ultils {
  static bool validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) return false;
    var phoneRegex = RegExp(r"(09|03|07|08|05)+([0-9]{8})\b");
    return phoneRegex.hasMatch(phone);
  }

  static bool validatePassword(String? password) {
    if (password == null || password.isEmpty) return false;
    var emailRegex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    return emailRegex.hasMatch(password);
  }
  //

  static bool validateEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    var emailRegex = RegExp(
        r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return emailRegex.hasMatch(email);
  }

  static String currencyFormat(double double) {
    final oCcy = NumberFormat("###,###,###", "vi");
    return oCcy.format(double);
  }

  static String formatDateTime(String dateTimeString) {
    final inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    final outputFormat = DateFormat('HH:mm - dd/MM/yyyy');

    final dateTime = inputFormat.parse(dateTimeString);
    return outputFormat.format(dateTime);
  }

  static String formatToDate(String dateTimeString) {
    final inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    final outputFormat = DateFormat('yyyy-MM-dd');
    final dateTime = inputFormat.parse(dateTimeString);
    return outputFormat.format(dateTime);
  }

  static String reverseDate(String dateTimeString) {
    final inputFormat = DateFormat('yyyy-MM-dd');
    final outputFormat = DateFormat('dd/MM/yyyy');
    final dateTime = inputFormat.parse(dateTimeString);
    return outputFormat.format(dateTime);
  }

  static String tableStatus(bool isUse) {
    switch (isUse) {
      case false:
        return 'Trống';
      case true:
        return 'Sử dụng';
      default:
        return 'Trống';
    }
  }

  static String foodStatus(bool isShow) {
    switch (isShow) {
      case false:
        return 'Món ăn đang ẩn';
      case true:
        return 'Món ăn đang hiển thị';
      default:
        return 'Món ăn đang ẩn';
    }
  }

  static num foodPrice(
      {required bool isDiscount,
      required num foodPrice,
      required int discount}) {
    double discountAmount = (foodPrice * discount.toDouble()) / 100;
    num discountedPrice = foodPrice - discountAmount;

    return isDiscount ? discountedPrice : foodPrice;
  }

  static Future<void> sendPrintToServer(
      {String? ip, String? port, List? lst}) async {
    logger.d(lst);
    final socket = await Socket.connect(ip, int.parse(port!));
    logger.d(
        'Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
    // logger.d(lst);
    // Gửi lệnh đến server
    socket.writeln(lst);

    // Đọc phản hồi từ server
    socket.listen(
      (List<int> data) {
        final serverResponse = utf8.decode(data);
        logger.d('Server response: $serverResponse');

        // Cập nhật UI khi nhận được phản hồi từ server

        // Đặt lại trạng thái của nút sau 5 giây
        Future.delayed(const Duration(seconds: 5), () {});

        socket.close(); // Đóng kết nối sau khi nhận phản hồi
      },
      onDone: () {
        logger.d('Server disconnected.');
      },
      onError: (error) {
        logger.e('Error: $error');
      },
      cancelOnError: true,
    );
  }
}

Future pop(BuildContext context, int returnedLevel) async {
  for (var i = 0; i < returnedLevel; ++i) {
    context.pop<bool>(true);
  }
}

// Future<String> uploadImage({required String path, required File file}) async {
//   var image = '';
//   Reference storageReference = FirebaseStorage.instance
//       .ref()
//       .child('$path/${file.path.split('/').last}');
//   UploadTask uploadTask = storageReference.putFile(file);
//   await uploadTask.whenComplete(() async {
//     var url = await storageReference.getDownloadURL();
//     image = url.toString();
//   });
//   return image;
// }

Future<String> uploadImage(
    {required String path,
    required File file,
    required ValueNotifier progress}) async {
  var image = '';
  Reference storageReference = FirebaseStorage.instance
      .ref()
      .child('$path/${file.path.split('/').last}');

  UploadTask uploadTask = storageReference.putFile(file);
  uploadTask.snapshotEvents.listen((event) {
    progress.value =
        ((event.bytesTransferred.toDouble() / event.totalBytes.toDouble()) *
                100)
            .roundToDouble();
  });

  await uploadTask.then((snap) async {
    var url = await snap.ref.getDownloadURL();
    image = url.toString();
  });

  return image;
}

Future<dynamic> pickImage() async {
  // ignore: prefer_typing_uninitialized_variables
  var imageFile;
  final imagePicker = ImagePicker();
  var imagepicked = await imagePicker.pickImage(
      source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
  if (imagepicked != null) {
    imageFile = File(imagepicked.path);
  } else {
    logger.d('No image selected!');
  }
  return imageFile;
}
