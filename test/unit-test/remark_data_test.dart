import 'package:commercial_app/data/models/remark_api.dart';
import 'package:commercial_app/services/service_export.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeFirebaseFirestore mockFs;
  late RemarkDataService service;

  setUp(() {
    mockFs = FakeFirebaseFirestore();
    service = RemarkDataService(firestore: mockFs);
  });

  test('возвращает совпадения по remarkText и gost', () async {
    await mockFs.collection('remarks').add(<String, String>{
      'remarkText': 'TestOne',
      'gost': 'G1',
    });
    await mockFs.collection('remarks').add(<String, String>{
      'remarkText': 'Other',
      'gost': 'TestTwo',
    });
    await mockFs.collection('remarks').add(<String, String>{
      'remarkText': 'NoMatch',
      'gost': 'G3',
    });

    final List<RemarkApi> res1 = await service.getRemarkSuggestions('test');
    expect(res1.length, 2);

    expect(
      res1.map((RemarkApi r) => r.remarkText),
      // ignore: always_specify_types
      containsAll(['TestOne', 'Other']),
    );
  });

  test('пустой список если нет совпадений', () async {
    await mockFs.collection('remarks').add(<String, String>{
      'remarkText': 'Foo',
      'gost': 'Bar',
    });
    final List<RemarkApi> res = await service.getRemarkSuggestions('zzz');
    expect(res, isEmpty);
  });
}
