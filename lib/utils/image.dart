import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

pikeImage(ImageSource source) async {
  ImagePicker piker = ImagePicker();
  XFile? file = await piker.pickImage(source: source);
  CroppedFile? file1 = await ImageCropper().cropImage(sourcePath: file!.path);
  File? file2 = await FlutterImageCompress.compressAndGetFile(
      File(file1!.path).absolute.path,
      File(file1.path).absolute.path + "compress.jpg",
      quality: 30);

  if (file2 != null) {
    return await file2.readAsBytes();
  }
}

showSnackbar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}
