// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';
import 'image_picker_service.dart';

class ImagePickerServiceImpl implements ImagePickerService {
  @override
  Future<Uint8List?> pickImage() {
    final Completer<Uint8List?> completer = Completer<Uint8List?>();
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement()
          ..accept = 'image/*'
          ..setAttribute('capture', 'camera');

    uploadInput.click();
    uploadInput.onChange.listen((_) {
      final List<html.File>? files = uploadInput.files;
      if (files == null || files.isEmpty) {
        completer.complete(null);
        return;
      }
      final html.FileReader reader = html.FileReader();
      reader.readAsArrayBuffer(files[0]);
      reader.onLoadEnd.listen((_) {
        final Object? result = reader.result;
        if (result is ByteBuffer) {
          completer.complete(Uint8List.view(result));
        } else if (result is Uint8List) {
          completer.complete(result);
        } else {
          completer.complete(null);
        }
      });
    });

    return completer.future;
  }
}
