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

  /// `Привет мир!`
  String get helloWorld {
    return Intl.message(
      'Привет мир!',
      name: 'helloWorld',
      desc: '',
      args: [],
    );
  }

  /// `Мои дела`
  String get myTasks {
    return Intl.message(
      'Мои дела',
      name: 'myTasks',
      desc: '',
      args: [],
    );
  }

  /// `Выполнено - `
  String get done {
    return Intl.message(
      'Выполнено - ',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `СОХРАНИТЬ`
  String get save {
    return Intl.message(
      'СОХРАНИТЬ',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Удалить`
  String get delete {
    return Intl.message(
      'Удалить',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Низкий`
  String get lowPriority {
    return Intl.message(
      'Низкий',
      name: 'lowPriority',
      desc: '',
      args: [],
    );
  }

  /// `Высокий`
  String get highPriority {
    return Intl.message(
      'Высокий',
      name: 'highPriority',
      desc: '',
      args: [],
    );
  }

  /// `Нет`
  String get withoutPriority {
    return Intl.message(
      'Нет',
      name: 'withoutPriority',
      desc: '',
      args: [],
    );
  }

  /// `Важность`
  String get priority {
    return Intl.message(
      'Важность',
      name: 'priority',
      desc: '',
      args: [],
    );
  }

  /// `Сделать до`
  String get doneUntil {
    return Intl.message(
      'Сделать до',
      name: 'doneUntil',
      desc: '',
      args: [],
    );
  }

  /// `Надо сделать что-то`
  String get textExample {
    return Intl.message(
      'Надо сделать что-то',
      name: 'textExample',
      desc: '',
      args: [],
    );
  }

  /// `Удалено`
  String get deleted {
    return Intl.message(
      'Удалено',
      name: 'deleted',
      desc: '',
      args: [],
    );
  }

  /// `Отмена`
  String get cancel {
    return Intl.message(
      'Отмена',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Новое`
  String get newTask {
    return Intl.message(
      'Новое',
      name: 'newTask',
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
