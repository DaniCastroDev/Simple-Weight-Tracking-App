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
