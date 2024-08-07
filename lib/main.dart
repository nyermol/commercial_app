// ignore_for_file: always_specify_types

import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/injection_container.dart';
import 'package:commercial_app/presentation/cubit/cubit_export.dart';
import 'package:commercial_app/presentation/screens/sign_in/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nested/nested.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: <SingleChildWidget>[
          BlocProvider<ClearCubit>(
              create: (BuildContext context) => sl<ClearCubit>(),),
          BlocProvider<ValidationCubit>(
              create: (BuildContext context) => sl<ValidationCubit>(),),
          BlocProvider<DataCubit>(
            create: (BuildContext context) => sl<DataCubit>(),
          ),
          BlocProvider<ButtonCubit>(
            create: (BuildContext context) => sl<ButtonCubit>(),
          ),
          BlocProvider<ListCubit>(
            create: (BuildContext context) => sl<ListCubit>(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const <LocalizationsDelegate>[
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          theme: ThemeData.light().copyWith(
            textTheme: ThemeData.light().textTheme.apply(
                  fontFamily: 'Futura',
                ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            textTheme: ThemeData.dark().textTheme.apply(
                  fontFamily: 'Futura',
                ),
          ),
          home: const SignInScreen(),
        ),);
  }
}
