import 'package:commercial_app/service/service_export.dart';
import 'package:flutter_test/flutter_test.dart';

// Простая подделка вместо FileUploadInputElement
class FakeInput {
  String accept = '';
  String? capture;
  bool clicked = false;

  void setAttribute(String name, String value) {
    if (name == 'capture') capture = value;
  }

  void click() => clicked = true;
}

void main() {
  test('pickImage устанавливает accept, capture и вызывает click()', () {
    // Переменная, в которую запишем наш FakeInput
    FakeInput? captured;

    // Сервис с фабрикой, захватывающей созданный FakeInput
    final ImageService service = ImageService(
      createInput: () {
        captured = FakeInput();
        return captured!;
      },
    );

    // Вызов тестируемого метода
    service.pickImage();

    // Теперь у нас есть instance в captured
    expect(captured, isNotNull);
    expect(captured!.accept, 'image/*');
    expect(captured!.capture, 'camera');
    expect(captured!.clicked, isTrue);
  });
}
