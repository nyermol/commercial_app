// Перечень регулярных выражений
final RegExp nameRegExp = RegExp(r'[a-zA-Zа-яА-Я. ]');
final RegExp textRegExp = RegExp(r'[0-9a-zA-Zа-яА-Я., -]');

// Перечень ключей для кнопок для сброса при новом запуске
final List<String> keys = <String>[
  'thermalImagingInspection',
  'thermalImagingConclusion',
  'underfloorHeating',
];

// API ключ для конвертации документа
const String convertApiKey =
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNTUyMzRkMzIzOTg5ZjYzNGU4NTk3YzE5ZGU2NzI3ZjY1OGIxNmI0NzNhNTFhNTYzZTFhNDhlNTIxZDNiNzdiODJiY2U3ODVlNDJlYzBiYTUiLCJpYXQiOjE3MjgyMjcwMDIuNjQ0NjU5LCJuYmYiOjE3MjgyMjcwMDIuNjQ0NjYsImV4cCI6NDg4MzkwMDYwMi42Mzk1MjQsInN1YiI6IjY5Nzc5Mjk1Iiwic2NvcGVzIjpbInRhc2sucmVhZCIsInRhc2sud3JpdGUiXX0.kcJGAnNoji1j7gO2KJafEIJ2Qepaf8rbFeP4xhBsC_YtQva_gzE7GCvQo9Gqswn8lDi1_yAZq5UoNthm__H0zqK5v4Iuhs7j9sBFXQr3s9qeAViiosw21gchpvaoBUVePM4U3VUgfy6ZrsgWo9UBylaxYLyK-v2aYlaRzQZYiVDguMLYwpA0lZUr-o7y1FUzaXmGPK6cc1QaDKfyn0dxjuiDdDk_mA_PuzvDZgNKu12Z-sBmGtCiYGb_QT1LN6XAOr8ZooPC1iDZKYuQcAOUxshRQLRIMCLcXNe5goJDYUCBUrJfCVgVo5UkREUyJvM33_ncAuT2r0pNJcMMjJjrtu7tf2db3Kh1tBnYyFy6MjPj9XgM6tjmGWUm78AxUGtnmCLjs2Le3tvT_qdbStwKQbKCpcjjRnIAd2Gfvz4L4Wa5qmGje-ys2exU7lOSap1h-IpK9AhkJsHwHLxiyeRToGBv4LW6RLFZg6dtIGRf8kzwhuPDQsyam9AT-CBCS_ExeeezTvvqLMPykfATlBM5NR9oBbNOgRPXhmORHO3-6eRvCIjsGAlfWC2_TDtTGSeQ5mCoKAFaWvMeM7_NqikCYM5dWQRUGPF1Rglq3js8FEKGKopm1nz1nUsj146br0RgV6c2vCohXbtpxsMJ_19YQpFvFx3W7tmn9PPTLsP_U74';

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
