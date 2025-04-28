import 'package:cloud_firestore/cloud_firestore.dart';

// Проверка логина/пароля в Firestore
class AuthService {
  final FirebaseFirestore firestore;

  AuthService({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  // Возвращает `true`, если такой user есть и passwords совпадают
  Future<bool> checkLogin({
    required String login,
    required String password,
  }) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('users')
        .where(
          'login',
          isEqualTo: login,
        )
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return false;

    final Map<String, dynamic> data = snapshot.docs.first.data();
    return data['password'] == password;
  }
}
