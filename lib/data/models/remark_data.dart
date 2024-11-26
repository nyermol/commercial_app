import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercial_app/data/models/models_export.dart';

class RemarkData {
  static Future<List<RemarkApi>> getRemarkSuggestions(String query) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference<Map<String, dynamic>> remarksCollection =
        firestore.collection('remarks');
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await remarksCollection.get();
    final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
        snapshot.docs;
    return documents.map((QueryDocumentSnapshot<Object?> doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return RemarkApi.fromJson(data);
    }).where((RemarkApi remark) {
      final String remarkLower = remark.remarkText.toLowerCase();
      final String gostLower = remark.gost?.toLowerCase() ?? '';
      final String queryLower = query.toLowerCase();
      return remarkLower.contains(queryLower) || gostLower.contains(queryLower);
    }).toList();
  }
}
