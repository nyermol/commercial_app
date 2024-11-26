class RemarkApi {
  final String remarkText;
  final String? gost;

  const RemarkApi({
    required this.remarkText,
    this.gost,
  });

  static RemarkApi fromJson(Map<String, dynamic> json) => RemarkApi(
        remarkText: json['remarkText'],
        gost: json['gost'],
      );
}
