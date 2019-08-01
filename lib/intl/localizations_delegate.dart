import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DemoLocalizations {
  DemoLocalizations(this.locale);

  final Locale locale;

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'ibmTitle': 'IBM Calculator',
      'history': 'History',
      'today': 'Today',
      'yesterday': 'Yesterday',
      'seeAll': 'See all',
      'addWeight': 'Add Weight',
      'save': 'Save',
      'metric': 'Metric\nSystem',
      'imperial': 'Imperial\nSystem',
      'height': 'Height',
      'initialWeight': 'Initial weight',
      'objectiveWeight': 'Objective weight',
      'saveSettings': 'Save Settings',
      'settings': 'Settings',
      'lowWeight': 'Low weight',
      'normalWeight': 'Normal weight',
      'overWeight': 'Overweight',
      'obesityWeight': 'Obesity',
      'lastWeek': 'Last week',
      'lastMonth': 'Last month',
      'lastYear': 'Last year',
      'notEnoughData': 'Not enough data to create the chart',
      'signIn': 'Log In',
      'register': 'Sign In',
      'signInWithGoogle': 'Sign in with Google',
      'email': 'Email',
      'password': 'Password',
      'repeatPassword': 'Repeat the password',
      'notSamePassword': 'The passwords are not the same',
      'enterText': 'Please, enter some text',
      'dontHaveAccount': 'Don\'t have an account?',
      'forgotPassword': 'Forgot your Password?',
      'otherAccounts': 'Or log in with another account',
      'termsAndConditions': 'I have read and accept the terms and conditions',
      'sex': 'Sex',
      'age': 'Age',
      'male': 'Male',
      'female': 'Female',
      'other': 'Other',
    },
    'es': {
      'ibmTitle': 'Calculadora de IMC',
      'history': 'Historial',
      'today': 'Hoy',
      'yesterday': 'Ayer',
      'seeAll': 'Ver todo',
      'addWeight': 'Añadir peso',
      'save': 'Guardar',
      'metric': 'Sistema\nMétrico',
      'imperial': 'Sistema\nImperial',
      'height': 'Altura',
      'initialWeight': 'Peso inicial',
      'objectiveWeight': 'Peso objetivo',
      'saveSettings': 'Guardar Ajustes',
      'settings': 'Ajustes',
      'lowWeight': 'Bajo peso',
      'normalWeight': 'Peso normal',
      'overWeight': 'Sobrepeso',
      'obesityWeight': 'Obesidad',
      'lastWeek': 'Última semana',
      'lastMonth': 'Último mes',
      'lastYear': 'Último año',
      'notEnoughData': 'No hay datos suficientes para mostrar la gráfica',
      'signIn': 'Acceder',
      'register': 'Regístrate',
      'signInWithGoogle': 'Accede con Google',
      'email': 'Email',
      'password': 'Contraseña',
      'repeatPassword': 'Repite la constraseña',
      'notSamePassword': 'Las contraseñas no coinciden',
      'enterText': 'Por favor, introduzca texto',
      'dontHaveAccount': '¿No tienes una cuenta?',
      'forgotPassword': '¿Olvidaste tu contraseña?',
      'otherAccounts': 'O accede con otra cuenta',
      'termsAndConditions': 'He leído y acepto los términos y condiciones del servicio',
      'sex': 'Sexo',
      'age': 'Edad',
      'male': 'Masculino',
      'female': 'Femenino',
      'other': 'Otro',
    },
  };

  String get ibmTitle {
    return _localizedValues[locale.languageCode]['ibmTitle'];
  }

  String get history {
    return _localizedValues[locale.languageCode]['history'];
  }

  String get today {
    return _localizedValues[locale.languageCode]['today'];
  }

  String get yesterday {
    return _localizedValues[locale.languageCode]['yesterday'];
  }

  String get seeAll {
    return _localizedValues[locale.languageCode]['seeAll'];
  }

  String get addWeight {
    return _localizedValues[locale.languageCode]['addWeight'];
  }

  String get save {
    return _localizedValues[locale.languageCode]['save'];
  }

  String get metric {
    return _localizedValues[locale.languageCode]['metric'];
  }

  String get imperial {
    return _localizedValues[locale.languageCode]['imperial'];
  }

  String get height {
    return _localizedValues[locale.languageCode]['height'];
  }

  String get initialWeight {
    return _localizedValues[locale.languageCode]['initialWeight'];
  }

  String get objectiveWeight {
    return _localizedValues[locale.languageCode]['objectiveWeight'];
  }

  String get saveSettings {
    return _localizedValues[locale.languageCode]['saveSettings'];
  }

  String get settings {
    return _localizedValues[locale.languageCode]['settings'];
  }

  String get lowWeight {
    return _localizedValues[locale.languageCode]['lowWeight'];
  }

  String get normalWeight {
    return _localizedValues[locale.languageCode]['normalWeight'];
  }

  String get overWeight {
    return _localizedValues[locale.languageCode]['overWeight'];
  }

  String get obesityWeight {
    return _localizedValues[locale.languageCode]['obesityWeight'];
  }

  String get lastWeek {
    return _localizedValues[locale.languageCode]['lastWeek'];
  }

  String get lastMonth {
    return _localizedValues[locale.languageCode]['lastMonth'];
  }

  String get lastYear {
    return _localizedValues[locale.languageCode]['lastYear'];
  }

  String get notEnoughData {
    return _localizedValues[locale.languageCode]['notEnoughData'];
  }

  String get signIn {
    return _localizedValues[locale.languageCode]['signIn'];
  }

  String get register {
    return _localizedValues[locale.languageCode]['register'];
  }

  String get signInWithGoogle {
    return _localizedValues[locale.languageCode]['signInWithGoogle'];
  }

  String get email {
    return _localizedValues[locale.languageCode]['email'];
  }

  String get password {
    return _localizedValues[locale.languageCode]['password'];
  }

  String get repeatPassword {
    return _localizedValues[locale.languageCode]['repeatPassword'];
  }

  String get notSamePassword {
    return _localizedValues[locale.languageCode]['notSamePassword'];
  }

  String get enterText {
    return _localizedValues[locale.languageCode]['enterText'];
  }

  String get dontHaveAccount {
    return _localizedValues[locale.languageCode]['dontHaveAccount'];
  }

  String get forgotPassword {
    return _localizedValues[locale.languageCode]['forgotPassword'];
  }

  String get otherAccounts {
    return _localizedValues[locale.languageCode]['otherAccounts'];
  }

  String get termsAndConditions {
    return _localizedValues[locale.languageCode]['termsAndConditions'];
  }

  String get sex {
    return _localizedValues[locale.languageCode]['sex'];
  }

  String get age {
    return _localizedValues[locale.languageCode]['age'];
  }

  String get male {
    return _localizedValues[locale.languageCode]['male'];
  }

  String get female {
    return _localizedValues[locale.languageCode]['female'];
  }

  String get other {
    return _localizedValues[locale.languageCode]['other'];
  }
}

class CustomLocalizationsDelegate extends LocalizationsDelegate<DemoLocalizations> {
  const CustomLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<DemoLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<DemoLocalizations>(DemoLocalizations(locale));
  }

  @override
  bool shouldReload(CustomLocalizationsDelegate old) => false;
}
