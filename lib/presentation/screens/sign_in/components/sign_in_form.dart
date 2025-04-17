// ignore_for_file: use_build_context_synchronously, always_specify_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/presentation/widgets/default_button.dart';
import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:commercial_app/presentation/screens/home/home_screen.dart';
import 'package:commercial_app/presentation/screens/sign_in/components/sign_in_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String?> errors = <String?>[];
  String? login;
  String? password;
  bool _showPassword = false;
  FocusNode loginFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  late final VoidCallback _loginFocusListener;
  late final VoidCallback _passwordFocusListener;

  // Инициализация значений
  @override
  void initState() {
    super.initState();
    _loginFocusListener = () {
      setState(() {});
    };
    loginFocusNode.addListener(_loginFocusListener);
    _passwordFocusListener = () {
      setState(() {});
    };
    passwordFocusNode.addListener(_passwordFocusListener);
  }

  // Освобождение памяти
  @override
  void dispose() {
    loginFocusNode.removeListener(_loginFocusListener);
    passwordFocusNode.removeListener(_passwordFocusListener);
    loginFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  // Метод отображения ошибки
  void _addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  // Метод скрытия ошибки
  void _removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  // Метод смены видимости пароля при нажатии на кнопку
  void _toggleShowPassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  // Проверка логина и пароля при помощи Firebase Firestore
  Future<void> _onCheckLogin() async {
    setState(() {
      errors.clear();
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        QuerySnapshot<Map<String, dynamic>> userSnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .where('login', isEqualTo: login)
                .limit(1)
                .get();
        if (userSnapshot.docs.isNotEmpty) {
          Map<String, dynamic> userData = userSnapshot.docs.first.data();
          if (userData['password'] == password) {
            // Передача значения name из Firebase Firestore в зависимости от логина пользователя
            context
                .read<DataCubit>()
                .saveText('specialist_name', userData['name']);
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                ) =>
                    HomeScreen(userName: userData['name']),
                transitionsBuilder: (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child,
                ) {
                  return child;
                },
              ),
            );
          } else {
            _addError(error: S.of(context).wrongPassword);
          }
        } else {
          _addError(error: S.of(context).wrongLogin);
        }
      } catch (e) {
        _addError(error: e.toString());
      }
    }
  }

  // build-метод для логина
  TextFormField buildLoginFormField() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      focusNode: loginFocusNode,
      autocorrect: false,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      onSaved: (String? newValue) => login = newValue,
      // Скрытие ошибки при выполнении одного из условий для логина
      onChanged: (String value) {
        if (value.isNotEmpty) {
          _removeError(error: S.of(context).loginIsNotEmpty);
        }
        if (value.length == 11) {
          _removeError(error: S.of(context).loginTooLong);
          _removeError(error: S.of(context).loginTooShort);
        } else if (value.length > 11) {
          _removeError(error: S.of(context).loginTooShort);
        } else if (value.length < 11) {
          _removeError(error: S.of(context).loginTooLong);
        }
      },
      // Отображение ошибки при выполнении одного из условий для логина
      validator: (String? value) {
        if (value!.isEmpty) {
          _addError(error: S.of(context).loginIsNotEmpty);
          return '';
        } else if (value.length > 11) {
          _addError(error: S.of(context).loginTooLong);
          return '';
        } else if (value.length < 11) {
          _addError(error: S.of(context).loginTooShort);
          return '';
        }
        return null;
      },
      cursorColor: mainColor,
      decoration: baseInputDecoration.copyWith(
        labelText: S.of(context).loginLabelText,
        hintText: S.of(context).loginHintText,
        labelStyle: TextStyle(
          fontSize: mainFontSize,
          color: loginFocusNode.hasFocus ? mainColor : null,
        ),
      ),
      style: const TextStyle(
        fontSize: mainFontSize,
      ),
    );
  }

  // build-метод для пароля
  TextFormField buildPasswordFormField() {
    return TextFormField(
      focusNode: passwordFocusNode,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (String value) {
        _onCheckLogin();
      },
      obscureText: !_showPassword,
      autocorrect: false,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(
          textRegExp,
        ),
      ],
      onSaved: (String? newValue) => password = newValue,
      // Скрытие ошибки при выполнении одного из условий для пароля
      onChanged: (String value) {
        if (value.isNotEmpty) {
          _removeError(error: S.of(context).passwordIsNotEmpty);
        }
        if (value.length >= 8) {
          _removeError(error: S.of(context).passwordTooShort);
        }
      },
      // Отображение ошибки при выполнении одного из условий для пароля
      validator: (String? value) {
        if (value!.isEmpty) {
          _addError(error: S.of(context).passwordIsNotEmpty);
          return '';
        } else if (value.length < 8) {
          _addError(error: S.of(context).passwordTooShort);
          return '';
        }
        return null;
      },
      cursorColor: mainColor,
      decoration: baseInputDecoration.copyWith(
        labelText: S.of(context).passwordLabelText,
        labelStyle: TextStyle(
          fontSize: mainFontSize,
          color: passwordFocusNode.hasFocus ? mainColor : null,
        ),
        hintText: S.of(context).passwordHintText,
        // Кнопка смены видимости пароля
        suffixIcon: IconButton(
          icon: Icon(
            _showPassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: _toggleShowPassword,
        ),
      ),
      style: const TextStyle(
        fontSize: mainFontSize,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          buildLoginFormField(),
          SizedBox(
            height: SizeConfig.screenHeight * 0.03,
          ),
          buildPasswordFormField(),
          FormError(errors: errors),
          SizedBox(
            height: SizeConfig.screenHeight * 0.03,
          ),
          DefaultButton(
            text: S.of(context).entry,
            onPressed: _onCheckLogin,
          ),
        ],
      ),
    );
  }
}
