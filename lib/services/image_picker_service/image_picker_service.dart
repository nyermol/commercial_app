import 'dart:typed_data';

import 'image_picker_service_mobile.dart'
    if (dart.library.html) 'image_picker_service_web.dart';

// Интерфейс сервиса загрузки фото
abstract class ImagePickerService {
  Future<Uint8List?> pickImage();
}

// Передача правильной реализации
ImagePickerService getImagePickerService() => ImagePickerServiceImpl();
