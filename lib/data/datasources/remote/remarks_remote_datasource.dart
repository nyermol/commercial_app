import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercial_app/data/models/models_export.dart';

abstract class RemarksRemoteDatasource {
  Future<List<RemarkApi>> getRemarkSuggestions(String query);
}

class RemarksRemoteDatasourceImpl implements RemarksRemoteDatasource {
  @override
  Future<List<RemarkApi>> getRemarkSuggestions(String query) async {
    // Получение коллекции из Firebase Firestore
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference<Map<String, dynamic>> remarksCollection =
        firestore.collection('remarks');
    // Загрузка содержимого коллекции
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await remarksCollection.get();
    // Преобразование содержимого в объект RemarkApi
    final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
        snapshot.docs;
    return documents.map((QueryDocumentSnapshot<Object?> doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return RemarkApi.fromJson(data);
    }).where((RemarkApi remark) {
      // Фильтрование результатов на основе совпадения текста замечания или ГОСТ с запросом
      final String remarkLower = remark.remarkText.toLowerCase();
      final String gostLower = remark.gost?.toLowerCase() ?? '';
      final String queryLower = query.toLowerCase();
      return remarkLower.contains(queryLower) || gostLower.contains(queryLower);
    }).toList();
  }
}
