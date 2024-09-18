// ignore_for_file: always_specify_types, use_build_context_synchronously

import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/data/models/internet_state.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:commercial_app/domain/usecases/usecases_export.dart';
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
        BlocProvider<ListCubit>(
          create: (BuildContext context) => sl<ListCubit>(),
        ),
        BlocProvider<InternetCubit>(
          create: (BuildContext context) =>
              InternetCubit(connectivity: widget.connectivity),
        ),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppTheme.getSystemUiOverlayStyle(Theme.of(context).brightness),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const <LocalizationsDelegate>[
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          navigatorKey: navigatorKey,
          builder: (context, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              final ClearCubit clearCubit = sl<ClearCubit>();
              final checkFirstLaunchUsecase =
                  CheckFirstLaunchUsecase(clearCubit: clearCubit);
              await checkFirstLaunchUsecase.call(context);
              context.read<ButtonCubit>().initializeDefaults(context);
            });
            return BlocListener<InternetCubit, InternetState>(
              listener: (context, state) {
                final navigator = navigatorKey.currentState;
                if (state.type == InternetTypes.offline) {
                  navigator?.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const NoInternetScreen()),
                    (route) => false,
                  );
                } else if (state.type == InternetTypes.connected) {
                  navigator?.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const SignInScreen()),
                    (route) => false,
                  );
                  SnackBarAction action = SnackBarAction(
                    label: S.of(context).clearTheData,
                    textColor: Colors.teal,
                    onPressed: () async {
                      try {
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
