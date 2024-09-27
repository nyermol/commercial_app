final RegExp numberRegExp = RegExp(r'[0-9]');
final RegExp nameRegExp = RegExp(r'[a-zA-Zа-яА-Я. ]');
final RegExp textRegExp = RegExp(r'[0-9a-zA-Zа-яА-Я., -]');

final List<String> keys = <String>[
  'thermalImagingInspection',
  'thermalImagingConclusion',
  'underfloorHeating',
];
