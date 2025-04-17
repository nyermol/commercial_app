// Перечень регулярных выражений
final RegExp nameRegExp = RegExp(r'[a-zA-Zа-яА-Я. ]');
final RegExp textRegExp = RegExp(r'[0-9a-zA-Zа-яА-Я., -]');

// Перечень ключей для кнопок для сброса при новом запуске
final List<String> keys = <String>[
  'thermalImagingInspection',
  'thermalImagingConclusion',
  'underfloorHeating',
];

// Список помещений для выбора нужных
final List<String> roomNames = <String>[
  'Ком. помещение',
  'Комната',
  'Кухня',
  'Кухня-гостиная',
  'Коридор',
  'Балкон/лоджия',
  'Сан. узел',
  'Ванная',
  'Гардеробная',
];

// Список городов для выбора нужного
final List<String> cities = <String>[
  'Санкт-Петербург',
  'Краснодар',
];
