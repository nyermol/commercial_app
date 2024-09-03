// ignore_for_file: always_specify_types

import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/injection_container.dart';
import 'package:commercial_app/presentation/cubit/cubit_export.dart';
import 'package:commercial_app/presentation/cubit/internet_state.dart';
import 'package:commercial_app/presentation/screens/sign_in/sign_in_screen.dart';
import 'package:commercial_app/presentation/widgets/default_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nested/nested.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await init();
  bootstrap();
}

void bootstrap() async {
  final Connectivity connectivity = sl<Connectivity>();
  runApp(
    MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<ClearCubit>(
          create: (BuildContext context) => sl<ClearCubit>(),
        ),
        BlocProvider<ValidationCubit>(
          create: (BuildContext context) => sl<ValidationCubit>(),
        ),
        BlocProvider<DataCubit>(
          create: (BuildContext context) => sl<DataCubit>(),
        ),
        BlocProvider<RoomCubit>(
          create: (BuildContext context) => sl<RoomCubit>(),
        ),
        BlocProvider<ButtonCubit>(
          create: (BuildContext context) => sl<ButtonCubit>(),
        ),
        BlocProvider<ListCubit>(
          create: (BuildContext context) => sl<ListCubit>(),
        ),
        BlocProvider<InternetCubit>(
          create: (BuildContext context) =>
              InternetCubit(connectivity: connectivity),
        ),
      ],
      child: const App(),
    ),
  );
}

final GlobalKey<NavigatorState> kNavigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ClearCubit>().clearAllDataOnStart();
    SizeConfig().init(context);
    return MaterialApp(
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
      navigatorKey: kNavigatorKey,
      builder: (context, child) {
        return BlocListener<InternetCubit, InternetState>(
          listener: (context, state) {
            if (state.type == InternetTypes.unknown) return;

            final navigator = kNavigatorKey.currentState;

            if (state.type == InternetTypes.offline) {
              if (navigator!.canPop()) {
                navigator.popUntil((route) => route.isFirst);
              }
              navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const NoInternetPage()),
                (route) => false,
              );
            } else if (state.type == InternetTypes.connected) {
              if (navigator!.canPop()) {
                navigator.popUntil((route) => route.isFirst);
              }
              navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const SignInScreen()),
                (route) => false,
              );
            }
          },
          child: child,
        );
      },
      home: const LoadingPage(),
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RotationTransition(
              turns: const AlwaysStoppedAnimation(45 / 360),
              child: SvgPicture.asset(
                'assets/images/company_logo.svg',
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Пожалуйста, подождите. Выполняется проверка вашего интернет-соединения.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Отсутствует интернет-соединение',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: SizeConfig.screenWidth * 0.6,
              child: DefaultButton(
                text: 'Попробовать снова',
                onPressed: () {
                  context.read<InternetCubit>().checkConnectivity();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
