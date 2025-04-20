import 'package:commercial_app/service/service_export.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeFirebaseFirestore mockFs;
  late AuthService authService;

  setUp(() {
    mockFs = FakeFirebaseFirestore();
    authService = AuthService(firestore: mockFs);
  });

  test('возвращает true при корректном логине/пароле', () async {
    await mockFs.collection('users').add(<String, String>{
      'login': '11111111111',
      'password': 'passwordpassword',
    });

    final bool result = await authService.checkLogin(
      login: '11111111111',
      password: 'passwordpassword',
    );
    expect(result, isTrue);
  });

  test('возвращает false при неправильном пароле', () async {
    await mockFs.collection('users').add(<String, String>{
      'login': '11111111111',
      'password': 'passwordpassword',
    });

    final bool result = await authService.checkLogin(
      login: '11111111111',
      password: 'passpasspass',
    );
    expect(result, isFalse);
  });

  test('возвращает false если пользователь не найден', () async {
    final bool result = await authService.checkLogin(
      login: '22222222222',
      password: 'passpasspass',
    );
    expect(result, isFalse);
  });
}
