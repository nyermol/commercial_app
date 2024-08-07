// ignore_for_file: always_specify_types

import 'package:cloud_firestore/cloud_firestore.dart';

class Remark {
  final String remarkText;
  final String? gost;

  const Remark({required this.remarkText, this.gost});

  static Remark fromJson(Map<String, dynamic> json) => Remark(
        remarkText: json['remarkText'],
        gost: json['gost'],
      );
}

class RemarkApi {
  static Future<List<Remark>> getRemarkSuggestions(String query) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference remarksCollection =
        firestore.collection('remarks');

    final QuerySnapshot snapshot = await remarksCollection.get();
    final List<QueryDocumentSnapshot> documents = snapshot.docs;

    return documents.map((QueryDocumentSnapshot<Object?> doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Remark.fromJson(data);
    }).where((Remark remark) {
      final String remarkLower = remark.remarkText.toLowerCase();
      final String gostLower = remark.gost?.toLowerCase() ?? '';
      final String queryLower = query.toLowerCase();
      return remarkLower.contains(queryLower) || gostLower.contains(queryLower);
    }).toList();
  }
}
