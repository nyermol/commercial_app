// ignore_for_file: always_specify_types, use_build_context_synchronously

import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/data/enums/enums_export.dart';
import 'package:commercial_app/data/models/models_export.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/injection_container.dart';
import 'package:commercial_app/presentation/screens/no_internet/no_internet_screen.dart';
import 'package:commercial_app/presentation/screens/phone_screen_alert/phone_screen_alert.dart';
import 'package:commercial_app/presentation/screens/sign_in/sign_in_screen.dart';
import 'package:commercial_app/presentation/theme/app_theme.dart';
import 'package:commercial_app/presentation/widgets/snack_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  bool _clearDataCalled = false;

  @override
  Widget build(BuildContext context) {
    // Инициализация проверки размеров экрана устройства
    SizeConfig().init(context);
    final double screenWidth = SizeConfig.screenWidth;
    final Orientation orientation = SizeConfig.orientation;
    const double phoneMaxWidth = 600;
    // Получение системной темы
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    SystemChrome.setSystemUIOverlayStyle(
      AppTheme.getSystemUiOverlayStyle(brightness),
    );
    // Темы для IOS
    final ThemeData materialLight = ThemeData.light();
    final ThemeData materialDark = ThemeData.dark();
    final MaterialBasedCupertinoThemeData cupertinoLight =
        MaterialBasedCupertinoThemeData(
      materialTheme: materialLight,
    );
    final MaterialBasedCupertinoThemeData cupertinoDark =
        MaterialBasedCupertinoThemeData(
      materialTheme: materialDark.copyWith(
        cupertinoOverrideTheme: const CupertinoThemeData(
          brightness: Brightness.dark,
        ),
      ),
    );
    // Инициализация кубитов
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
        // Установка системной темы
        value: AppTheme.getSystemUiOverlayStyle(
          Theme.of(context).brightness,
        ),
        child: PlatformProvider(
          settings: PlatformSettingsData(
            iosUsesMaterialWidgets: true,
          ),
          // Темы приложения
          builder: (BuildContext context) => PlatformTheme(
            themeMode: ThemeMode.system,
            materialLightTheme: AppTheme.lightTheme,
            materialDarkTheme: AppTheme.darkTheme,
            cupertinoLightTheme: cupertinoLight,
            cupertinoDarkTheme: cupertinoDark,
            matchCupertinoSystemChromeBrightness: true,
            builder: (BuildContext context) => PlatformApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const <LocalizationsDelegate>[
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              navigatorKey: navigatorKey,
              builder: (BuildContext context, Widget? child) {
                // Проверка, чтобы приложение открылось только на смартфоне с портретной ориентацией
                if (orientation != Orientation.portrait ||
                    screenWidth > phoneMaxWidth) {
                  return const PhoneScreenAlert();
                }
                // Очистка локальных хранилищ при инициализации
                if (!_clearDataCalled) {
                  _clearDataCalled = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    final ClearCubit clearCubit = sl<ClearCubit>();
                    await clearCubit.clearAllDataOnStart(context);
                    context.read<ButtonCubit>().initializeDefaults(context);
                  });
                }
                // Проверка интернет-соединения
                return ScaffoldMessenger(
                  key: scaffoldMessengerKey,
                  child: BlocListener<InternetCubit, InternetState>(
                    listener: (BuildContext context, InternetState state) {
                      final NavigatorState? navigator =
                          navigatorKey.currentState;
                      if (state.type == InternetTypes.offline) {
                        navigator?.pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const NoInternetScreen(),
                          ),
                          (_) => false,
                        );
                      } else if (state.type == InternetTypes.connected) {
                        navigator?.pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const SignInScreen(),
                          ),
                          (_) => false,
                        );
                        // Возможность очистить все данные при потере интернет-соединения
                        SnackBarAction action = SnackBarAction(
                          label: S.of(context).clearTheData,
                          textColor: mainColor,
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
                  ),
                );
              },
              home: const SignInScreen(),
            ),
          ),
        ),
      ),
    );
  }
}
