import 'package:hive/hive.dart';

part 'remark.g.dart';

@HiveType(typeId: 1)
class Remark {
  @HiveField(0)
  String title;

  @HiveField(1)
  String subtitle;

  @HiveField(2)
  String gost;

  @HiveField(3)
  List<String> images;

  Remark({
    required this.title,
    required this.subtitle,
    required this.gost,
    required this.images,
  });

  Remark copyWith({
    String? title,
    String? subtitle,
    String? gost,
    List<String>? images,
  }) {
    return Remark(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      gost: gost ?? this.gost,
      images: images ?? this.images,
    );
  }
}
