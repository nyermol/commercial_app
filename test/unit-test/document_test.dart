import 'package:commercial_app/data/enums/enums_export.dart';
import 'package:commercial_app/service/service_export.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAnchor {
  String? downloaded;
  bool clicked = false;

  void setAttribute(String name, String value) {
    if (name == 'download') downloaded = value;
  }

  void click() {
    clicked = true;
  }
}

void main() {
  test('download mode: создаёт FakeAnchor и кликает', () {
    FakeAnchor? used;
    final DocumentService service = DocumentService(
      createAnchor: (String url) {
        final FakeAnchor fa = FakeAnchor()..downloaded = null;
        used = fa;
        return fa;
      },
      openWindow: (_, __) => throw Exception('Не должен открывать окно'),
    );

    service.generateDocument(
      url: 'u',
      fileName: 'f',
      mode: DocumentDisplayMode.download,
    );

    expect(used!.downloaded, 'f.pdf');
    expect(used!.clicked, isTrue);
  });

  test('open mode: вызывает openWindow', () {
    String? u;
    String? t;
    final DocumentService service = DocumentService(
      createAnchor: (_) => throw Exception('Не должен создавать якорь'),
      openWindow: (String url, String target) {
        u = url;
        t = target;
      },
    );

    service.generateDocument(
      url: 'u2',
      fileName: 'ignored',
      mode: DocumentDisplayMode.openNewWindow,
    );

    expect(u, 'u2');
    expect(t, '_blank');
  });
}
