import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercial_app/data/models/models_export.dart';

// Получение списка RemarkApi по запросу
class RemarkDataService {
  final FirebaseFirestore firestore;

  RemarkDataService({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<RemarkApi>> getRemarkSuggestions(String query) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('remarks').get();

    return snapshot.docs
        .map(
      (QueryDocumentSnapshot<Map<String, dynamic>> e) =>
          RemarkApi.fromJson(e.data()),
    )
        .where((RemarkApi remark) {
      final String q = query.toLowerCase();
      return remark.remarkText.toLowerCase().contains(q) ||
          (remark.gost?.toLowerCase().contains(q) ?? false);
    }).toList();
  }
}
