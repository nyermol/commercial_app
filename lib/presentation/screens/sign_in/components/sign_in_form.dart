// ignore_for_file: always_specify_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/presentation/widgets/default_button.dart';
import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/presentation/cubit/cubit_export.dart';
import 'package:commercial_app/presentation/screens/home/home_screen.dart';
import 'package:commercial_app/presentation/screens/sign_in/components/sign_in_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String?> errors = <String?>[];
  String? login;
  String? password;
  bool _showPassword = false;

  void _addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void _removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  void _toggleShowPassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  Future<void> _onCheckLogin() async {
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
            // ignore: use_build_context_synchronously
            context
                .read<DataCubit>()
                .saveText('specialist_name', userData['name']);
            Navigator.push(
              // ignore: use_build_context_synchronously
              context,
              PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation<double> animation,
                        Animation<double> secondaryAnimation,) =>
                    HomeScreen(userName: userData['name']),
                transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child,) {
                  return child;
                },
              ),
            );
          } else {
            _addError(error: 'Неправильный пароль');
          }
        } else {
          _addError(error: 'Неправильный логин');
        }
      } catch (e) {
        _addError(error: 'Ошибка при проверке логина и пароля');
      }
    }
  }

  TextFormField buildLoginFormField() {
    return TextFormField(
        autofillHints: const <String>[AutofillHints.telephoneNumber],
        keyboardType: TextInputType.datetime,
        textInputAction: TextInputAction.next,
        autocorrect: false,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(numberRegExp),
        ],
        onSaved: (String? newValue) => login = newValue,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            _removeError(error: S.of(context).loginIsNotEmpty);
          } else if (value.length >= 11) {
            _removeError(error: S.of(context).loginTooLong);
          } else if (value.length <= 11) {
            _removeError(error: S.of(context).loginTooShort);
          }
        },
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
        decoration: baseInputDecoration.copyWith(
            labelText: S.of(context).loginLabelText,
            hintText: S.of(context).loginHintText,),);
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
        obscureText: !_showPassword,
        autocorrect: false,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(textRegExp),
        ],
        onSaved: (String? newValue) => password = newValue,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            _removeError(error: S.of(context).passwordIsNotEmpty);
          } else if (value.length >= 8) {
            _removeError(error: S.of(context).passwordTooShort);
          }
        },
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
        decoration: baseInputDecoration.copyWith(
          labelText: S.of(context).passwordLabelText,
          hintText: S.of(context).passwordHintText,
          suffixIcon: IconButton(
              icon: Icon(
                _showPassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: _toggleShowPassword,),
        ),);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          buildLoginFormField(),
          SizedBox(height: SizeConfig.screenHeight * 0.03),
          buildPasswordFormField(),
          FormError(errors: errors),
          SizedBox(height: SizeConfig.screenHeight * 0.03),
          DefaultButton(
            text: S.of(context).entry,
            onPressed: _onCheckLogin,
          ),
        ],
      ),
    );
  }
}
