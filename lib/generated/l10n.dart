// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome back!`
  String get welcomeBack {
    return Intl.message(
      'Welcome back!',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `To sign in enter your login and password`
  String get welcomeBackInf {
    return Intl.message(
      'To sign in enter your login and password',
      name: 'welcomeBackInf',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your login`
  String get loginIsNotEmpty {
    return Intl.message(
      'Please enter your login',
      name: 'loginIsNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Login is too long`
  String get loginTooLong {
    return Intl.message(
      'Login is too long',
      name: 'loginTooLong',
      desc: '',
      args: [],
    );
  }

  /// `Login is too short`
  String get loginTooShort {
    return Intl.message(
      'Login is too short',
      name: 'loginTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Enter your login`
  String get loginHintText {
    return Intl.message(
      'Enter your login',
      name: 'loginHintText',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginLabelText {
    return Intl.message(
      'Login',
      name: 'loginLabelText',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get passwordIsNotEmpty {
    return Intl.message(
      'Please enter your password',
      name: 'passwordIsNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Password is too short`
  String get passwordTooShort {
    return Intl.message(
      'Password is too short',
      name: 'passwordTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passwordLabelText {
    return Intl.message(
      'Password',
      name: 'passwordLabelText',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get passwordHintText {
    return Intl.message(
      'Enter your password',
      name: 'passwordHintText',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get entry {
    return Intl.message(
      'Sign in',
      name: 'entry',
      desc: '',
      args: [],
    );
  }

  /// `Auth`
  String get authorization {
    return Intl.message(
      'Auth',
      name: 'authorization',
      desc: '',
      args: [],
    );
  }

  /// `Order`
  String get order {
    return Intl.message(
      'Order',
      name: 'order',
      desc: '',
      args: [],
    );
  }

  /// `Order number`
  String get orderNumber {
    return Intl.message(
      'Order number',
      name: 'orderNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter order number`
  String get orderNumberEnter {
    return Intl.message(
      'Enter order number',
      name: 'orderNumberEnter',
      desc: '',
      args: [],
    );
  }

  /// `Inspection date`
  String get inspectionDate {
    return Intl.message(
      'Inspection date',
      name: 'inspectionDate',
      desc: '',
      args: [],
    );
  }

  /// `Enter inspection date`
  String get inspectionDateEnter {
    return Intl.message(
      'Enter inspection date',
      name: 'inspectionDateEnter',
      desc: '',
      args: [],
    );
  }

  /// `Specialist name`
  String get specialistName {
    return Intl.message(
      'Specialist name',
      name: 'specialistName',
      desc: '',
      args: [],
    );
  }

  /// `Enter specialist name`
  String get specialistNameEnter {
    return Intl.message(
      'Enter specialist name',
      name: 'specialistNameEnter',
      desc: '',
      args: [],
    );
  }

  /// `Customer name`
  String get customerName {
    return Intl.message(
      'Customer name',
      name: 'customerName',
      desc: '',
      args: [],
    );
  }

  /// `Enter customer name`
  String get customerNameEnter {
    return Intl.message(
      'Enter customer name',
      name: 'customerNameEnter',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get requiredField {
    return Intl.message(
      'This field is required',
      name: 'requiredField',
      desc: '',
      args: [],
    );
  }

  /// `Disadvantages`
  String get remarks {
    return Intl.message(
      'Disadvantages',
      name: 'remarks',
      desc: '',
      args: [],
    );
  }

  /// `You removed the disadvantage`
  String get removedShortcoming {
    return Intl.message(
      'You removed the disadvantage',
      name: 'removedShortcoming',
      desc: '',
      args: [],
    );
  }

  /// `Electrical`
  String get electricsItems {
    return Intl.message(
      'Electrical',
      name: 'electricsItems',
      desc: '',
      args: [],
    );
  }

  /// `Geometry`
  String get geometryItems {
    return Intl.message(
      'Geometry',
      name: 'geometryItems',
      desc: '',
      args: [],
    );
  }

  /// `Plumbing`
  String get plumbingEquipmentItems {
    return Intl.message(
      'Plumbing',
      name: 'plumbingEquipmentItems',
      desc: '',
      args: [],
    );
  }

  /// `Windows and Doors`
  String get windowsAndDoorsItems {
    return Intl.message(
      'Windows and Doors',
      name: 'windowsAndDoorsItems',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get finishingItems {
    return Intl.message(
      'Finish',
      name: 'finishingItems',
      desc: '',
      args: [],
    );
  }

  /// `Was there a thermal imaging inspection?`
  String get thermalImagingInspection {
    return Intl.message(
      'Was there a thermal imaging inspection?',
      name: 'thermalImagingInspection',
      desc: '',
      args: [],
    );
  }

  /// `Select the rooms`
  String get selectRoom {
    return Intl.message(
      'Select the rooms',
      name: 'selectRoom',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Сhoose the rooms`
  String get specifyRoom {
    return Intl.message(
      'Сhoose the rooms',
      name: 'specifyRoom',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in all the required fields`
  String get requiredAllField {
    return Intl.message(
      'Please fill in all the required fields',
      name: 'requiredAllField',
      desc: '',
      args: [],
    );
  }

  /// `Measurements`
  String get measurements {
    return Intl.message(
      'Measurements',
      name: 'measurements',
      desc: '',
      args: [],
    );
  }

  /// `Options`
  String get options {
    return Intl.message(
      'Options',
      name: 'options',
      desc: '',
      args: [],
    );
  }

  /// `Additional options`
  String get additionalOptions {
    return Intl.message(
      'Additional options',
      name: 'additionalOptions',
      desc: '',
      args: [],
    );
  }

  /// `Radiation level`
  String get radiationLevel {
    return Intl.message(
      'Radiation level',
      name: 'radiationLevel',
      desc: '',
      args: [],
    );
  }

  /// `uSv/h`
  String get radiationSI {
    return Intl.message(
      'uSv/h',
      name: 'radiationSI',
      desc: '',
      args: [],
    );
  }

  /// `Ammonia level`
  String get ammoniaLevel {
    return Intl.message(
      'Ammonia level',
      name: 'ammoniaLevel',
      desc: '',
      args: [],
    );
  }

  /// `mg/m3`
  String get ammoniaSI {
    return Intl.message(
      'mg/m3',
      name: 'ammoniaSI',
      desc: '',
      args: [],
    );
  }

  /// `EM field level`
  String get electromagneticFieldLevel {
    return Intl.message(
      'EM field level',
      name: 'electromagneticFieldLevel',
      desc: '',
      args: [],
    );
  }

  /// `μT`
  String get electromagneticFieldSI {
    return Intl.message(
      'μT',
      name: 'electromagneticFieldSI',
      desc: '',
      args: [],
    );
  }

  /// `Airflow speed`
  String get airflowSpeed {
    return Intl.message(
      'Airflow speed',
      name: 'airflowSpeed',
      desc: '',
      args: [],
    );
  }

  /// `Kitchen`
  String get airflowKitchen {
    return Intl.message(
      'Kitchen',
      name: 'airflowKitchen',
      desc: '',
      args: [],
    );
  }

  /// `m/s`
  String get airflowSI {
    return Intl.message(
      'm/s',
      name: 'airflowSI',
      desc: '',
      args: [],
    );
  }

  /// `Bath №1`
  String get bath1 {
    return Intl.message(
      'Bath №1',
      name: 'bath1',
      desc: '',
      args: [],
    );
  }

  /// `Bath №2`
  String get bath2 {
    return Intl.message(
      'Bath №2',
      name: 'bath2',
      desc: '',
      args: [],
    );
  }

  /// `Bath №3`
  String get bath3 {
    return Intl.message(
      'Bath №3',
      name: 'bath3',
      desc: '',
      args: [],
    );
  }

  /// `Is a thermal imaging inspection report required?`
  String get thermalImagingConclusion {
    return Intl.message(
      'Is a thermal imaging inspection report required?',
      name: 'thermalImagingConclusion',
      desc: '',
      args: [],
    );
  }

  /// `Was the underfloor heating checked with a thermal imager?`
  String get underfloorHeating {
    return Intl.message(
      'Was the underfloor heating checked with a thermal imager?',
      name: 'underfloorHeating',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `No disadvantages found`
  String get remarksNotFound {
    return Intl.message(
      'No disadvantages found',
      name: 'remarksNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Edit disadvantage`
  String get remarksEdit {
    return Intl.message(
      'Edit disadvantage',
      name: 'remarksEdit',
      desc: '',
      args: [],
    );
  }

  /// `No selected rooms`
  String get roomsNotSelected {
    return Intl.message(
      'No selected rooms',
      name: 'roomsNotSelected',
      desc: '',
      args: [],
    );
  }

  /// `If there are no disadvantages, insert a dash`
  String get noRemarks {
    return Intl.message(
      'If there are no disadvantages, insert a dash',
      name: 'noRemarks',
      desc: '',
      args: [],
    );
  }

  /// `List is empty`
  String get listEmpty {
    return Intl.message(
      'List is empty',
      name: 'listEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Act preview`
  String get preview {
    return Intl.message(
      'Act preview',
      name: 'preview',
      desc: '',
      args: [],
    );
  }

  /// `Not specified`
  String get notSpecified {
    return Intl.message(
      'Not specified',
      name: 'notSpecified',
      desc: '',
      args: [],
    );
  }

  /// `Paid services`
  String get paidServices {
    return Intl.message(
      'Paid services',
      name: 'paidServices',
      desc: '',
      args: [],
    );
  }

  /// `Main information about an order`
  String get orderMainInf {
    return Intl.message(
      'Main information about an order',
      name: 'orderMainInf',
      desc: '',
      args: [],
    );
  }

  /// `Generate`
  String get actForm {
    return Intl.message(
      'Generate',
      name: 'actForm',
      desc: '',
      args: [],
    );
  }

  /// `The document is being produced. Please wait.`
  String get actFormWait {
    return Intl.message(
      'The document is being produced. Please wait.',
      name: 'actFormWait',
      desc: '',
      args: [],
    );
  }

  /// `Image preview`
  String get imagePreview {
    return Intl.message(
      'Image preview',
      name: 'imagePreview',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Leave`
  String get leave {
    return Intl.message(
      'Leave',
      name: 'leave',
      desc: '',
      args: [],
    );
  }

  /// `List of disadvanteges`
  String get remarksList {
    return Intl.message(
      'List of disadvanteges',
      name: 'remarksList',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Preview`
  String get previewButton {
    return Intl.message(
      'Preview',
      name: 'previewButton',
      desc: '',
      args: [],
    );
  }

  /// `Commercial space`
  String get commercialSpace {
    return Intl.message(
      'Commercial space',
      name: 'commercialSpace',
      desc: '',
      args: [],
    );
  }

  /// `Living room`
  String get room {
    return Intl.message(
      'Living room',
      name: 'room',
      desc: '',
      args: [],
    );
  }

  /// `Kitchen`
  String get kitchen {
    return Intl.message(
      'Kitchen',
      name: 'kitchen',
      desc: '',
      args: [],
    );
  }

  /// `Kitchen-living room`
  String get kitchenLivingRoom {
    return Intl.message(
      'Kitchen-living room',
      name: 'kitchenLivingRoom',
      desc: '',
      args: [],
    );
  }

  /// `Hall`
  String get hall {
    return Intl.message(
      'Hall',
      name: 'hall',
      desc: '',
      args: [],
    );
  }

  /// `Balcony`
  String get balcony {
    return Intl.message(
      'Balcony',
      name: 'balcony',
      desc: '',
      args: [],
    );
  }

  /// `Bath`
  String get bath {
    return Intl.message(
      'Bath',
      name: 'bath',
      desc: '',
      args: [],
    );
  }

  /// `Bathroom`
  String get bathroom {
    return Intl.message(
      'Bathroom',
      name: 'bathroom',
      desc: '',
      args: [],
    );
  }

  /// `Wardrobe`
  String get wardrobe {
    return Intl.message(
      'Wardrobe',
      name: 'wardrobe',
      desc: '',
      args: [],
    );
  }

  /// `No measurement was made`
  String get measurementIsNotTaken {
    return Intl.message(
      'No measurement was made',
      name: 'measurementIsNotTaken',
      desc: '',
      args: [],
    );
  }

  /// `All lists must be the same length`
  String get listLength {
    return Intl.message(
      'All lists must be the same length',
      name: 'listLength',
      desc: '',
      args: [],
    );
  }

  /// `The permission to access memory has not been granted`
  String get accessPermission {
    return Intl.message(
      'The permission to access memory has not been granted',
      name: 'accessPermission',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clearTheData {
    return Intl.message(
      'Clear',
      name: 'clearTheData',
      desc: '',
      args: [],
    );
  }

  /// `Data was cleared successfully`
  String get dataClearedSuccessfully {
    return Intl.message(
      'Data was cleared successfully',
      name: 'dataClearedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Data cleaning error`
  String get dataCleaningError {
    return Intl.message(
      'Data cleaning error',
      name: 'dataCleaningError',
      desc: '',
      args: [],
    );
  }

  /// `Clear the data?`
  String get clearTheDataAndStartOver {
    return Intl.message(
      'Clear the data?',
      name: 'clearTheDataAndStartOver',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection`
  String get noInternetConnection {
    return Intl.message(
      'No internet connection',
      name: 'noInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get tryAgain {
    return Intl.message(
      'Try again',
      name: 'tryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Wrong password`
  String get wrongPassword {
    return Intl.message(
      'Wrong password',
      name: 'wrongPassword',
      desc: '',
      args: [],
    );
  }

  /// `Wrong login`
  String get wrongLogin {
    return Intl.message(
      'Wrong login',
      name: 'wrongLogin',
      desc: '',
      args: [],
    );
  }

  /// `Error login and password check`
  String get errorLoginAndPasswordCheck {
    return Intl.message(
      'Error login and password check',
      name: 'errorLoginAndPasswordCheck',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure delete this remark?`
  String get removeRemark {
    return Intl.message(
      'Are you sure delete this remark?',
      name: 'removeRemark',
      desc: '',
      args: [],
    );
  }

  /// `The photo is being uploaded. Please wait.`
  String get photoWait {
    return Intl.message(
      'The photo is being uploaded. Please wait.',
      name: 'photoWait',
      desc: '',
      args: [],
    );
  }

  /// `Conversion error`
  String get conversionError {
    return Intl.message(
      'Conversion error',
      name: 'conversionError',
      desc: '',
      args: [],
    );
  }

  /// `Save to docx`
  String get saveDocx {
    return Intl.message(
      'Save to docx',
      name: 'saveDocx',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Task execution error`
  String get taskExecutionError {
    return Intl.message(
      'Task execution error',
      name: 'taskExecutionError',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect request. Check the parameters.`
  String get badRequestError {
    return Intl.message(
      'Incorrect request. Check the parameters.',
      name: 'badRequestError',
      desc: '',
      args: [],
    );
  }

  /// `Authorization error. Check the API key.`
  String get unauthorizedError {
    return Intl.message(
      'Authorization error. Check the API key.',
      name: 'unauthorizedError',
      desc: '',
      args: [],
    );
  }

  /// `You have run out of free conversions. Try again later or save the document in docx format.`
  String get paymentRequiredError {
    return Intl.message(
      'You have run out of free conversions. Try again later or save the document in docx format.',
      name: 'paymentRequiredError',
      desc: '',
      args: [],
    );
  }

  /// `Access is prohibited.`
  String get forbiddenError {
    return Intl.message(
      'Access is prohibited.',
      name: 'forbiddenError',
      desc: '',
      args: [],
    );
  }

  /// `Resource not found.`
  String get notFoundError {
    return Intl.message(
      'Resource not found.',
      name: 'notFoundError',
      desc: '',
      args: [],
    );
  }

  /// `Internal server error. Try again later.`
  String get internalServerError {
    return Intl.message(
      'Internal server error. Try again later.',
      name: 'internalServerError',
      desc: '',
      args: [],
    );
  }

  /// `The service is temporarily unavailable.`
  String get serviceUnavailableError {
    return Intl.message(
      'The service is temporarily unavailable.',
      name: 'serviceUnavailableError',
      desc: '',
      args: [],
    );
  }

  /// `An unknown error occurred (code: $statusCode).`
  String get unknownErrorOccurred {
    return Intl.message(
      'An unknown error occurred (code: \$statusCode).',
      name: 'unknownErrorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `Change the rooms`
  String get changeRoom {
    return Intl.message(
      'Change the rooms',
      name: 'changeRoom',
      desc: '',
      args: [],
    );
  }

  /// `Unknown error`
  String get unknownError {
    return Intl.message(
      'Unknown error',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}