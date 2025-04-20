// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;

// Теперь фабрика может вернуть любой объект (dynamic)
typedef FileInputFactory = dynamic Function();

class ImageService {
  final FileInputFactory _createInput;

  ImageService({FileInputFactory? createInput})
      : _createInput = createInput ?? _defaultFactory;

  static dynamic _defaultFactory() => html.FileUploadInputElement();

  // Открывает диалог камеры/файлов
  void pickImage() {
    // ignore: always_specify_types
    final input = _createInput();
    // dynamic-объект должен иметь эти свойства/методы
    input.accept = 'image/*';
    input.setAttribute('capture', 'camera');
    input.click();
  }
}
