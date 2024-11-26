import 'package:commercial_app/data/models/models_export.dart';
import 'package:commercial_app/firebase_options.dart';
import 'package:commercial_app/injection_container.dart';
import 'package:commercial_app/presentation/app/my_app.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(RemarkAdapter());
  Hive.registerAdapter(RoomAdapter());
  await Hive.openBox<Remark>('remarksBox');
  await Hive.openBox<Room>('roomsBox');
  await Hive.openBox<Uint8List>('imagesBox');
  await Hive.openBox<List<int>>('documentsBox');
  await init();
  final Connectivity connectivity = sl<Connectivity>();
  runApp(
    MyApp(
      connectivity: connectivity,
    ),
  );
}
