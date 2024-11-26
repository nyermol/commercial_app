// ignore_for_file: use_build_context_synchronously, always_specify_types

import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/data/models/models_export.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/injection_container.dart';
import 'package:commercial_app/presentation/screens/no_internet/no_internet_screen.dart';
import 'package:commercial_app/presentation/screens/sign_in/sign_in_screen.dart';
import 'package:commercial_app/presentation/theme/app_theme.dart';
import 'package:commercial_app/presentation/widgets/snack_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nested/nested.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatefulWidget {
  final Connectivity connectivity;

  const MyApp({
    super.key,
    required this.connectivity,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  bool _clearDataCalled = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    SystemChrome.setSystemUIOverlayStyle(
      AppTheme.getSystemUiOverlayStyle(brightness),
    );
    return MultiBlocProvider(
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
        BlocProvider<RemarksCubit>(
          create: (BuildContext context) => sl<RemarksCubit>(),
        ),
        BlocProvider<InternetCubit>(
          create: (BuildContext context) =>
              InternetCubit(connectivity: widget.connectivity),
        ),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppTheme.getSystemUiOverlayStyle(
          Theme.of(context).brightness,
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const <LocalizationsDelegate>[
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          themeMode: ThemeMode.system,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          navigatorKey: navigatorKey,
          builder: (BuildContext context, Widget? child) {
            if (!_clearDataCalled) {
              _clearDataCalled = true;
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                final ClearCubit clearCubit = sl<ClearCubit>();
                await clearCubit.clearAllDataOnStart(context);
                context.read<ButtonCubit>().initializeDefaults(context);
              });
            }
            return BlocListener<InternetCubit, InternetState>(
              listener: (BuildContext context, InternetState state) {
                final NavigatorState? navigator = navigatorKey.currentState;
                if (state.type == InternetTypes.offline) {
                  navigator?.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const NoInternetScreen()),
                    (Route route) => false,
                  );
                } else if (state.type == InternetTypes.connected) {
                  navigator?.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const SignInScreen()),
                    (Route route) => false,
                  );
                  SnackBarAction action = SnackBarAction(
                    label: S.of(context).clearTheData,
                    textColor: const Color(0xFF24555E),
                    onPressed: () async {
                      try {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setBool('manualClearRequested', true);
                        await context
                            .read<ClearCubit>()
                            .clearAllDataOnStart(context);
                        setState(() {});
                        showCustomSnackBar(
                          context,
                          S.of(context).dataClearedSuccessfully,
                          Colors.green,
                        );
                      } catch (e) {
                        showCustomSnackBar(
                          context,
                          S.of(context).dataCleaningError,
                          Colors.red,
                        );
                      }
                    },
                  );
                  showCustomSnackBar(
                    context,
                    S.of(context).clearTheDataAndStartOver,
                    Colors.grey,
                    action: action,
                  );
                }
              },
              child: child,
            );
          },
          home: const SignInScreen(),
        ),
      ),
    );
  }
}
